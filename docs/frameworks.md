```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# 🔌 LXR Voice Range - Framework Compatibility

**Framework auto-detection and integration guide**

---

## 📋 Overview

LXR Voice Range uses a **unified adapter pattern** to support multiple RedM frameworks without code duplication. The system automatically detects your framework and adapts to its structure, events, and notification system.

---

## 🎯 Supported Frameworks

| Framework | Support Level | Priority | Auto-Detect |
|-----------|--------------|----------|-------------|
| LXR-Core | ✅ **Primary** | 1 | Yes |
| RSG-Core | ✅ **Primary** | 2 | Yes |
| VORP Core | ✅ **Full** | 3 | Yes |
| RedEM:RP | ✅ **Compatible** | 4 | Yes |
| QBR-Core | ✅ **Compatible** | 5 | Yes |
| QR-Core | ✅ **Compatible** | 6 | Yes |
| Standalone | ✅ **Fallback** | 7 | Always |

---

## 🔄 Auto-Detection System

### **How It Works:**

```lua
-- Set to 'auto' in config.lua
Config.Framework = 'auto'
```

**Detection Process:**
1. System checks if resource exists for each framework (in priority order)
2. First detected framework is selected
3. Adapter functions are initialized for that framework
4. Framework name logged to console (if debug enabled)
5. Fallback to standalone if none detected

### **Detection Code:**

```lua
-- In shared/framework.lua
local function DetectFramework()
    -- Priority 1: LXR-Core
    if GetResourceState('lxr-core') == 'started' then
        return 'lxr-core'
    end
    
    -- Priority 2: RSG-Core
    if GetResourceState('rsg-core') == 'started' then
        return 'rsg-core'
    end
    
    -- Priority 3: VORP Core
    if GetResourceState('vorp_core') == 'started' then
        return 'vorp_core'
    end
    
    -- Priority 4: RedEM:RP
    if GetResourceState('redem_roleplay') == 'started' then
        return 'redem_roleplay'
    end
    
    -- Priority 5: QBR-Core
    if GetResourceState('qbr-core') == 'started' then
        return 'qbr-core'
    end
    
    -- Priority 6: QR-Core
    if GetResourceState('qr-core') == 'started' then
        return 'qr-core'
    end
    
    -- Priority 7: Standalone
    return 'standalone'
end
```

### **Manual Override:**

```lua
-- Force specific framework
Config.Framework = 'vorp_core'
```

**When to use manual override:**
- Multiple frameworks installed (rare)
- Testing specific framework integration
- Troubleshooting detection issues

---

## 🏗️ Framework Adapter Architecture

### **Unified API:**

The adapter provides a consistent interface regardless of framework:

```lua
-- Notification (works on all frameworks)
Framework.Notify('success', 'Voice Range: Normal')

-- Player data (framework-agnostic)
local player = Framework.GetPlayerData()

-- Check if player loaded
if Framework.IsPlayerLoaded() then
    -- Do something
end

-- Get localized message
local msg = Framework.GetMessage('voiceChanged', 'Normal')

-- Get voice label
local label = Framework.GetVoiceLabel('normal')

-- Format event name
local eventName = Framework.GetEventName('server', 'voiceChange')
```

### **Benefits:**

✅ **Single codebase** - No framework-specific forks  
✅ **Easy maintenance** - Update once, works everywhere  
✅ **Consistent behavior** - Same features on all frameworks  
✅ **Future-proof** - Easy to add new frameworks  

---

## 🔧 Framework-Specific Integration

### **1. LXR-Core**

**Status:** ✅ Primary Support (wolves.land native framework)

**Configuration:**
```lua
Config.FrameworkSettings['lxr-core'] = {
    resource = 'lxr-core',
    notifications = 'ox_lib',
    inventory = 'lxr-inventory',
    events = {
        server = 'lxr-core:server:%s',
        client = 'lxr-core:client:%s',
        callback = 'lxr-core:callback:%s'
    }
}
```

**Features:**
- Native ox_lib notification support
- Event naming convention: `lxr-core:server:eventName`
- Full player data integration
- Optimized for wolves.land servers

**Dependencies:**
```cfg
ensure ox_lib
ensure lxr-core
ensure lxr-voicerange
```

**Notification Example:**
```lua
-- Uses ox_lib notify
lib.notify({
    title = 'Voice Range',
    description = 'Voice Range: Normal',
    type = 'success',
    position = 'top'
})
```

---

### **2. RSG-Core**

**Status:** ✅ Primary Support

**Configuration:**
```lua
Config.FrameworkSettings['rsg-core'] = {
    resource = 'rsg-core',
    notifications = 'ox_lib',
    inventory = 'rsg-inventory',
    events = {
        server = 'RSGCore:Server:%s',
        client = 'RSGCore:Client:%s',
        callback = 'RSGCore:Callback:%s'
    }
}
```

**Features:**
- RSGCore object integration
- ox_lib notifications (recommended)
- Event naming: `RSGCore:Server:EventName`
- Full framework compatibility

**Dependencies:**
```cfg
ensure ox_lib
ensure rsg-core
ensure lxr-voicerange
```

**Event Examples:**
```lua
-- Server event
TriggerServerEvent('RSGCore:Server:voiceChange', distance)

