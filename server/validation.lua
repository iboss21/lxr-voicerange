--[[
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
                                                                        
    🐺 LXR Voice Range - Server Script
    
    This server script provides validation and security for the voice range system.
    It tracks player voice changes, enforces rate limits, and logs suspicious activity.
    
    Features:
    - Server-side validation of voice range changes
    - Rate limiting to prevent abuse
    - Suspicious activity logging
    - Framework-agnostic player tracking
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerVoiceChanges = {}  -- Track voice changes per player for rate limiting

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ HELPER FUNCTIONS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Get Player Identifier
    Returns a unique identifier for the player
    
    @param source: Player server ID
    @return string: Player identifier
]]

local function GetPlayerIdentifier(source)
    -- Try different identifier types based on framework
    local identifiers = GetPlayerIdentifiers(source)
    
    for _, id in pairs(identifiers) do
        if string.find(id, 'license:') then
            return id
        end
    end
    
    -- Fallback to source if no license found
    return 'source_' .. source
end

--[[
    Initialize Player Tracking
    Sets up tracking data for a new player
    
    @param source: Player server ID
]]

local function InitializePlayer(source)
    local identifier = GetPlayerIdentifier(source)
    
    if not PlayerVoiceChanges[identifier] then
        PlayerVoiceChanges[identifier] = {
            changes = {},
            totalChanges = 0,
            lastReset = os.time()
        }
        
        if Config.Debug.EnableDebugPrints then
            print('^2[LXR-VoiceRange]^0 Initialized tracking for player: ' .. identifier)
        end
    end
end

--[[
    Clean Old Voice Changes
    Removes voice change records older than 1 minute
    
    @param identifier: Player identifier
]]

local function CleanOldChanges(identifier)
    if not PlayerVoiceChanges[identifier] then
        return
    end
    
    local currentTime = os.time()
    local changes = PlayerVoiceChanges[identifier].changes
    local validChanges = {}
    
    -- Keep only changes from the last minute
    for _, changeTime in ipairs(changes) do
        if (currentTime - changeTime) < 60 then
            table.insert(validChanges, changeTime)
        end
    end
    
    PlayerVoiceChanges[identifier].changes = validChanges
end

--[[
    Check Rate Limit
    Validates that player hasn't exceeded voice change rate limit
    
    @param source: Player server ID
    @return boolean: true if within rate limit, false if exceeded
]]

local function CheckRateLimit(source)
    if not Config.Security.EnableServerValidation then
        return true
    end
    
    local identifier = GetPlayerIdentifier(source)
    
    InitializePlayer(source)
    CleanOldChanges(identifier)
    
    local playerData = PlayerVoiceChanges[identifier]
    local changesInLastMinute = #playerData.changes
    
    if changesInLastMinute >= Config.Security.MaxVoiceChangesPerMinute then
        if Config.Security.LogSuspiciousActivity then
            print(string.format(
                '^3[LXR-VoiceRange] WARNING:^0 Player %s (%s) exceeded voice change rate limit: %d changes/min',
                GetPlayerName(source), identifier, changesInLastMinute
            ))
        end
        return false
    end
    
    return true
end

--[[
    Record Voice Change
    Logs a voice change for rate limiting
    
    @param source: Player server ID
]]

local function RecordVoiceChange(source)
    local identifier = GetPlayerIdentifier(source)
    
    InitializePlayer(source)
    
    local currentTime = os.time()
    table.insert(PlayerVoiceChanges[identifier].changes, currentTime)
    PlayerVoiceChanges[identifier].totalChanges = PlayerVoiceChanges[identifier].totalChanges + 1
    
    if Config.Debug.LogVoiceChanges then
        print(string.format(
            '^2[LXR-VoiceRange]^0 Player %s changed voice range (Total: %d)',
            GetPlayerName(source), PlayerVoiceChanges[identifier].totalChanges
        ))
    end
end

--[[
    Validate Voice Distance
    Checks if the requested distance is within allowed range
    
    @param distance: Requested voice distance
    @return boolean: true if valid, false if invalid
]]

