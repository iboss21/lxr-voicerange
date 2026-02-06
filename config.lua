--[[
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
                                                                        
    🐺 LXR Voice Range - Configuration
    
    This configuration file controls the voice range/proximity system for RedM.
    Players can cycle through voice distances (whisper, normal, yell) with visual
    feedback. The system integrates with multiple frameworks and provides
    configurable voice distances, key bindings, and visual indicators.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 2.0.0
    Performance Target: Zero-impact voice system with optimized native calls
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, VoiceRange, Proximity, Communication
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Primary)
    - VORP Core (Supported)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Original Code: Community contribution
    Enhanced by: iBoss21 with multi-framework support and branding
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-voicerange"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    -- Contact & Links
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
    
    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'VoiceRange', 'Proximity', 'Communication'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP (Optional - if detected)
    5. QBR-Core (Optional - if detected)
    6. QR-Core (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib', -- notification system to use
        inventory = 'lxr-inventory',
        -- Event naming convention
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        notifications = 'ox_lib',
        inventory = 'rsg-inventory',
        events = {
            server = 'RSGCore:Server:%s',
            client = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource = 'vorp_core',
        notifications = 'vorp',
        inventory = 'vorp_inventory',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s'
        }
    },
    ['redem_roleplay'] = {
        resource = 'redem_roleplay',
        notifications = 'redem',
        inventory = 'redem_inventory',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client'
        }
    },
    ['qbr-core'] = {
        resource = 'qbr-core',
        notifications = 'ox_lib',
        inventory = 'qbr-inventory',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s'
        }
    },
    ['qr-core'] = {
        resource = 'qr-core',
        notifications = 'ox_lib',
        inventory = 'qr-inventory',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s'
        }
    },
    ['standalone'] = {
        -- Minimal functionality without framework
        notifications = 'print',
        inventory = 'none'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- 'en', 'ka' (Georgian), 'it', 'es', 'de', 'fr'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.General = {
    EnableVoiceRange = true,                    -- Master toggle for voice range system
    AllowProximityChange = true,                -- Allow players to change voice distance
    ShowVisualIndicator = true,                 -- Show colored circle when holding voice key
    EnableNotifications = true,                 -- Show notifications on voice range change
    Debug = false                               -- Enable debug prints (console spam)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ VOICE RANGE SETTINGS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Voice Range Modes:
    - Whisper: Short distance, private conversations
    - Normal: Standard conversation distance
    - Yell: Long distance, shouting
    
    Distances are in game units (meters). Adjust based on your server needs.
]]

Config.VoiceRanges = {
    whisper = {
        distance = 2.0,
        label = 'Whisper',
        labelKa = 'ჩურჩული',  -- Georgian
        labelIt = 'Sussurra',  -- Italian
        color = {r = 100, g = 100, b = 255, a = 155}  -- Blue
    },
    normal = {
        distance = 6.0,
        label = 'Normal',
        labelKa = 'ნორმალური',  -- Georgian
        labelIt = 'Normale',     -- Italian
        color = {r = 100, g = 255, b = 100, a = 155}  -- Green
    },
    yell = {
        distance = 15.0,
        label = 'Yell',
        labelKa = 'ყვირილი',  -- Georgian
        labelIt = 'Urla',     -- Italian
        color = {r = 255, g = 100, b = 100, a = 155}  -- Red
    }
}

Config.DefaultVoiceRange = 'normal'  -- Starting voice range: 'whisper', 'normal', 'yell'

-- Voice Range Cycle Order (how pressing the key cycles through ranges)
Config.VoiceCycleOrder = {'whisper', 'normal', 'yell'}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ KEY BINDINGS ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    RedM Control Hash Reference:
    0x3C3DD371 = Z key (default voice key)
    0x8FD015D8 = BACKSPACE
    0x760A9C6F = G key
    
    Full list: https://docs.fivem.net/docs/game-references/controls/
]]

