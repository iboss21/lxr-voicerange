--[[
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
                                                                        
    🐺 LXR Voice Range System
    
    A production-grade voice proximity system for RedM with multi-framework support.
    Players can cycle through voice distances with visual feedback and notifications.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE METADATA
-- ═══════════════════════════════════════════════════════════════════════════════

fx_version 'cerulean'
game 'rdr3'
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE INFORMATION
-- ═══════════════════════════════════════════════════════════════════════════════

name 'LXR Voice Range'
author 'iBoss21 / The Lux Empire'
description 'Production-grade voice proximity system with multi-framework support for RedM servers. Supports LXR-Core, RSG-Core, VORP Core, and more.'
version '2.0.0'

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE FILES
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    File Loading Order:
    1. Config (settings and configuration)
    2. Shared (framework bridge/adapter)
    3. Client/Server (runtime scripts)
    
    The framework adapter provides unified functions across all supported frameworks.
]]

-- Shared files (loaded on both client and server)
shared_scripts {
    'config.lua',
    'shared/framework.lua'
}

-- Client-side files
client_scripts {
    'client/voice.lua'
}

-- Server-side files
server_scripts {
    'server/validation.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DEPENDENCIES (OPTIONAL)
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    This resource supports multiple frameworks but does not hard-require any.
    It will auto-detect the running framework and adapt accordingly.
    
    Supported Frameworks:
    - lxr-core (Primary)
    - rsg-core (Primary)
    - vorp_core (Supported)
    - redem_roleplay (Compatible)
    - qbr-core (Compatible)
    - qr-core (Compatible)
    - Standalone (Fallback)
    
    Optional notification systems:
    - ox_lib (recommended for LXR/RSG/QBR/QR)
    - Framework-specific notifications
]]

-- No hard dependencies - optional framework detection handles all cases

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE SCOPE & RESPONSIBILITY
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    This resource is responsible for:
    - Voice proximity control (whisper/normal/yell)
    - Visual range indicators (colored circles)
    - Framework-agnostic notifications
    - Server-side validation and rate limiting
    - Multi-language support (EN, KA, IT)
    - Performance optimization (minimal FPS impact)
    
    This resource does NOT handle:
    - Voice chat functionality (use Mumble-VOIP or similar)
    - Player identity/authentication (handled by framework)
    - Inventory or economy systems
    
    The voice range system is purely for enhancing roleplay immersion by
    controlling how far voice chat reaches based on player intention.
]]