-- Client event
RegisterNetEvent('RSGCore:Client:voiceChanged')
```

---

### **3. VORP Core**

**Status:** ✅ Full Support

**Configuration:**
```lua
Config.FrameworkSettings['vorp_core'] = {
    resource = 'vorp_core',
    notifications = 'vorp',
    inventory = 'vorp_inventory',
    events = {
        server = 'vorp:server:%s',
        client = 'vorp:client:%s'
    }
}
```

**Features:**
- Native VORP notification system
- VORP Core object integration
- Event naming: `vorp:server:eventName`
- Compatible with VORP ecosystem

**Dependencies:**
```cfg
ensure vorp_core
ensure vorp_inventory
ensure lxr-voicerange
```

**Notification Example:**
```lua
-- Uses VORP's notification system
TriggerEvent('vorp:TipRight', 'Voice Range: Normal', 3000)
```

**VORP-Specific Notes:**
- VORP uses different notification methods (TipRight, TipBottom)
- Player data structure differs from QBCore-based frameworks
- Event naming uses lowercase convention

---

### **4. RedEM:RP**

**Status:** ✅ Compatible

**Configuration:**
```lua
Config.FrameworkSettings['redem_roleplay'] = {
    resource = 'redem_roleplay',
    notifications = 'redem',
    inventory = 'redem_inventory',
    events = {
        server = 'redem:%s:server',
        client = 'redem:%s:client'
    }
}
```

**Features:**
- RedEM notification integration
- Event naming: `redem:eventName:server`
- Basic player data support

**Dependencies:**
```cfg
ensure redem_roleplay
ensure lxr-voicerange
```

**Event Examples:**
```lua
-- Server event
TriggerServerEvent('redem:voiceChange:server', distance)

-- Client event
RegisterNetEvent('redem:voiceChanged:client')
```

**RedEM-Specific Notes:**
- Event naming has different structure (action in middle)
- Notification system is simpler than VORP/QBCore
- Limited callback support

---

### **5. QBR-Core**

**Status:** ✅ Compatible

**Configuration:**
```lua
Config.FrameworkSettings['qbr-core'] = {
    resource = 'qbr-core',
    notifications = 'ox_lib',
    inventory = 'qbr-inventory',
    events = {
        server = 'QBR:Server:%s',
        client = 'QBR:Client:%s'
    }
}
```

**Features:**
- QBR (RedM port of QBCore)
- ox_lib notification support
- Event naming: `QBR:Server:EventName`
- Similar structure to RSG-Core

**Dependencies:**
```cfg
ensure ox_lib
ensure qbr-core
ensure lxr-voicerange
```

---

### **6. QR-Core**

**Status:** ✅ Compatible

**Configuration:**
```lua
Config.FrameworkSettings['qr-core'] = {
    resource = 'qr-core',
    notifications = 'ox_lib',
    inventory = 'qr-inventory',
    events = {
        server = 'QR:Server:%s',
        client = 'QR:Client:%s'
    }
}
```

**Features:**
- QR Core integration
- ox_lib notifications
- Event naming: `QR:Server:EventName`
- Alternative QBCore port

**Dependencies:**
```cfg
ensure ox_lib
ensure qr-core
ensure lxr-voicerange
```

---

### **7. Standalone Mode**

**Status:** ✅ Fallback (No Framework)

**Configuration:**
```lua
Config.FrameworkSettings['standalone'] = {
    notifications = 'print',
    inventory = 'none'
}
```

**Features:**
- No framework required
- Chat-based notifications
- Basic functionality only
- No player data integration

**Dependencies:**
```cfg
ensure lxr-voicerange
```

**Limitations:**
- No framework notifications
- No player data access
- Events are direct triggers
- Chat-based feedback only

**When to Use:**
- Minimal server setup
- No framework installed
- Testing/development
- Custom server builds

---

## 📡 Event System

### **Event Naming Conventions:**

Each framework has its own event naming pattern:

| Framework | Server Event Format | Example |
|-----------|-------------------|---------|
| LXR-Core | `lxr-core:server:%s` | `lxr-core:server:voiceChange` |
| RSG-Core | `RSGCore:Server:%s` | `RSGCore:Server:voiceChange` |
| VORP | `vorp:server:%s` | `vorp:server:voiceChange` |
| RedEM | `redem:%s:server` | `redem:voiceChange:server` |
| QBR | `QBR:Server:%s` | `QBR:Server:voiceChange` |
| QR | `QR:Server:%s` | `QR:Server:voiceChange` |
| Standalone | `%s` | `voiceChange` |

### **Using Events:**

**Framework-agnostic approach:**
```lua
-- Get correct event name for current framework
local eventName = Framework.GetEventName('server', 'voiceChange')

