--[[
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
                                                                        
    🐺 LXR Voice Range - Framework Bridge / Adapter
    
    This file provides a unified framework adapter layer that allows the voice range
    system to work seamlessly across multiple RedM frameworks (LXR-Core, RSG-Core,
    VORP Core, RedEM:RP, QBR-Core, QR-Core) and standalone mode.
    
    The adapter auto-detects the running framework and provides unified functions
    for notifications, player data, and other framework-specific features.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK DETECTION & INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

Framework = {}
Framework.Active = 'standalone'
Framework.Object = nil
Framework.Ready = false

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK AUTO-DETECTION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.Detect()
    if Config.Framework ~= 'auto' then
        -- Manual framework specified
        Framework.Active = Config.Framework
        if Config.Debug.ShowFrameworkDetection then
            print('^3[LXR-VoiceRange]^0 Framework manually set to: ^2' .. Framework.Active .. '^0')
        end
        return Framework.Active
    end
    
    -- Auto-detect framework by checking running resources
    local detectionOrder = {
        {name = 'lxr-core', resource = 'lxr-core'},
        {name = 'rsg-core', resource = 'rsg-core'},
        {name = 'vorp_core', resource = 'vorp_core'},
        {name = 'redem_roleplay', resource = 'redem_roleplay'},
        {name = 'qbr-core', resource = 'qbr-core'},
        {name = 'qr-core', resource = 'qr-core'},
    }
    
    for _, framework in ipairs(detectionOrder) do
        local resourceState = GetResourceState(framework.resource)
        if resourceState == 'started' or resourceState == 'starting' then
            Framework.Active = framework.name
            if Config.Debug.ShowFrameworkDetection then
                print('^2[LXR-VoiceRange]^0 Framework detected: ^2' .. Framework.Active .. '^0')
            end
            return Framework.Active
        end
    end
    
    -- No framework detected, use standalone
    Framework.Active = 'standalone'
    if Config.Debug.ShowFrameworkDetection then
        print('^3[LXR-VoiceRange]^0 No framework detected, running in ^2standalone^0 mode')
    end
    
    return Framework.Active
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK INITIALIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.Initialize()
    Framework.Detect()
    
    -- Initialize framework-specific objects
    if Framework.Active == 'lxr-core' then
        -- LXR-Core initialization
        if GetResourceState('lxr-core') == 'started' then
            Framework.Object = exports['lxr-core']:GetCoreObject()
            Framework.Ready = true
        end
    elseif Framework.Active == 'rsg-core' then
        -- RSG-Core initialization
        if GetResourceState('rsg-core') == 'started' then
            Framework.Object = exports['rsg-core']:GetCoreObject()
            Framework.Ready = true
        end
    elseif Framework.Active == 'vorp_core' then
        -- VORP Core initialization
        if GetResourceState('vorp_core') == 'started' then
            Framework.Object = exports['vorp_core']:GetCore()
            Framework.Ready = true
        end
    elseif Framework.Active == 'redem_roleplay' then
        -- RedEM:RP initialization
        if GetResourceState('redem_roleplay') == 'started' then
            Framework.Object = exports['redem_roleplay']:GetFramework()
            Framework.Ready = true
        end
    elseif Framework.Active == 'qbr-core' then
        -- QBR-Core initialization
        if GetResourceState('qbr-core') == 'started' then
            Framework.Object = exports['qbr-core']:GetCoreObject()
            Framework.Ready = true
        end
    elseif Framework.Active == 'qr-core' then
        -- QR-Core initialization
        if GetResourceState('qr-core') == 'started' then
            Framework.Object = exports['qr-core']:GetCoreObject()
            Framework.Ready = true
        end
    else
        -- Standalone mode
        Framework.Ready = true
    end
    
    return Framework.Ready
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ UNIFIED ADAPTER FUNCTIONS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Unified Notification Function
    Sends notifications through the appropriate framework system
    
    @param type: 'success', 'error', 'info', 'warning'
    @param message: Notification message text
    @param duration: Optional duration in milliseconds
]]

function Framework.Notify(type, message, duration)
    if not Config.General.EnableNotifications then
        return
    end
    
    duration = duration or Config.Cooldowns.NotificationDuration
    
    local frameworkSettings = Config.FrameworkSettings[Framework.Active]
    
    if frameworkSettings and frameworkSettings.notifications == 'ox_lib' then
        -- ox_lib notifications (LXR-Core, RSG-Core, QBR, QR)
        if GetResourceState('ox_lib') == 'started' then
            exports['ox_lib']:notify({
                description = message,
                type = type,
                duration = duration
            })
            return
        end
    elseif frameworkSettings and frameworkSettings.notifications == 'vorp' then
        -- VORP notifications
        if Framework.Object and Framework.Object.NotifyRightTip then
            Framework.Object.NotifyRightTip(message, duration)
            return
        end
    elseif frameworkSettings and frameworkSettings.notifications == 'redem' then
        -- RedEM:RP notifications
        if Framework.Object and Framework.Object.UI then
            Framework.Object.UI.ShowNotification(message, duration)
            return
        end
    end
    
    -- Fallback: Use chat or print
    if Config.Notifications.FallbackToChat then
        if IsDuplicityVersion() then
            -- Server-side
            print('[LXR-VoiceRange] ' .. message)
        else
            -- Client-side
            TriggerEvent('chat:addMessage', {
                args = {'Voice Range', message}
            })
        end
    else
        print('[LXR-VoiceRange] ' .. message)
    end