Config.Keys = {
    VoiceChange = 0x3C3DD371,  -- Z key - Press to cycle voice range
    -- Note: Holding the key shows the visual indicator
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ COOLDOWNS & TIMING ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Cooldowns = {
    VoiceChangeDelay = 500,      -- Milliseconds between voice range changes (anti-spam)
    NotificationDuration = 3000, -- How long notifications stay on screen (ms)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ VISUAL SETTINGS ███████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Visual = {
    -- Circle indicator settings (shown when holding voice key)
    CircleRadius = 1.1,          -- Circle thickness/size
    CircleHeight = -1.0,         -- Height offset from player (negative = below feet)
    
    -- Circle appearance is colored based on voice range (see VoiceRanges colors above)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NOTIFICATIONS ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Notifications = {
    UseFrameworkNotifications = true,  -- Use framework's notification system when available
    FallbackToChat = true,             -- If no framework notifications, use chat
    
    -- Notification messages by language
    Messages = {
        en = {
            voiceChanged = 'Voice Range: %s',
            systemLoaded = 'Voice Range System Loaded',
            cooldown = 'Please wait before changing voice range again'
        },
        ka = {
            voiceChanged = 'ხმის დიაპაზონი: %s',
            systemLoaded = 'ხმის დიაპაზონის სისტემა ჩაიტვირთა',
            cooldown = 'გთხოვთ დაელოდოთ ხმის დიაპაზონის ცვლილებას'
        },
        it = {
            voiceChanged = 'Distanza Voce: %s',
            systemLoaded = 'Sistema Distanza Voce Caricato',
            cooldown = 'Attendere prima di cambiare nuovamente la distanza vocale'
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & VALIDATION █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    EnableServerValidation = true,       -- Validate voice changes server-side
    MaxVoiceChangesPerMinute = 30,       -- Rate limit for voice changes (anti-abuse)
    LogSuspiciousActivity = false,       -- Log potential abuse to console
    
    -- Distance validation (prevent unrealistic ranges)
    MinAllowedDistance = 1.0,
    MaxAllowedDistance = 20.0,
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PERFORMANCE OPTIMIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    -- Thread timing (milliseconds)
    MainThreadWait = 0,              -- Main input thread wait (0 = every frame for responsiveness)
    IdleThreadWait = 1000,           -- Wait time when system is idle
    
    -- Native call optimization
    CachePlayerPed = true,           -- Cache PlayerPedId for performance
    CacheUpdateInterval = 100,       -- How often to update cached values (ms)
    
    -- Visual indicator optimization
    DrawCircleOnlyWhenHolding = true,  -- Only draw circle when holding voice key (saves FPS)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = {
    EnableDebugPrints = false,         -- Print debug info to console
    ShowFrameworkDetection = true,     -- Show detected framework on startup
    LogVoiceChanges = false,           -- Log every voice range change
    ShowNativeCalls = false,           -- Log native function calls (verbose)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ADVANCED CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Native Voice Functions (RedM):
    
    0x08797a8c03868cb8 = Unknown (voice related)
    0xec8703e4536a9952 = Unknown (voice related)  
    0x2A32FAA57B937173 = DrawMarker/DrawSphere (visual indicator)
    0x58125b691f6827d5 = Unknown (voice related)
    
    These natives control the voice proximity system in RedM.
    They are used in the client script and should not need modification.
]]

Config.Natives = {
    -- Native hashes for voice system
    VoiceNative1 = 0x08797a8c03868cb8,
    VoiceNative2 = 0xec8703e4536a9952,
    DrawMarker = 0x2A32FAA57B937173,
    VoiceNative4 = 0x58125b691f6827d5,
    
    -- Visual marker hash for indicator circle
    MarkerHash = -1795314153,
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 STARTUP BANNER
-- ═══════════════════════════════════════════════════════════════════════════════

print([[

    ═══════════════════════════════════════════════════════════════════════════════
    🐺 LXR Voice Range System - Loaded
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 2.0.0
    Framework: Auto-detect enabled
    Language: ]] .. Config.Lang .. [[
    
    Voice Ranges: ]] .. #Config.VoiceCycleOrder .. [[ modes configured
    Default Range: ]] .. Config.DefaultVoiceRange .. [[
    
    🐺 wolves.land - The Land of Wolves
    
    ═══════════════════════════════════════════════════════════════════════════════
    
]])
