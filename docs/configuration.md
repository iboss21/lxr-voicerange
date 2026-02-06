```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# ⚙️ LXR Voice Range - Configuration Guide

**Comprehensive guide to all config.lua settings**

---

## 📋 Overview

The `config.lua` file is the central configuration hub for LXR Voice Range. Every aspect of the system can be customized without touching the core code. This guide explains each section in detail with examples and best practices.

---

## 🛡️ Resource Name Protection

**Location:** Top of `config.lua`

The resource has runtime protection to enforce correct naming:

```lua
local REQUIRED_RESOURCE_NAME = "lxr-voicerange"
```

### **Why This Exists:**
- Prevents breaking branded resources
- Ensures consistency across servers
- Maintains wolves.land identity
- Avoids support issues from renamed folders

### **Error Handling:**
If the folder is incorrectly named, you'll see:
```
═══════════════════════════════════════════════════════════════════
❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
═══════════════════════════════════════════════════════════════════

Expected: lxr-voicerange
Got: lxr-voice

Rename the folder to "lxr-voicerange" to continue.
```

**Solution:** Simply rename the folder to `lxr-voicerange`.

---

## 🏢 Server Branding & Info

**Section:** `Config.ServerInfo`

```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!',
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    developer = 'iBoss21 / The Lux Empire',
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'VoiceRange', 'Proximity'}
}
```

### **Properties Explained:**

| Property | Description | Usage |
|----------|-------------|-------|
| `name` | Server name with branding | Displayed in banners |
| `tagline` | Short server description | Marketing/promotion |
| `description` | Extended description | Server listing |
| `type` | RP type classification | Server categorization |
| `access` | Access restrictions | Player information |
| `website` | Main server website | Documentation links |
| `discord` | Discord invite link | Community support |
| `github` | Developer GitHub profile | Source code access |
| `store` | Tebex store URL | Purchase resources |
| `serverListing` | Server directory link | Promotion |
| `developer` | Developer name/brand | Credits |
| `tags` | SEO/categorization tags | Search optimization |

### **Customization Example:**

```lua
-- Change to your server info
Config.ServerInfo = {
    name = 'My RedM Server',
    tagline = 'Epic Wild West Roleplay!',
    description = 'Experience the true frontier life',
    type = 'Light Roleplay',
    access = 'Public',
    
    website = 'https://myserver.com',
    discord = 'https://discord.gg/myserver',
    -- ... rest of properties
}
```

---

## 🔌 Framework Configuration

**Section:** `Config.Framework` and `Config.FrameworkSettings`

### **Auto-Detection:**

```lua
Config.Framework = 'auto'  -- Recommended
```

The system will detect frameworks in this priority order:
1. LXR-Core
2. RSG-Core
3. VORP Core
4. RedEM:RP
5. QBR-Core
6. QR-Core
7. Standalone (fallback)

### **Manual Override:**

```lua
Config.Framework = 'vorp_core'  -- Force specific framework
```

Options: `'lxr-core'`, `'rsg-core'`, `'vorp_core'`, `'redem_roleplay'`, `'qbr-core'`, `'qr-core'`, `'standalone'`

### **Framework Settings Structure:**

Each framework has customizable settings:

```lua
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',              -- Resource name to check
        notifications = 'ox_lib',           -- Notification system
        inventory = 'lxr-inventory',        -- Inventory resource
        events = {
            server = 'lxr-core:server:%s',  -- Server event pattern
            client = 'lxr-core:client:%s',  -- Client event pattern
            callback = 'lxr-core:callback:%s' -- Callback pattern
        }
    },
    -- ... other frameworks
}
```

### **Event Pattern Examples:**

The `%s` is replaced with the event name:

```lua
-- LXR-Core pattern: 'lxr-core:server:%s'
-- Becomes: 'lxr-core:server:voiceChange'