end

--[[
    Get Player Data
    Returns player data object from the active framework
    
    @return table: Player data or nil
]]

function Framework.GetPlayerData()
    if Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' or 
       Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
        if Framework.Object and Framework.Object.Functions then
            return Framework.Object.Functions.GetPlayerData()
        end
    elseif Framework.Active == 'vorp_core' then
        if Framework.Object then
            return Framework.Object.getUser()
        end
    elseif Framework.Active == 'redem_roleplay' then
        if Framework.Object then
            return Framework.Object.getPlayer()
        end
    end
    
    return nil
end

--[[
    Check if Player is Loaded
    Returns whether the player has fully loaded into the game
    
    @return boolean: true if loaded, false otherwise
]]

function Framework.IsPlayerLoaded()
    local playerData = Framework.GetPlayerData()
    
    if Framework.Active == 'lxr-core' or Framework.Active == 'rsg-core' or 
       Framework.Active == 'qbr-core' or Framework.Active == 'qr-core' then
        return playerData ~= nil and playerData.citizenid ~= nil
    elseif Framework.Active == 'vorp_core' then
        return playerData ~= nil and playerData.identifier ~= nil
    elseif Framework.Active == 'redem_roleplay' then
        return playerData ~= nil and playerData.identifier ~= nil
    else
        -- Standalone: assume always loaded after spawn
        return true
    end
end

--[[
    Get Framework Event Name
    Formats event names according to framework conventions
    
    @param eventType: 'server', 'client', 'callback'
    @param eventName: Base event name
    @return string: Formatted event name
]]

function Framework.GetEventName(eventType, eventName)
    local frameworkSettings = Config.FrameworkSettings[Framework.Active]
    
    if frameworkSettings and frameworkSettings.events and frameworkSettings.events[eventType] then
        return string.format(frameworkSettings.events[eventType], eventName)
    end
    
    -- Fallback to generic naming
    return 'lxr-voicerange:' .. eventType .. ':' .. eventName
end

--[[
    Trigger Framework Event
    Triggers an event using framework-specific naming
    
    @param eventType: 'server', 'client'
    @param eventName: Base event name
    @param ...: Event arguments
]]

function Framework.TriggerEvent(eventType, eventName, ...)
    local fullEventName = Framework.GetEventName(eventType, eventName)
    
    if eventType == 'server' then
        TriggerServerEvent(fullEventName, ...)
    else
        TriggerEvent(fullEventName, ...)
    end
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TRANSLATION HELPER █████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Get Localized Message
    Retrieves a message in the configured language
    
    @param key: Message key
    @param ...: Format arguments
    @return string: Localized message
]]

function Framework.GetMessage(key, ...)
    local messages = Config.Notifications.Messages[Config.Lang]
    
    if not messages then
        messages = Config.Notifications.Messages['en']
    end
    
    if messages and messages[key] then
        return string.format(messages[key], ...)
    end
    
    return key
end

--[[
    Get Voice Range Label
    Returns the label for a voice range in the current language
    
    @param rangeName: 'whisper', 'normal', 'yell'
    @return string: Localized label
]]

function Framework.GetVoiceLabel(rangeName)
    local range = Config.VoiceRanges[rangeName]
    
    if not range then
        return rangeName
    end
    
    -- Try to get language-specific label
    if Config.Lang == 'ka' and range.labelKa then
        return range.labelKa
    elseif Config.Lang == 'it' and range.labelIt then
        return range.labelIt
    else
        return range.label
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK BRIDGE INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

-- Initialize framework on resource start
Citizen.CreateThread(function()
    Framework.Initialize()
    
    if Config.Debug.ShowFrameworkDetection then
        print(string.format([[
            
            ═══════════════════════════════════════════════════════════════════════
            🐺 LXR Voice Range - Framework Bridge Initialized
            ═══════════════════════════════════════════════════════════════════════
            
            Active Framework: %s
            Framework Ready: %s
            Notification System: %s
            
            ═══════════════════════════════════════════════════════════════════════
            
        ]], Framework.Active, tostring(Framework.Ready), 
        Config.FrameworkSettings[Framework.Active] and 
        Config.FrameworkSettings[Framework.Active].notifications or 'none'))
    end
end)
