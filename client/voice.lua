--[[
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
                                                                        
    🐺 LXR Voice Range - Client Script
    
    This client script handles voice proximity control for RedM servers.
    Players can cycle through different voice ranges (whisper, normal, yell)
    by pressing a configurable key. Visual feedback is provided through a
    colored circle indicator.
    
    Features:
    - Multi-level voice proximity (whisper/normal/yell)
    - Visual range indicator (colored circle)
    - Framework-agnostic notifications
    - Optimized performance with minimal FPS impact
    - Anti-spam cooldown system
    - Multi-language support
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerLoaded = false
local CurrentVoiceRange = Config.DefaultVoiceRange
local CurrentDistance = Config.VoiceRanges[Config.DefaultVoiceRange].distance
local LastVoiceChange = 0
local CachedPlayerPed = nil
local LastPedUpdate = 0

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ HELPER FUNCTIONS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Get Player Ped with Caching
    Returns cached PlayerPedId for performance optimization
]]

local function GetCachedPlayerPed()
    local currentTime = GetGameTimer()
    
    if Config.Performance.CachePlayerPed then
        if not CachedPlayerPed or (currentTime - LastPedUpdate) > Config.Performance.CacheUpdateInterval then
            CachedPlayerPed = PlayerPedId()
            LastPedUpdate = currentTime
        end
        return CachedPlayerPed
    else
        return PlayerPedId()
    end
end

--[[
    Get Next Voice Range
    Cycles to the next voice range in the configured order
    
    @return string: Next voice range name
]]

local function GetNextVoiceRange()
    local currentIndex = 1
    
    -- Find current range index
    for i, rangeName in ipairs(Config.VoiceCycleOrder) do
        if rangeName == CurrentVoiceRange then
            currentIndex = i
            break
        end
    end
    
    -- Get next index (cycle back to 1 if at end)
    local nextIndex = currentIndex + 1
    if nextIndex > #Config.VoiceCycleOrder then
        nextIndex = 1
    end
    
    return Config.VoiceCycleOrder[nextIndex]
end

--[[
    Check Voice Change Cooldown
    Prevents spam by enforcing cooldown between changes
    
    @return boolean: true if cooldown passed, false if still on cooldown
]]

local function CanChangeVoice()
    local currentTime = GetGameTimer()
    local timeSinceLastChange = currentTime - LastVoiceChange
    
    if timeSinceLastChange < Config.Cooldowns.VoiceChangeDelay then
        if Config.Debug.LogVoiceChanges then
            print('^3[LXR-VoiceRange]^0 Voice change on cooldown: ' .. 
                  (Config.Cooldowns.VoiceChangeDelay - timeSinceLastChange) .. 'ms remaining')
        end
        return false
    end
    
    return true
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ VOICE RANGE FUNCTIONS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Apply Voice Native Settings
    Calls RedM natives to set voice proximity distance
    
    @param distance: Voice distance in game units
]]

local function ApplyVoiceNatives(distance)
    -- Apply voice proximity natives
    Citizen.InvokeNative(Config.Natives.VoiceNative1, distance)
    Citizen.InvokeNative(Config.Natives.VoiceNative2)
    Citizen.InvokeNative(Config.Natives.DrawMarker, distance)
    Citizen.InvokeNative(Config.Natives.VoiceNative4, distance)
    
    if Config.Debug.ShowNativeCalls then
        print('^2[LXR-VoiceRange]^0 Applied voice natives with distance: ^3' .. distance .. '^0')
    end
end

--[[
    Change Voice Range
    Changes the current voice range and applies settings
    
    @param newRange: New voice range name ('whisper', 'normal', 'yell')
]]

local function ChangeVoiceRange(newRange)
    if not Config.General.AllowProximityChange then
        return
    end
    
    if not CanChangeVoice() then
        Framework.Notify('warning', Framework.GetMessage('cooldown'))
        return
    end
    
    local rangeConfig = Config.VoiceRanges[newRange]
    
    if not rangeConfig then
        print('^1[LXR-VoiceRange] ERROR:^0 Invalid voice range: ' .. tostring(newRange))
        return
    end
    
    -- Update state
    CurrentVoiceRange = newRange
    CurrentDistance = rangeConfig.distance
    LastVoiceChange = GetGameTimer()
    
    -- Apply natives
    ApplyVoiceNatives(CurrentDistance)
    
    -- Notify player
    local label = Framework.GetVoiceLabel(newRange)
    Framework.Notify('info', Framework.GetMessage('voiceChanged', label))
    
    -- Trigger server event for validation (if security enabled)
    if Config.Security.EnableServerValidation then
        Framework.TriggerEvent('server', 'voicerange:validate', CurrentDistance)
    end
    
    if Config.Debug.LogVoiceChanges then
        print(string.format('^2[LXR-VoiceRange]^0 Changed to %s (%.1f units)', label, CurrentDistance))
    end
end

--[[
    Draw Voice Range Indicator
    Draws a colored circle around the player showing voice range
]]