-- VORP pattern: 'vorp:server:%s'
-- Becomes: 'vorp:server:voiceChange'
```

### **Adding a Custom Framework:**

```lua
Config.FrameworkSettings['myframework'] = {
    resource = 'my-core',
    notifications = 'ox_lib',
    inventory = 'my-inventory',
    events = {
        server = 'mycore:server:%s',
        client = 'mycore:client:%s'
    }
}
```

Then set:
```lua
Config.Framework = 'myframework'
```

---

## 🌍 Language Configuration

**Section:** `Config.Lang`

```lua
Config.Lang = 'en'  -- 'en', 'ka', 'it'
```

### **Supported Languages:**

| Code | Language | Native Name |
|------|----------|-------------|
| `en` | English | English |
| `ka` | Georgian | ქართული |
| `it` | Italian | Italiano |

### **Language Affects:**

- Notification messages
- Voice range labels
- System messages
- Console output

### **Adding a New Language:**

1. **Add voice range labels:**
```lua
Config.VoiceRanges = {
    whisper = {
        distance = 2.0,
        label = 'Whisper',
        labelKa = 'ჩურჩული',
        labelIt = 'Sussurra',
        labelEs = 'Susurro',  -- Add new language
    },
    -- ... other ranges
}
```

2. **Add notification messages:**
```lua
Config.Notifications.Messages = {
    en = { ... },
    ka = { ... },
    it = { ... },
    es = {  -- Add new language
        voiceChanged = 'Distancia de Voz: %s',
        systemLoaded = 'Sistema de Distancia de Voz Cargado',
        cooldown = 'Espere antes de cambiar la distancia de voz nuevamente'
    }
}
```

3. **Set language:**
```lua
Config.Lang = 'es'
```

---

## ⚙️ General Settings

**Section:** `Config.General`

```lua
Config.General = {
    EnableVoiceRange = true,        -- Master toggle
    AllowProximityChange = true,    -- Can players change range?
    ShowVisualIndicator = true,     -- Show colored circle?
    EnableNotifications = true,     -- Show notifications?
    Debug = false                   -- Enable debug logging?
}
```

### **Setting Details:**

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `EnableVoiceRange` | boolean | `true` | Master on/off switch for entire system |
| `AllowProximityChange` | boolean | `true` | If false, players stuck on default range |
| `ShowVisualIndicator` | boolean | `true` | Show colored circle when holding voice key |
| `EnableNotifications` | boolean | `true` | Display notifications for range changes |
| `Debug` | boolean | `false` | Print debug info to console (verbose!) |

### **Use Cases:**

**Disable for events:**
```lua
Config.General.AllowProximityChange = false  -- Lock all players to normal range
```

**Performance mode:**
```lua
Config.General.ShowVisualIndicator = false  -- Disable visual effects
```

**Silent mode:**
```lua
Config.General.EnableNotifications = false  -- No notifications
```

---

## 🗣️ Voice Range Settings

**Section:** `Config.VoiceRanges`

### **Structure:**

```lua
Config.VoiceRanges = {
    whisper = {
        distance = 2.0,                                    -- Range in meters
        label = 'Whisper',                                 -- English label
        labelKa = 'ჩურჩული',                              -- Georgian label
        labelIt = 'Sussurra',                              -- Italian label
        color = {r = 100, g = 100, b = 255, a = 155}      -- Blue RGBA
    },
    normal = {
        distance = 6.0,
        label = 'Normal',
        labelKa = 'ნორმალური',
        labelIt = 'Normale',
        color = {r = 100, g = 255, b = 100, a = 155}      -- Green RGBA
    },
    yell = {
        distance = 15.0,
        label = 'Yell',
        labelKa = 'ყვირილი',
        labelIt = 'Urla',
        color = {r = 255, g = 100, b = 100, a = 155}      -- Red RGBA
    }
}
```

### **Property Explanations:**

| Property | Type | Description |
|----------|------|-------------|
| `distance` | float | Range in game units (meters) |
| `label` | string | Display name (English) |
| `labelKa` | string | Display name (Georgian) |
| `labelIt` | string | Display name (Italian) |
| `color` | table | RGBA color for visual indicator |

### **Distance Guidelines:**

| Range Type | Recommended | RP Use Case |
|------------|-------------|-------------|
| Whisper | 1.5 - 3.0m | Secrets, private talk |
| Normal | 5.0 - 8.0m | Standard conversation |
| Yell | 12.0 - 20.0m | Shouting, warnings |

### **Color Examples:**

```lua
-- Pure Red
color = {r = 255, g = 0, b = 0, a = 200}

-- Pure Blue
color = {r = 0, g = 0, b = 255, a = 200}

