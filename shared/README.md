# 🐺 Shared Scripts

**Framework bridge and shared utilities for LXR Voice Range system**

---

## Purpose

This directory contains shared scripts loaded on both client and server:
- Multi-framework adapter/bridge layer
- Unified API for cross-framework compatibility
- Framework auto-detection system
- Language/translation helpers

---

## Files

### `framework.lua`
Framework adapter providing unified functions across all supported frameworks.

**Responsibilities:**
- Auto-detect running framework (LXR, RSG, VORP, RedEM, QBR, QR)
- Provide unified notification system
- Handle player data retrieval
- Format framework-specific event names
- Multi-language message translation
- Voice range label localization

---

## Unified Adapter API

The framework bridge provides these universal functions:

### **Framework.Detect()**
Auto-detects the running framework by checking resource states.

### **Framework.Initialize()**
Initializes framework-specific objects and prepares the bridge.

### **Framework.Notify(type, message, duration)**
Sends notifications through the appropriate framework system.
- **Parameters:** type (success/error/info/warning), message, duration (ms)
- **Adapts to:** ox_lib, VORP, RedEM notifications, or chat fallback

### **Framework.GetPlayerData()**
Returns player data object from the active framework.
- **Returns:** Framework-specific player data or nil

### **Framework.IsPlayerLoaded()**
Checks if player has fully loaded into the game.
- **Returns:** boolean (true if loaded, false otherwise)

### **Framework.GetEventName(eventType, eventName)**
Formats event names according to framework conventions.
- **Parameters:** eventType (server/client/callback), eventName (base name)
- **Returns:** Properly formatted event name for active framework

### **Framework.TriggerEvent(eventType, eventName, ...)**
Triggers an event using framework-specific naming.
- **Parameters:** eventType (server/client), eventName, event arguments

### **Framework.GetMessage(key, ...)**
Retrieves a localized message in the configured language.
- **Parameters:** message key, format arguments
- **Returns:** Translated message string

### **Framework.GetVoiceLabel(rangeName)**
Returns the label for a voice range in the current language.
- **Parameters:** rangeName (whisper/normal/yell)
- **Returns:** Localized voice range label

---

## Framework Support

**Auto-Detection Priority:**
1. LXR-Core (Primary)
2. RSG-Core (Primary)
3. VORP Core (Supported)
4. RedEM:RP (Compatible)
5. QBR-Core (Compatible)
6. QR-Core (Compatible)
7. Standalone (Fallback)

---

## State Variables

**Framework.Active** - Currently detected framework name  
**Framework.Object** - Framework core object reference  
**Framework.Ready** - Boolean indicating framework is initialized  

---

## Example Usage

```lua
-- Send a notification
Framework.Notify('success', 'Voice range changed!')

-- Get player data
local playerData = Framework.GetPlayerData()

-- Check if player loaded
if Framework.IsPlayerLoaded() then
    -- Do something
end

-- Get localized message
local msg = Framework.GetMessage('voiceChanged', 'Normal')

-- Trigger framework event
Framework.TriggerEvent('server', 'voicerange:validate', distance)
```

---

## Multi-Language Support

Supports English, Georgian (ქართული), and Italian with easy extensibility.

Set language in `config.lua`:
```lua
Config.Lang = 'en'  -- 'en', 'ka', 'it'
```

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