local function DrawVoiceIndicator()
    if not Config.General.ShowVisualIndicator then
        return
    end
    
    local playerPed = GetCachedPlayerPed()
    local playerPos = GetEntityCoords(playerPed)
    local rangeConfig = Config.VoiceRanges[CurrentVoiceRange]
    
    if not rangeConfig then
        return
    end
    
    local color = rangeConfig.color
    
    -- Draw colored sphere/marker around player
    Citizen.InvokeNative(
        Config.Natives.DrawMarker,
        Config.Natives.MarkerHash,
        playerPos.x,
        playerPos.y,
        playerPos.z + Config.Visual.CircleHeight,
        0, 0, 0, 0, 0, 0,
        CurrentDistance * 2,
        CurrentDistance * 2,
        Config.Visual.CircleRadius,
        color.r,
        color.g,
        color.b,
        color.a,
        0, 0, 2, 0, 0, 0, 0, 0
    )
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EVENT HANDLERS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Player Spawned Event
    Initializes voice settings when player spawns
]]

AddEventHandler('playerSpawned', function()
    if Config.General.Debug then
        print('^2[LXR-VoiceRange]^0 Player spawned, initializing voice settings...')
    end
    
    -- Wait a moment for game to fully load
    Citizen.Wait(500)
    
    -- Apply default voice range
    local defaultRange = Config.VoiceRanges[Config.DefaultVoiceRange]
    if defaultRange then
        CurrentDistance = defaultRange.distance
        ApplyVoiceNatives(CurrentDistance)
        
        if Config.General.Debug then
            print('^2[LXR-VoiceRange]^0 Default voice range applied: ' .. 
                  Config.DefaultVoiceRange .. ' (' .. CurrentDistance .. ' units)')
        end
    end
    
    PlayerLoaded = true
end)

--[[
    Framework Player Loaded Events
    Handle framework-specific player loaded events
]]

-- LXR-Core / RSG-Core / QBR / QR
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerLoaded = true
    if Config.Debug.ShowFrameworkDetection then
        print('^2[LXR-VoiceRange]^0 Framework player loaded event received')
    end
end)

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    PlayerLoaded = true
    if Config.Debug.ShowFrameworkDetection then
        print('^2[LXR-VoiceRange]^0 RSG Framework player loaded')
    end
end)

-- VORP Core
RegisterNetEvent('vorp:SelectedCharacter', function()
    PlayerLoaded = true
    if Config.Debug.ShowFrameworkDetection then
        print('^2[LXR-VoiceRange]^0 VORP character selected')
    end
end)

-- RedEM:RP
RegisterNetEvent('redemrp:playerLoaded', function()
    PlayerLoaded = true
    if Config.Debug.ShowFrameworkDetection then
        print('^2[LXR-VoiceRange]^0 RedEM player loaded')
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ MAIN THREADS ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Main Input Thread
    Handles key press detection for voice range cycling
]]

Citizen.CreateThread(function()
    while true do
        local wait = Config.Performance.MainThreadWait
        
        if Config.General.EnableVoiceRange and PlayerLoaded then
            -- Check for voice change key press
            if IsControlJustPressed(0, Config.Keys.VoiceChange) and Config.General.AllowProximityChange then
                local nextRange = GetNextVoiceRange()
                ChangeVoiceRange(nextRange)
            end
            
            -- Check if key is held for visual indicator
            if IsControlPressed(0, Config.Keys.VoiceChange) and Config.General.ShowVisualIndicator then
                if Config.Performance.DrawCircleOnlyWhenHolding then
                    DrawVoiceIndicator()
                end
            end
        else
            -- Player not loaded, use longer wait
            wait = Config.Performance.IdleThreadWait
        end
        
        Citizen.Wait(wait)
    end
end)

--[[
    Visual Indicator Thread (Optional)
    Continuously draws indicator if not using "hold to show" mode
]]

if Config.General.ShowVisualIndicator and not Config.Performance.DrawCircleOnlyWhenHolding then
    Citizen.CreateThread(function()
        while true do
            if Config.General.EnableVoiceRange and PlayerLoaded then
                if IsControlPressed(0, Config.Keys.VoiceChange) then
                    DrawVoiceIndicator()
                end
                Citizen.Wait(0)
            else
                Citizen.Wait(Config.Performance.IdleThreadWait)
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    -- Wait for framework to be ready
    while not Framework.Ready do
        Citizen.Wait(100)
    end
    
    if Config.General.Debug then
        print([[
            
            ═══════════════════════════════════════════════════════════════════════
            🐺 LXR Voice Range - Client Initialized
            ═══════════════════════════════════════════════════════════════════════
            
            Default Range: ]] .. Config.DefaultVoiceRange .. [[
            
            Distance: ]] .. Config.VoiceRanges[Config.DefaultVoiceRange].distance .. [[ units
            Visual Indicator: ]] .. tostring(Config.General.ShowVisualIndicator) .. [[
            
            Framework: ]] .. Framework.Active .. [[
            
            
            Press Z to cycle voice range
            Hold Z to show range indicator
            
            🐺 wolves.land - The Land of Wolves
            
            ═══════════════════════════════════════════════════════════════════════
            
        ]])
    end
end)