-- Yellow
color = {r = 255, g = 255, b = 0, a = 200}

-- Purple
color = {r = 128, g = 0, b = 128, a = 200}

-- Orange
color = {r = 255, g = 165, b = 0, a = 200}
```

### **Custom Distance Example:**

```lua
-- Realistic mode (shorter ranges)
Config.VoiceRanges = {
    whisper = { distance = 1.0, label = 'Whisper', ... },
    normal = { distance = 3.0, label = 'Normal', ... },
    yell = { distance = 8.0, label = 'Yell', ... }
}

-- Arcade mode (longer ranges)
Config.VoiceRanges = {
    whisper = { distance = 5.0, label = 'Quiet', ... },
    normal = { distance = 15.0, label = 'Normal', ... },
    yell = { distance = 30.0, label = 'Loud', ... }
}
```

### **Default Voice Range:**

```lua
Config.DefaultVoiceRange = 'normal'  -- 'whisper', 'normal', 'yell'
```

Players spawn with this range active.

### **Voice Cycle Order:**

```lua
Config.VoiceCycleOrder = {'whisper', 'normal', 'yell'}
```

Order players cycle through when pressing the key. Can be rearranged:

```lua
Config.VoiceCycleOrder = {'normal', 'yell', 'whisper'}  -- Skip whisper first
```

---

## ⌨️ Key Bindings

**Section:** `Config.Keys`

```lua
Config.Keys = {
    VoiceChange = 0x3C3DD371  -- Z key
}
```

### **Common Key Hashes:**

| Key | Hash Value | Usage |
|-----|------------|-------|
| Z | `0x3C3DD371` | Default (recommended) |
| X | `0x8CC9CD42` | Alternative |
| G | `0x760A9C6F` | Alternative |
| H | `0x24978A28` | Alternative |
| BACKSPACE | `0x8FD015D8` | Not recommended |

### **How to Find Key Hashes:**

1. Visit [FiveM Controls Reference](https://docs.fivem.net/docs/game-references/controls/)
2. Find your desired key
3. Use the hash value (hex format)

### **Changing the Key:**

```lua
-- Change to G key
Config.Keys = {
    VoiceChange = 0x760A9C6F
}
```

### **Important Notes:**

- Players **hold** the key to show the visual indicator
- Players **press** the key briefly to cycle ranges
- Choose a key that doesn't conflict with other scripts

---

## ⏱️ Cooldowns & Timing

**Section:** `Config.Cooldowns`

```lua
Config.Cooldowns = {
    VoiceChangeDelay = 500,       -- Milliseconds between changes
    NotificationDuration = 3000   -- Notification display time (ms)
}
```

### **Property Details:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `VoiceChangeDelay` | integer | `500` | Anti-spam delay between range changes |
| `NotificationDuration` | integer | `3000` | How long notifications stay on screen |

### **Customization Examples:**

**Very responsive:**
```lua
Config.Cooldowns = {
    VoiceChangeDelay = 200,       -- 0.2 seconds
    NotificationDuration = 2000   -- 2 seconds
}
```

**Anti-spam (strict):**
```lua
Config.Cooldowns = {
    VoiceChangeDelay = 1000,      -- 1 second
    NotificationDuration = 4000   -- 4 seconds
}
```

**Disabled cooldown (not recommended):**
```lua
Config.Cooldowns = {
    VoiceChangeDelay = 0,  -- No delay (can be spammed)
    NotificationDuration = 3000
}
```

---

## 🎨 Visual Settings

**Section:** `Config.Visual`

```lua
Config.Visual = {
    CircleRadius = 1.1,     -- Circle thickness
    CircleHeight = -1.0     -- Height offset from player
}
```

### **Property Details:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `CircleRadius` | float | `1.1` | Size/thickness of the colored circle |
| `CircleHeight` | float | `-1.0` | Vertical offset (negative = below feet) |

### **Visual Examples:**

**Larger circle:**
```lua
Config.Visual = {
    CircleRadius = 1.5,     -- Thicker/larger
    CircleHeight = -1.0
}
```

**At player feet:**
```lua
Config.Visual = {
    CircleRadius = 1.1,
    CircleHeight = 0.0      -- Ground level
}
```

**Above player head:**
```lua
Config.Visual = {
    CircleRadius = 1.1,
    CircleHeight = 2.0      -- Floating above
}
```

**Minimal (barely visible):**
```lua
Config.Visual = {
    CircleRadius = 0.5,     -- Very thin
    CircleHeight = -1.0
}
```

---

## 🔔 Notifications

**Section:** `Config.Notifications`

```lua
Config.Notifications = {
    UseFrameworkNotifications = true,  -- Use framework's notify system
    FallbackToChat = true,             -- Use chat if no framework
    
    Messages = {
        en = {
            voiceChanged = 'Voice Range: %s',
            systemLoaded = 'Voice Range System Loaded',
            cooldown = 'Please wait before changing voice range again'
        },
        -- ... other languages
    }
}
```

### **Notification Flow:**

1. **Framework notifications** (if available and enabled)
   - ox_lib notify
   - VORP notify
   - Framework-specific systems

2. **Chat fallback** (if framework not available)
   - Standard chat message
   - Color coded based on message type

3. **No notification** (if both disabled)
   - Silent operation

### **Customizing Messages:**

```lua
Config.Notifications.Messages.en = {
    voiceChanged = '🗣️ Voice: %s',           -- Custom emoji
    systemLoaded = '✅ Voice System Ready',   -- Custom format
    cooldown = '⏳ Too fast! Wait a moment.'  -- Custom text
}
```

The `%s` is replaced with the voice range label.

### **Notification Types:**

The system supports different notification types based on framework:

| Type | Usage |
|------|-------|
| `success` | Voice changed successfully |
| `info` | System loaded |
| `error` | Cooldown active |

---

## 🔒 Security & Validation

**Section:** `Config.Security`

```lua
Config.Security = {
    EnableServerValidation = true,         -- Validate server-side
    MaxVoiceChangesPerMinute = 30,         -- Rate limit
    LogSuspiciousActivity = false,         -- Log abuse attempts
    
    MinAllowedDistance = 1.0,              -- Minimum voice range
    MaxAllowedDistance = 20.0              -- Maximum voice range
}
```

### **Property Details:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `EnableServerValidation` | boolean | `true` | Server-side validation of all changes |
| `MaxVoiceChangesPerMinute` | integer | `30` | Max changes allowed per player per minute |
| `LogSuspiciousActivity` | boolean | `false` | Console log potential abuse |
| `MinAllowedDistance` | float | `1.0` | Minimum voice distance allowed |
| `MaxAllowedDistance` | float | `20.0` | Maximum voice distance allowed |

### **Rate Limiting:**

**How it works:**
- Each player can change voice range up to `MaxVoiceChangesPerMinute` times
- Counter resets every 60 seconds
- Exceeding limit results in rejected changes
- Suspicious activity can be logged

**Example rates:**

```lua
-- Relaxed (30 per minute = every 2 seconds)
MaxVoiceChangesPerMinute = 30