-- Trigger it
TriggerServerEvent(eventName, distance)
```

**Direct approach (if you know the framework):**
```lua
-- LXR-Core
TriggerServerEvent('lxr-core:server:voiceChange', distance)

-- VORP
TriggerServerEvent('vorp:server:voiceChange', distance)

-- Standalone
TriggerServerEvent('voiceChange', distance)
```

---

## 🔔 Notification Systems

### **Notification Type Mapping:**

Different frameworks use different notification libraries:

| Framework | Notification System | Library |
|-----------|-------------------|---------|
| LXR-Core | ox_lib | External |
| RSG-Core | ox_lib | External |
| VORP | VORP Native | Built-in |
| RedEM | RedEM Native | Built-in |
| QBR | ox_lib | External |
| QR | ox_lib | External |
| Standalone | Chat | Native |

### **ox_lib Notifications:**

**Frameworks that use ox_lib:**
- LXR-Core
- RSG-Core
- QBR-Core
- QR-Core

**Implementation:**
```lua
lib.notify({
    title = 'Voice Range',
    description = 'Voice Range: Normal',
    type = 'success',  -- success, info, error, warning
    position = 'top',  -- top, top-right, top-left, bottom, etc.
    duration = 3000
})
```

### **VORP Notifications:**

```lua
-- Right side tip
TriggerEvent('vorp:TipRight', 'Voice Range: Normal', 3000)

-- Bottom notification
TriggerEvent('vorp:NotifyLeft', 'Voice Range', 'Voice Range: Normal', 'generic_textures', 'tick', 3000)
```

### **Standalone/Chat Fallback:**

```lua
-- Simple chat message
TriggerEvent('chat:addMessage', {
    color = {100, 255, 100},
    multiline = false,
    args = {'Voice Range', 'Voice Range: Normal'}
})
```

---

## 🛠️ Adding a Custom Framework

### **Step 1: Define Framework Settings**

In `config.lua`, add your framework:

```lua
Config.FrameworkSettings['myframework'] = {
    resource = 'my-core',                    -- Resource name to detect
    notifications = 'ox_lib',                -- Notification system
    inventory = 'my-inventory',              -- Inventory resource (optional)
    events = {
        server = 'MyCore:Server:%s',         -- Server event pattern
        client = 'MyCore:Client:%s',         -- Client event pattern
        callback = 'MyCore:Callback:%s'      -- Callback pattern (optional)
    }
}
```

### **Step 2: Update Auto-Detection**

In `shared/framework.lua`, add detection:

```lua
local function DetectFramework()
    -- ... existing checks ...
    
    -- Add your framework
    if GetResourceState('my-core') == 'started' then
        return 'myframework'
    end
    
    return 'standalone'
