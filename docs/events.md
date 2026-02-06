```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# 📡 LXR Voice Range - Event System

**Complete event documentation and API reference**

---

## 📋 Overview

The LXR Voice Range system uses a unified event system that works across all supported frameworks. Events provide hooks for custom scripts to integrate with voice range changes, validation, and state management.

---

## 🎯 Event Categories

### **1. Client Events**
- Triggered on the player's client
- Handle visual feedback and input
- Communicate with server

### **2. Server Events**
- Triggered on the server
- Validate player actions
- Rate limiting and logging
- Broadcast to other clients

### **3. Framework Adapter Events**
- Generated dynamically based on active framework
- Follow framework-specific naming conventions
- Unified API across all frameworks

---

## 📤 Client-Side Events

### **Event: `lxr-voicerange:client:voiceChanged`**

**Description:** Triggered when player successfully changes voice range

**Parameters:**
```lua
-- range: string - The new voice range ('whisper', 'normal', 'yell')
-- distance: number - The distance in meters
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:client:voiceChanged', function(range, distance)
    print(string.format('Voice changed to %s (%s meters)', range, distance))
    
    -- Custom logic here
    if range == 'yell' then
        -- Player is yelling, maybe add animation?
        TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    end
end)
```

**When Triggered:**
- After key press to cycle voice range
- After passing cooldown check
- After native voice functions called
- Before server validation event

---

### **Event: `lxr-voicerange:client:rangeValidated`**

**Description:** Server confirms voice range change is valid

**Parameters:**
```lua
-- success: boolean - Whether validation passed
-- range: string - The validated range
-- distance: number - The validated distance
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:client:rangeValidated', function(success, range, distance)
    if success then
        print('Server validated voice range: ' .. range)
    else
        print('Server rejected voice range change')
        -- Revert to previous range if needed
    end
end)
```

**When Triggered:**
- After server validation completes
- Rate limit check passed
- Distance validation passed

---

### **Event: `lxr-voicerange:client:rateLimited`**

**Description:** Player exceeded rate limit for voice changes

**Parameters:**
```lua
-- attempts: number - How many attempts player made
-- limit: number - The configured rate limit
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:client:rateLimited', function(attempts, limit)
    print(string.format('Rate limited! %s/%s attempts', attempts, limit))
    
    -- Show custom warning
    lib.notify({
        title = 'Slow Down!',
        description = 'You are changing voice range too quickly',
        type = 'error',
        duration = 5000
    })
end)
```

**When Triggered:**
- Player exceeds `Config.Security.MaxVoiceChangesPerMinute`
- Server rejects change due to rate limiting
- Can happen multiple times if player continues spamming

---

### **Event: `lxr-voicerange:client:cooldownActive`**

**Description:** Player tried to change voice too quickly (client cooldown)

**Parameters:**
```lua
-- remainingMs: number - Milliseconds remaining on cooldown
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:client:cooldownActive', function(remainingMs)
    local seconds = math.floor(remainingMs / 1000)
    print('Cooldown active. Wait ' .. seconds .. ' seconds.')
end)
```

**When Triggered:**
- Player presses voice key during cooldown period
- Before any server communication
- Cooldown defined by `Config.Cooldowns.VoiceChangeDelay`

---

### **Event: `lxr-voicerange:client:visualIndicatorShown`**

**Description:** Visual indicator (colored circle) is being shown

**Parameters:**
```lua
-- range: string - Current voice range
-- color: table - RGBA color table {r, g, b, a}
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:client:visualIndicatorShown', function(range, color)
    -- Custom visual effect
    print(string.format('Showing %s indicator (RGB: %s,%s,%s)', 
        range, color.r, color.g, color.b))
    
    -- Add custom particle effect
    UseParticleFxAsset('core')
    StartParticleFxLoopedAtCoord('ent_amb_steam', 
        GetEntityCoords(PlayerPedId()), 0.0, 0.0, 0.0, 1.0, false, false, false)
end)
```

**When Triggered:**
- Player holds voice key down
- Every frame while key is held
- Only if `Config.General.ShowVisualIndicator = true`

---

### **Event: `lxr-voicerange:client:visualIndicatorHidden`**

**Description:** Visual indicator has been hidden

**Parameters:** None

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:client:visualIndicatorHidden', function()
    print('Visual indicator hidden')
    
    -- Stop custom effects
    RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 5.0)
end)
```