-- Moderate (20 per minute = every 3 seconds)
MaxVoiceChangesPerMinute = 20

-- Strict (10 per minute = every 6 seconds)
MaxVoiceChangesPerMinute = 10

-- Very strict (5 per minute = every 12 seconds)
MaxVoiceChangesPerMinute = 5
```

### **Distance Validation:**

Prevents players from setting unrealistic voice ranges:

```lua
-- Very short range only
Config.Security = {
    MinAllowedDistance = 0.5,
    MaxAllowedDistance = 10.0
}

-- Extended range allowed
Config.Security = {
    MinAllowedDistance = 1.0,
    MaxAllowedDistance = 50.0
}
```

**Important:** Ensure your `Config.VoiceRanges` distances are within these bounds!

### **Logging Suspicious Activity:**

```lua
Config.Security.LogSuspiciousActivity = true
```

Logs will show:
```
[LXR-VoiceRange] Player 1 exceeded rate limit (35 changes/minute)
[LXR-VoiceRange] Player 2 attempted invalid distance (25.0m)
```

---

## ⚡ Performance Optimization

**Section:** `Config.Performance`

```lua
Config.Performance = {
    MainThreadWait = 0,                     -- Input thread wait (ms)
    IdleThreadWait = 1000,                  -- Idle thread wait (ms)
    
    CachePlayerPed = true,                  -- Cache PlayerPedId
    CacheUpdateInterval = 100,              -- Cache update interval (ms)
    
    DrawCircleOnlyWhenHolding = true        -- Only draw when key held
}
```

### **Property Details:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `MainThreadWait` | integer | `0` | Main input loop wait (0 = every frame) |
| `IdleThreadWait` | integer | `1000` | Wait time when system idle |
| `CachePlayerPed` | boolean | `true` | Cache PlayerPedId() for performance |
| `CacheUpdateInterval` | integer | `100` | How often to update cache (ms) |
| `DrawCircleOnlyWhenHolding` | boolean | `true` | Only render visual when key held |

### **Performance Tuning:**

**Maximum responsiveness:**
```lua
Config.Performance = {
    MainThreadWait = 0,       -- Check every frame
    CachePlayerPed = true,
    CacheUpdateInterval = 50  -- Update cache frequently
}
```

**Balanced (recommended):**
```lua
Config.Performance = {
    MainThreadWait = 0,
    IdleThreadWait = 1000,
    CachePlayerPed = true,
    CacheUpdateInterval = 100
}
```

**Maximum performance (slight delay):**
```lua
Config.Performance = {
    MainThreadWait = 50,       -- Check every 50ms
    IdleThreadWait = 2000,
    CachePlayerPed = true,
    CacheUpdateInterval = 200,
    DrawCircleOnlyWhenHolding = true
}
```

**Low-end servers:**
```lua
Config.Performance = {
    MainThreadWait = 100,      -- Significant delay but saves CPU
    IdleThreadWait = 5000,
    CachePlayerPed = true,
    CacheUpdateInterval = 500,
    DrawCircleOnlyWhenHolding = true
}
```

### **Performance Impact Estimates:**

| Setting | FPS Impact | Responsiveness |
|---------|------------|----------------|
| MainThreadWait = 0 | 0.1ms | Instant |
| MainThreadWait = 50 | 0.05ms | Slight delay |
| MainThreadWait = 100 | 0.02ms | Noticeable delay |
| CachePlayerPed = false | +0.5ms | N/A |
| DrawCircleOnlyWhenHolding = false | +1.0ms | N/A |

---

## 🐛 Debug Settings

**Section:** `Config.Debug`

```lua
Config.Debug = {
    EnableDebugPrints = false,       -- Print debug info
    ShowFrameworkDetection = true,   -- Show detected framework
    LogVoiceChanges = false,         -- Log every voice change
    ShowNativeCalls = false          -- Log native function calls
}
```

### **Property Details:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `EnableDebugPrints` | boolean | `false` | General debug logging |
| `ShowFrameworkDetection` | boolean | `true` | Show framework on startup |
| `LogVoiceChanges` | boolean | `false` | Log every range change |
| `ShowNativeCalls` | boolean | `false` | Log native function calls (very verbose) |

### **Debug Modes:**

**Development mode (full debugging):**
```lua
Config.Debug = {
    EnableDebugPrints = true,
    ShowFrameworkDetection = true,
    LogVoiceChanges = true,
    ShowNativeCalls = false  -- Keep off (too verbose)
}
```

**Production mode (minimal logging):**
```lua
Config.Debug = {
    EnableDebugPrints = false,
    ShowFrameworkDetection = true,
    LogVoiceChanges = false,
    ShowNativeCalls = false
}
```

**Troubleshooting mode:**
```lua
Config.Debug = {
    EnableDebugPrints = true,
    ShowFrameworkDetection = true,
    LogVoiceChanges = true,
    ShowNativeCalls = true  -- Use temporarily
}
```

### **Console Output Examples:**

With debugging enabled, you'll see:
```
[LXR-VoiceRange] Framework detected: lxr-core
[LXR-VoiceRange] Player 1 changed voice range to: Normal (6.0m)
[LXR-VoiceRange] Native 0x08797a8c03868cb8 called with: 6.0
[LXR-VoiceRange] Rate limit check: Player 1 (3/30 changes)
```

---

## 🔧 Advanced Configuration

**Section:** `Config.Natives`

```lua
Config.Natives = {
    VoiceNative1 = 0x08797a8c03868cb8,
    VoiceNative2 = 0xec8703e4536a9952,
    DrawMarker = 0x2A32FAA57B937173,
    VoiceNative4 = 0x58125b691f6827d5,
    MarkerHash = -1795314153
}
```

### **⚠️ Warning:**

These are RedM native function hashes used for voice control. **Do not modify unless you know what you're doing!**

These natives are:
- Game-specific (RedM)
- Version-dependent
- Undocumented by Rockstar
- Reverse-engineered by community

### **When to Modify:**

- Never, unless RedM updates break compatibility
- Only if instructed by support/developer
- After testing on a development server

### **Native Purposes:**

| Native | Suspected Purpose |
|--------|-------------------|
| `VoiceNative1` | Set voice range/proximity |
| `VoiceNative2` | Voice system initialization |
| `DrawMarker` | Draw visual marker/circle |
| `VoiceNative4` | Voice state management |
| `MarkerHash` | Circle/sphere marker type |

---

## 📝 Complete Configuration Example

### **Hardcore Roleplay Server:**

```lua
-- Language: English
Config.Lang = 'en'