end
```

### **Step 3: Implement Adapter Functions**

In `shared/framework.lua`, add framework-specific logic:

```lua
if Framework.Name == 'myframework' then
    -- Get framework object
    local MyCore = exports['my-core']:GetCoreObject()
    
    -- Implement notification function
    Framework.Notify = function(type, message)
        MyCore.Functions.Notify(message, type, 3000)
    end
    
    -- Implement player data function
    Framework.GetPlayerData = function()
        return MyCore.Functions.GetPlayerData()
    end
    
    -- ... other functions
end
```

### **Step 4: Test**

```lua
-- Set config to use your framework
Config.Framework = 'myframework'

-- Or let it auto-detect
Config.Framework = 'auto'
```

---

## 🧪 Testing Framework Integration

### **Console Checks:**

**Framework detection:**
```lua
Config.Debug.ShowFrameworkDetection = true
```

Expected output:
```
[LXR-VoiceRange] Framework detected: lxr-core
[LXR-VoiceRange] Notification system: ox_lib
```

**Event testing:**
```lua
-- Test event name generation
print(Framework.GetEventName('server', 'test'))
-- Should output: lxr-core:server:test (or framework-specific format)
```

### **In-Game Testing:**

1. **Test notifications:**
   - Change voice range
   - Verify notification appears
   - Check notification styling

2. **Test visual indicator:**
   - Hold voice key
   - Verify colored circle appears
   - Check color matches range

3. **Test rate limiting:**
   - Rapidly change voice range
   - Should be limited by cooldown
   - Server should validate

---

## 📊 Framework Comparison

### **Feature Support Matrix:**

| Feature | LXR | RSG | VORP | RedEM | QBR | QR | Standalone |
|---------|-----|-----|------|-------|-----|----|-----------| 
| Auto-Detect | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Notifications | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ Chat |
| Player Data | ✅ | ✅ | ✅ | ⚠️ Basic | ✅ | ✅ | ❌ |
| Callbacks | ✅ | ✅ | ⚠️ Limited | ❌ | ✅ | ✅ | ❌ |
| Inventory | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Custom Events | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ Basic |

Legend:
- ✅ Full support
- ⚠️ Partial/Limited support
- ❌ Not supported

---

## 🚨 Troubleshooting

### **Issue: Framework not detected**

**Symptoms:**
- Falls back to standalone mode
- No framework notifications

**Solutions:**

1. **Check resource name:**
```cfg
ensure lxr-core  # Not 'lxr_core' or 'lxrcore'
```

2. **Verify resource started:**
```
resmon  # In server console
# Check if framework is running
```

3. **Check start order:**
```cfg
# Framework MUST start before voice range
ensure lxr-core
ensure lxr-voicerange  # After framework
```

4. **Manual override:**
```lua
Config.Framework = 'lxr-core'  # Force specific framework
```

### **Issue: Notifications not showing**

**Symptoms:**
- Voice changes but no notification
- Console errors about lib or framework

**Solutions:**

1. **Check ox_lib (if used):**
```cfg
ensure ox_lib  # Must be before framework and voice range
```

2. **Enable chat fallback:**
```lua
Config.Notifications.FallbackToChat = true
```

3. **Check framework notification system:**
```lua
-- Test notification manually
lib.notify({ title = 'Test', description = 'Testing', type = 'info' })
```

### **Issue: Events not firing**

**Symptoms:**
- Voice changes not validated
- No server-side logging

**Solutions:**

1. **Check event names:**
```lua
-- Enable debug
Config.Debug.EnableDebugPrints = true

-- Check generated event name
print(Framework.GetEventName('server', 'voiceChange'))
```

2. **Verify server validation enabled:**
```lua
Config.Security.EnableServerValidation = true
```

3. **Check for event name conflicts:**
```bash
# Search for conflicting resources
grep -r "voiceChange" resources/
```

---

## 📞 Framework Support

Need help with framework integration?

1. **Check this guide thoroughly**
2. **Review your framework's documentation**
3. **Test on a development server**
4. **Enable debug mode for diagnostics**
5. **Visit Discord:** [wolves.land Discord](https://discord.gg/CrKcWdfd3A)
6. **Open GitHub Issue:** [Report Issue](https://github.com/iBoss21/lxr-voicerange/issues)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**

[← Back to Main README](../README.md) | [← Configuration Guide](configuration.md) | [Next: Events →](events.md)