**When Triggered:**
- Player releases voice key
- Visual indicator stops rendering

---

## 📥 Server-Side Events

### **Event: `lxr-voicerange:server:validateVoiceChange`**

**Description:** Client requests validation for voice range change

**Parameters:**
```lua
-- range: string - Requested voice range
-- distance: number - Requested distance
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:server:validateVoiceChange', function(range, distance)
    local src = source
    
    -- Custom validation logic
    local playerJob = GetPlayerJob(src)  -- Your function
    
    if playerJob == 'lawman' and range == 'whisper' then
        -- Lawmen can't whisper (example rule)
        TriggerClientEvent('lxr-voicerange:client:rangeValidated', src, false, range, distance)
        print('Lawman attempted to whisper - denied')
        return
    end
    
    -- Allow change (default validation will proceed)
    print(string.format('Player %s changed voice to %s', src, range))
end)
```

**When Triggered:**
- Client changes voice range
- After client-side cooldown passes
- Before server validation completes

---

### **Event: `lxr-voicerange:server:voiceChangeValidated`**

**Description:** Server completed validation (internal use)

**Parameters:**
```lua
-- playerId: number - Source player ID
-- success: boolean - Validation result
-- range: string - Voice range
-- distance: number - Distance in meters
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:server:voiceChangeValidated', function(playerId, success, range, distance)
    if success then
        -- Log to database
        MySQL.insert('INSERT INTO voice_logs (player_id, range, distance, timestamp) VALUES (?, ?, ?, ?)', {
            playerId, range, distance, os.time()
        })
    end
end)
```

**When Triggered:**
- After all validation checks complete
- After rate limiting check
- Before client callback

---

### **Event: `lxr-voicerange:server:rateLimitExceeded`**

**Description:** Player exceeded rate limit (suspicious activity)

**Parameters:**
```lua
-- playerId: number - Source player ID
-- attempts: number - Number of attempts
-- limit: number - Configured limit
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:server:rateLimitExceeded', function(playerId, attempts, limit)
    print(string.format('[SECURITY] Player %s exceeded rate limit: %s/%s', 
        playerId, attempts, limit))
    
    -- Log to security system
    TriggerEvent('security:log', {
        player = playerId,
        type = 'voice_spam',
        severity = 'medium',
        message = string.format('Exceeded voice change limit (%s/%s)', attempts, limit)
    })
    
    -- Temporary restriction (optional)
    if attempts > limit * 2 then
        -- Player is really spamming, take action
        print(string.format('[SECURITY] Player %s temporarily restricted', playerId))
    end
end)
```

**When Triggered:**
- Player exceeds `Config.Security.MaxVoiceChangesPerMinute`
- Every subsequent attempt while over limit
- If `Config.Security.LogSuspiciousActivity = true`

---

### **Event: `lxr-voicerange:server:invalidDistance`**

**Description:** Player attempted invalid voice distance

**Parameters:**
```lua
-- playerId: number - Source player ID
-- requestedDistance: number - Distance player tried to set
-- minAllowed: number - Minimum allowed distance
-- maxAllowed: number - Maximum allowed distance
```

**Example Usage:**
```lua
RegisterNetEvent('lxr-voicerange:server:invalidDistance', function(playerId, requestedDistance, minAllowed, maxAllowed)
    print(string.format('[SECURITY] Player %s attempted invalid distance: %s (allowed: %s-%s)',
        playerId, requestedDistance, minAllowed, maxAllowed))
    
    -- Log potential exploit attempt
    if requestedDistance > maxAllowed * 2 then
        TriggerEvent('anticheat:logSuspiciousActivity', playerId, 'voice_exploit', {
            requested = requestedDistance,
            max = maxAllowed
        })
    end
end)
```

**When Triggered:**
- Distance < `Config.Security.MinAllowedDistance`
- Distance > `Config.Security.MaxAllowedDistance`
- Distance not matching any configured range

---

## 🔌 Framework-Specific Events

### **Event Name Patterns:**

Events are automatically formatted based on the active framework:

| Framework | Client Pattern | Server Pattern |
|-----------|---------------|----------------|
| LXR-Core | `lxr-core:client:voiceChange` | `lxr-core:server:voiceChange` |
| RSG-Core | `RSGCore:Client:voiceChange` | `RSGCore:Server:voiceChange` |
| VORP | `vorp:client:voiceChange` | `vorp:server:voiceChange` |
| RedEM | `redem:voiceChange:client` | `redem:voiceChange:server` |
| QBR | `QBR:Client:voiceChange` | `QBR:Server:voiceChange` |
| QR | `QR:Client:voiceChange` | `QR:Server:voiceChange` |
| Standalone | `voiceChange` | `voiceChange` |

