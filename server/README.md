# 🐺 Server Scripts

**Server-side validation and security for LXR Voice Range system**

---

## Purpose

This directory contains server-side scripts that provide:
- Voice change validation
- Rate limiting and anti-abuse protection
- Suspicious activity logging
- Player tracking and cleanup
- Security enforcement

---

## Files

### `validation.lua`
Server validation and security script.

**Responsibilities:**
- Validate voice distance changes server-side
- Enforce rate limits (max changes per minute)
- Log suspicious activity and potential abuse
- Track player voice changes
- Automatic cleanup of stale data
- Distance validation against allowed ranges

---

## Key Functions

**CheckRateLimit(source)**  
Validates that player hasn't exceeded voice change rate limit.

**RecordVoiceChange(source)**  
Logs a voice change for rate limiting tracking.

**ValidateDistance(distance)**  
Checks if requested distance is within allowed range and matches configured values.

**GetPlayerIdentifier(source)**  
Returns unique identifier for player tracking.

---

## Event Handlers

**Voice Validation Events:**
- `lxr-core:server:voicerange:validate` - Main validation event
- `RSGCore:Server:voicerange:validate` - RSG framework alias
- `vorp:server:voicerange:validate` - VORP framework alias
- `lxr-voicerange:server:voicerange:validate` - Generic alias

**Player Management:**
- `playerDropped` - Cleanup tracking data on disconnect

---

## Security Features

✅ **Server Authority** - All validation done server-side  
✅ **Rate Limiting** - Configurable max changes per minute  
✅ **Distance Validation** - Must match allowed voice ranges  
✅ **Activity Logging** - Optional suspicious activity logs  
✅ **Automatic Cleanup** - Stale data removed every 5 minutes  

---

## Configuration

Security settings in `config.lua`:

```lua
Config.Security = {
    EnableServerValidation = true,
    MaxVoiceChangesPerMinute = 30,
    LogSuspiciousActivity = false,
    MinAllowedDistance = 1.0,
    MaxAllowedDistance = 20.0
}
```

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