-- General: Strict settings
Config.General = {
    EnableVoiceRange = true,
    AllowProximityChange = true,
    ShowVisualIndicator = true,
    EnableNotifications = true,
    Debug = false
}

-- Voice Ranges: Realistic distances
Config.VoiceRanges = {
    whisper = { distance = 1.5, label = 'Whisper', ... },
    normal = { distance = 4.0, label = 'Normal', ... },
    yell = { distance = 10.0, label = 'Yell', ... }
}
Config.DefaultVoiceRange = 'normal'

-- Security: Strict rate limiting
Config.Security = {
    EnableServerValidation = true,
    MaxVoiceChangesPerMinute = 15,  -- Strict
    LogSuspiciousActivity = true,
    MinAllowedDistance = 1.0,
    MaxAllowedDistance = 12.0
}

-- Performance: Maximum FPS
Config.Performance = {
    MainThreadWait = 0,
    CachePlayerPed = true,
    CacheUpdateInterval = 100,
    DrawCircleOnlyWhenHolding = true
}
```

### **Casual/Arcade Server:**

```lua
-- Language: English
Config.Lang = 'en'

-- General: Relaxed settings
Config.General = {
    EnableVoiceRange = true,
    AllowProximityChange = true,
    ShowVisualIndicator = true,
    EnableNotifications = true,
    Debug = false
}