### **Using Framework Events:**

**Method 1: Using Adapter (Recommended)**
```lua
-- Automatically uses correct event name for framework
local eventName = Framework.GetEventName('server', 'voiceChange')
TriggerServerEvent(eventName, range, distance)
```

**Method 2: Direct (Framework-Specific)**
```lua
-- LXR-Core
TriggerServerEvent('lxr-core:server:voiceChange', range, distance)

-- VORP
TriggerServerEvent('vorp:server:voiceChange', range, distance)

-- Standalone
TriggerServerEvent('voiceChange', range, distance)
```

---

## 🔗 Framework Adapter API

### **Function: `Framework.GetEventName()`**

**Description:** Generate framework-specific event name

**Syntax:**
```lua
Framework.GetEventName(type, name)
```

**Parameters:**
- `type` (string): 'server' or 'client'
- `name` (string): Base event name

**Returns:** string - Formatted event name

**Example:**
```lua
-- Returns: 'lxr-core:server:voiceChange' (on LXR-Core)
local eventName = Framework.GetEventName('server', 'voiceChange')

-- Returns: 'RSGCore:Client:voiceChanged' (on RSG-Core)
local eventName = Framework.GetEventName('client', 'voiceChanged')

-- Returns: 'vorp:server:customEvent' (on VORP)
local eventName = Framework.GetEventName('server', 'customEvent')
```

---

### **Function: `Framework.Notify()`**

**Description:** Send notification using framework's system

**Syntax:**
```lua
Framework.Notify(type, message)
```

**Parameters:**
- `type` (string): 'success', 'info', 'error', 'warning'
- `message` (string): Notification message

**Example:**
```lua
-- Show success notification
Framework.Notify('success', 'Voice Range: Normal')

-- Show error notification
Framework.Notify('error', 'Please wait before changing voice range again')

-- Show info notification
Framework.Notify('info', 'Voice Range System Loaded')
```

---

### **Function: `Framework.GetPlayerData()`**

**Description:** Get player data from framework

**Syntax:**
```lua
Framework.GetPlayerData()
```

**Returns:** table - Player data (framework-specific structure)

**Example:**
```lua
local playerData = Framework.GetPlayerData()

-- LXR-Core / RSG-Core structure
if playerData.job then
    print('Player job: ' .. playerData.job.name)
end

-- VORP structure
if playerData.job then
    print('Player job: ' .. playerData.job)
end
```

---

### **Function: `Framework.IsPlayerLoaded()`**

**Description:** Check if player is fully loaded in framework

**Syntax:**
```lua
Framework.IsPlayerLoaded()
```

**Returns:** boolean - true if loaded, false otherwise

**Example:**
```lua
if Framework.IsPlayerLoaded() then
    -- Player is loaded, safe to access data
    local data = Framework.GetPlayerData()
else
    -- Player not loaded yet, wait
    print('Waiting for player to load...')
end
```

---

### **Function: `Framework.GetMessage()`**

**Description:** Get localized message from config

**Syntax:**
```lua
Framework.GetMessage(key, ...)
```

**Parameters:**
- `key` (string): Message key from Config.Notifications.Messages
- `...` (any): Format string arguments

**Returns:** string - Localized message

**Example:**
```lua
-- Get 'voiceChanged' message with range label
local msg = Framework.GetMessage('voiceChanged', 'Normal')
-- Returns: "Voice Range: Normal" (English)
-- Returns: "ხმის დიაპაზონი: Normal" (Georgian)

-- Get simple message
local msg = Framework.GetMessage('systemLoaded')
-- Returns: "Voice Range System Loaded"
```

---

### **Function: `Framework.GetVoiceLabel()`**

**Description:** Get localized label for voice range

**Syntax:**
```lua
Framework.GetVoiceLabel(range)
```

**Parameters:**
- `range` (string): Voice range ('whisper', 'normal', 'yell')

**Returns:** string - Localized label