local function ValidateDistance(distance)
    if not distance or type(distance) ~= 'number' then
        return false
    end
    
    if distance < Config.Security.MinAllowedDistance or 
       distance > Config.Security.MaxAllowedDistance then
        return false
    end
    
    -- Check if distance matches one of our configured ranges
    for _, rangeConfig in pairs(Config.VoiceRanges) do
        if math.abs(distance - rangeConfig.distance) < 0.1 then
            return true
        end
    end
    
    return false
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EVENT HANDLERS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Voice Range Validation Event
    Validates client voice range changes server-side
]]

RegisterNetEvent('lxr-core:server:voicerange:validate', function(distance)
    local source = source
    
    if not Config.Security.EnableServerValidation then
        return
    end
    
    -- Validate distance
    if not ValidateDistance(distance) then
        if Config.Security.LogSuspiciousActivity then
            print(string.format(
                '^1[LXR-VoiceRange] SECURITY:^0 Player %s (%d) attempted invalid distance: %.2f',
                GetPlayerName(source), source, distance
            ))
        end
        return
    end
    
    -- Check rate limit
    if not CheckRateLimit(source) then
        -- Rate limit exceeded - could kick/ban if desired
        if Config.Security.LogSuspiciousActivity then
            print(string.format(
                '^1[LXR-VoiceRange] SECURITY:^0 Player %s (%d) rate limit exceeded - possible spam',
                GetPlayerName(source), source
            ))
        end
        return
    end
    
    -- Valid change, record it
    RecordVoiceChange(source)
end)

-- Alternative event names for other frameworks
RegisterNetEvent('RSGCore:Server:voicerange:validate', function(distance)
    TriggerEvent('lxr-core:server:voicerange:validate', distance)
end)

RegisterNetEvent('vorp:server:voicerange:validate', function(distance)
    TriggerEvent('lxr-core:server:voicerange:validate', distance)
end)

RegisterNetEvent('lxr-voicerange:server:voicerange:validate', function(distance)
    TriggerEvent('lxr-core:server:voicerange:validate', distance)
end)

--[[
    Player Dropped Event
    Clean up tracking data when player disconnects
]]

AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    if PlayerVoiceChanges[identifier] then
        if Config.Debug.EnableDebugPrints then
            print(string.format(
                '^3[LXR-VoiceRange]^0 Cleaning up data for disconnected player: %s (Total changes: %d)',
                identifier, PlayerVoiceChanges[identifier].totalChanges
            ))
        end
        
        PlayerVoiceChanges[identifier] = nil
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CLEANUP THREAD ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Periodic Cleanup Thread
    Removes stale tracking data every 5 minutes
]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        
        local currentTime = os.time()
        local cleanedCount = 0
        
        for identifier, data in pairs(PlayerVoiceChanges) do
            -- Clean changes older than 1 minute
            CleanOldChanges(identifier)
            
            -- Remove player data if no recent activity (10+ minutes)
            if (currentTime - data.lastReset) > 600 then
                PlayerVoiceChanges[identifier] = nil
                cleanedCount = cleanedCount + 1
            end
        end
        
        if Config.Debug.EnableDebugPrints and cleanedCount > 0 then
            print('^2[LXR-VoiceRange]^0 Periodic cleanup: Removed ' .. cleanedCount .. ' stale player records')
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    -- Wait for framework to be ready
    while not Framework.Ready do
        Citizen.Wait(100)
    end
    
    print([[
        
        ═══════════════════════════════════════════════════════════════════════
        🐺 LXR Voice Range - Server Initialized
        ═══════════════════════════════════════════════════════════════════════
        
        Security Validation: ]] .. tostring(Config.Security.EnableServerValidation) .. [[
        
        Rate Limit: ]] .. Config.Security.MaxVoiceChangesPerMinute .. [[ changes/min
        Logging: ]] .. tostring(Config.Security.LogSuspiciousActivity) .. [[
        
        Framework: ]] .. Framework.Active .. [[
        
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════
        
    ]])
end)