-- Voice Ranges: Generous distances
Config.VoiceRanges = {
    whisper = { distance = 5.0, label = 'Quiet', ... },
    normal = { distance = 15.0, label = 'Normal', ... },
    yell = { distance = 30.0, label = 'Loud', ... }
}
Config.DefaultVoiceRange = 'normal'

-- Security: Relaxed rate limiting
Config.Security = {
    EnableServerValidation = true,
    MaxVoiceChangesPerMinute = 60,  -- Relaxed
    LogSuspiciousActivity = false,
    MinAllowedDistance = 1.0,
    MaxAllowedDistance = 50.0
}

-- Performance: Balanced
Config.Performance = {
    MainThreadWait = 0,
    CachePlayerPed = true,
    CacheUpdateInterval = 100,
    DrawCircleOnlyWhenHolding = true
}
```

---

## 🎯 Best Practices

### **Do's:**

✅ Test changes on a development server first  
✅ Keep backups of your config.lua  
✅ Use auto-detection for frameworks when possible  
✅ Enable server validation for security  
✅ Keep voice ranges realistic for RP immersion  
✅ Use rate limiting to prevent abuse  
✅ Document custom changes in comments  

### **Don'ts:**

❌ Don't disable server validation in production  
❌ Don't set extremely short cooldowns (< 200ms)  
❌ Don't modify native hashes without research  
❌ Don't set unrealistic voice distances (> 50m)  
❌ Don't enable all debug options in production  
❌ Don't forget to test after changing settings  

---

## 📞 Configuration Support

Need help with configuration?

1. **Read this guide thoroughly**
2. **Check example configurations above**
3. **Test on development server first**
4. **Visit Discord:** [wolves.land Discord](https://discord.gg/CrKcWdfd3A)
5. **Open GitHub Issue:** [Report Issue](https://github.com/iBoss21/lxr-voicerange/issues)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**

[← Back to Main README](../README.md) | [← Installation Guide](installation.md) | [Next: Frameworks →](frameworks.md)