**Example:**
```lua
-- Get label for 'normal' range
local label = Framework.GetVoiceLabel('normal')
-- Returns: "Normal" (English)
-- Returns: "ნორმალური" (Georgian)
-- Returns: "Normale" (Italian)

-- Get label for 'whisper' range
local label = Framework.GetVoiceLabel('whisper')
-- Returns: "Whisper" (English)
-- Returns: "ჩურჩული" (Georgian)
```

---

## 🎣 Event Hooks for Custom Scripts

### **Hook: Voice Range Change**

Monitor all voice range changes:

```lua
-- Monitor voice changes
AddEventHandler('lxr-voicerange:client:voiceChanged', function(range, distance)
    -- Your custom logic
    exports['my-hud']:updateVoiceIndicator(range)
end)
```

---

### **Hook: Rate Limiting**

Detect player spamming voice changes:

```lua
-- Server-side spam detection
AddEventHandler('lxr-voicerange:server:rateLimitExceeded', function(playerId, attempts, limit)
    -- Custom anti-spam action
    if attempts > limit * 3 then
        -- Extreme spamming, kick player
        DropPlayer(playerId, 'Voice range spam detected')
    end
end)
```

---

### **Hook: Voice Validation**

Add custom validation rules:

```lua
-- Server-side custom validation
AddEventHandler('lxr-voicerange:server:validateVoiceChange', function(range, distance)
    local src = source
    
    -- Example: Restrict voice range based on player location
    local coords = GetEntityCoords(GetPlayerPed(src))
    
    if IsPlayerInRestrictedArea(coords) then
        -- In restricted area, force whisper
        if range ~= 'whisper' then
            TriggerClientEvent('lxr-voicerange:client:rangeValidated', src, false, range, distance)
            Framework.Notify('error', 'You must whisper in this area!')
            return
        end
    end
end)
```

---

### **Hook: Visual Indicator**

Custom visual effects when voice indicator shows:

```lua
-- Client-side custom visual
AddEventHandler('lxr-voicerange:client:visualIndicatorShown', function(range, color)
    -- Add custom particle effect based on range
    if range == 'yell' then
        -- Create loud effect
        CreateSoundEffect('yell_echo', GetEntityCoords(PlayerPedId()))
    end
end)

AddEventHandler('lxr-voicerange:client:visualIndicatorHidden', function()
    -- Clean up effects
    StopAllSoundEffects()
end)
```

---

## 📊 Event Flow Diagrams

### **Voice Range Change Flow:**

```
1. Player presses Z key
   ↓
2. Client checks cooldown
   ↓
3. [Event] lxr-voicerange:client:cooldownActive (if active)
   ↓
4. Client cycles to next range
   ↓
5. Native functions called
   ↓
6. [Event] lxr-voicerange:client:voiceChanged
   ↓
7. Client → Server: validateVoiceChange
   ↓
8. [Event] lxr-voicerange:server:validateVoiceChange
   ↓
9. Server validates rate limit
   ↓
10. [Event] lxr-voicerange:server:rateLimitExceeded (if exceeded)
   ↓
11. Server validates distance
   ↓
12. [Event] lxr-voicerange:server:invalidDistance (if invalid)
   ↓
13. [Event] lxr-voicerange:server:voiceChangeValidated
   ↓
14. Server → Client: rangeValidated
   ↓
15. [Event] lxr-voicerange:client:rangeValidated
```

### **Visual Indicator Flow:**

```
1. Player holds Z key
   ↓
2. Client detects key held
   ↓
3. [Event] lxr-voicerange:client:visualIndicatorShown
   ↓
4. Colored circle rendered (every frame)
   ↓
5. Player releases Z key
   ↓
6. [Event] lxr-voicerange:client:visualIndicatorHidden
   ↓
7. Stop rendering
```

---

## 🛠️ Custom Event Examples

### **Example 1: Voice Range HUD Integration**

```lua
-- In your HUD resource

-- Update HUD when voice changes
RegisterNetEvent('lxr-voicerange:client:voiceChanged', function(range, distance)
    SendNUIMessage({
        type = 'updateVoice',
        range = range,
        distance = distance,
        label = Framework.GetVoiceLabel(range)
    })
end)

-- Show visual feedback when indicator shown
RegisterNetEvent('lxr-voicerange:client:visualIndicatorShown', function(range, color)
    SendNUIMessage({
        type = 'voiceActive',
        color = string.format('rgba(%s,%s,%s,%s)', color.r, color.g, color.b, color.a)
    })
end)

RegisterNetEvent('lxr-voicerange:client:visualIndicatorHidden', function()
    SendNUIMessage({
        type = 'voiceInactive'
    })
end)
```

---

### **Example 2: Discord Webhook Logging**

```lua
-- Server-side logging

local function SendWebhook(title, description, color)
    PerformHttpRequest('YOUR_WEBHOOK_URL', function(err, text, headers) end, 'POST', json.encode({
        embeds = {{
            title = title,
            description = description,
            color = color,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }), {['Content-Type'] = 'application/json'})
end

-- Log voice changes
AddEventHandler('lxr-voicerange:server:voiceChangeValidated', function(playerId, success, range, distance)
    if success then
        local playerName = GetPlayerName(playerId)
        SendWebhook(
            'Voice Range Changed',
            string.format('%s (%s) changed voice to: %s (%sm)', playerName, playerId, range, distance),
            3447003  -- Blue color
        )
    end
end)

-- Log rate limit violations
AddEventHandler('lxr-voicerange:server:rateLimitExceeded', function(playerId, attempts, limit)
    local playerName = GetPlayerName(playerId)
    SendWebhook(
        'Rate Limit Exceeded',
        string.format('%s (%s) exceeded rate limit: %s/%s attempts', playerName, playerId, attempts, limit),
        15158332  -- Red color
    )
end)
```

---

### **Example 3: Job-Based Voice Restrictions**

```lua
-- Server-side job restrictions

local jobVoiceRestrictions = {
    ['police'] = {
        allowWhisper = false,  -- Police can't whisper (radios required)
        allowNormal = true,
        allowYell = true
    },
    ['doctor'] = {
        allowWhisper = true,
        allowNormal = true,
        allowYell = false  -- Doctors must be professional (no yelling)
    }
}

AddEventHandler('lxr-voicerange:server:validateVoiceChange', function(range, distance)
    local src = source
    local playerJob = Framework.GetPlayerData().job.name  -- Framework-specific
    
    local restrictions = jobVoiceRestrictions[playerJob]
    if restrictions then
        local allowed = false
        
        if range == 'whisper' and restrictions.allowWhisper then allowed = true end
        if range == 'normal' and restrictions.allowNormal then allowed = true end
        if range == 'yell' and restrictions.allowYell then allowed = true end
        
        if not allowed then
            TriggerClientEvent('lxr-voicerange:client:rangeValidated', src, false, range, distance)
            TriggerClientEvent('lxr-voicerange:client:jobRestriction', src, playerJob, range)
            return
        end
    end
end)
```

---

## 🚨 Troubleshooting

### **Issue: Events not firing**

**Symptoms:**
- Custom event handlers not called
- No console output from events

**Solutions:**

1. **Check event names:**
```lua
-- Enable debug
Config.Debug.EnableDebugPrints = true

-- Manually test event
TriggerEvent('lxr-voicerange:client:voiceChanged', 'normal', 6.0)
```

2. **Verify event registration:**
```lua
-- Make sure event is registered before it's triggered
RegisterNetEvent('lxr-voicerange:client:voiceChanged')
AddEventHandler('lxr-voicerange:client:voiceChanged', function(range, distance)
    print('Event received: ' .. range)
end)
```

3. **Check framework adapter:**
```lua
-- Test framework event generation
print(Framework.GetEventName('server', 'voiceChange'))
```

---

### **Issue: Server events not received**

**Symptoms:**
- Server validation not working
- No rate limiting

**Solutions:**

1. **Check server validation enabled:**
```lua
Config.Security.EnableServerValidation = true
```

2. **Verify server event handler exists:**
```lua
-- In server file
RegisterNetEvent('lxr-voicerange:server:validateVoiceChange')
AddEventHandler('lxr-voicerange:server:validateVoiceChange', function(range, distance)
    print('Server received voice change request')
end)
```

---

## 📞 Event System Support

Need help with events?

1. **Check event names match exactly**
2. **Enable debug mode for diagnostics**
3. **Test events manually with TriggerEvent**
4. **Review console for errors**
5. **Visit Discord:** [wolves.land Discord](https://discord.gg/CrKcWdfd3A)
6. **Open GitHub Issue:** [Report Issue](https://github.com/iBoss21/lxr-voicerange/issues)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**

[← Back to Main README](../README.md) | [← Frameworks Guide](frameworks.md) | [Next: Security →](security.md)