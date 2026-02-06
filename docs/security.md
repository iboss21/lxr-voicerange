```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# 🔒 LXR Voice Range - Security Guide

**Security features, validation, anti-abuse measures, and best practices**

---

## 📋 Overview

LXR Voice Range is built with security as a core principle. The system assumes hostile clients and validates everything server-side. This guide covers the multi-layer security architecture, anti-abuse measures, and best practices.

---

## 🛡️ Security Architecture

### **Defense in Depth:**

```
Layer 1: Resource Name Protection (Runtime)
   ↓
Layer 2: Client-Side Validation (UX optimization)
   ↓
Layer 3: Server-Side Validation (Security boundary)
   ↓
Layer 4: Rate Limiting (Anti-abuse)
   ↓
Layer 5: Logging & Monitoring (Detection)
```

---

## 🔐 Layer 1: Resource Name Protection

### **Purpose:**
Prevent breaking branded resources through incorrect naming

### **Implementation:**

```lua
local REQUIRED_RESOURCE_NAME = "lxr-voicerange"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error([[
        ═══════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════
        
        Expected: lxr-voicerange
        Got: ]] .. currentResourceName .. [[
        
        Rename the folder to "lxr-voicerange" to continue.
        ═══════════════════════════════════════════════════════════════
    ]])
end
```

### **Protection Against:**
- Accidental renaming breaking the resource
- Support issues from incorrectly named folders
- Breaking branded resource distribution

### **Bypass Prevention:**
- Runtime check (cannot be disabled in config)
- Executes before any resource logic
- Server refuses to start resource if check fails

---

## 🔒 Layer 2: Client-Side Validation

### **Purpose:**
Provide immediate feedback and reduce unnecessary server load

### **Validations:**

#### **1. Cooldown Check**

```lua
local lastVoiceChange = 0
local cooldown = Config.Cooldowns.VoiceChangeDelay

-- Check if enough time passed
if GetGameTimer() - lastVoiceChange < cooldown then
    -- Still in cooldown
    TriggerEvent('lxr-voicerange:client:cooldownActive', cooldown - (GetGameTimer() - lastVoiceChange))
    return
end
```

**Protects Against:**
- Player spamming voice changes
- Excessive server events
- UX degradation from rapid changes

**Configuration:**
```lua
Config.Cooldowns = {
    VoiceChangeDelay = 500  -- Milliseconds (0.5 seconds)
}
```

#### **2. Input Validation**

```lua
-- Only accept valid voice ranges
local validRanges = {'whisper', 'normal', 'yell'}

if not table.contains(validRanges, newRange) then
    print('[ERROR] Invalid voice range: ' .. tostring(newRange))
    return
end
```

**Protects Against:**
- Invalid range values
- Nil/undefined values
- Type mismatches

---

## 🛡️ Layer 3: Server-Side Validation

### **Purpose:**
Primary security boundary - validate all client requests

### **Configuration:**

```lua
Config.Security = {
    EnableServerValidation = true,       -- Master toggle
    MaxVoiceChangesPerMinute = 30,       -- Rate limit
    LogSuspiciousActivity = false,       -- Console logging
    MinAllowedDistance = 1.0,            -- Min distance
    MaxAllowedDistance = 20.0            -- Max distance
}
```

### **Validation Checks:**

#### **1. Distance Validation**

```lua
-- Server-side distance check
local function ValidateDistance(distance)
    if distance < Config.Security.MinAllowedDistance then
        return false, 'Distance too short'
    end
    
    if distance > Config.Security.MaxAllowedDistance then
        return false, 'Distance too long'
    end
    
    -- Check against configured ranges
    local validDistance = false
    for range, config in pairs(Config.VoiceRanges) do
        if math.abs(config.distance - distance) < 0.1 then
            validDistance = true
            break
        end
    end
    
    if not validDistance then
        return false, 'Distance not in configured ranges'
    end
    
    return true, 'Valid'
end
```

**Protects Against:**
- Clients sending unrealistic distances
- Exploits trying to set unlimited voice range
- Modified client scripts
- Menu injectors

**Example Attack Prevention:**
```lua
-- Attacker tries to set 1000m voice range
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'yell', 1000.0)

-- Server validation rejects:
-- 1000.0 > Config.Security.MaxAllowedDistance (20.0)
-- Request denied, logged if suspicious logging enabled
```

#### **2. Range Validation**

```lua
-- Validate range exists in config
local function ValidateRange(range)
    if not Config.VoiceRanges[range] then
        return false, 'Range not found in configuration'
    end
    return true, 'Valid'
end
```

**Protects Against:**
- Custom/undefined ranges
- Typos or corruption
- Exploits using invalid range names

#### **3. Player Validation**

```lua
-- Validate player exists and is active
local function ValidatePlayer(playerId)
    local playerPed = GetPlayerPed(playerId)
    
    if not playerPed or playerPed == 0 then
        return false, 'Invalid player'
    end
    
    if not DoesEntityExist(playerPed) then
        return false, 'Player entity does not exist'
    end
    
    return true, 'Valid'
end
```

**Protects Against:**
- Requests from non-existent players
- Requests after player disconnect
- Zombie player entities

---

## ⏱️ Layer 4: Rate Limiting

### **Purpose:**
Prevent abuse through rapid voice changes

### **Configuration:**

```lua
Config.Security = {
    MaxVoiceChangesPerMinute = 30  -- 30 changes per 60 seconds
}
```

### **Implementation:**

```lua
-- Server-side rate limiter
local playerVoiceChanges = {}  -- Track player changes

-- Clean up old entries periodically
CreateThread(function()
    while true do
        Wait(60000)  -- Every minute
        
        for playerId, data in pairs(playerVoiceChanges) do
            -- Remove entries older than 1 minute
            local now = os.time()
            data.changes = {}
            for i, timestamp in ipairs(data.changes) do
                if now - timestamp <= 60 then
                    table.insert(data.changes, timestamp)
                end
            end
            
            -- Remove player entry if no recent changes
            if #data.changes == 0 then
                playerVoiceChanges[playerId] = nil
            end
        end
    end
end)

-- Rate limit check
RegisterNetEvent('lxr-voicerange:server:validateVoiceChange', function(range, distance)
    local src = source
    
    -- Initialize player tracking
    if not playerVoiceChanges[src] then
        playerVoiceChanges[src] = {changes = {}}
    end
    
    -- Add current change
    table.insert(playerVoiceChanges[src].changes, os.time())
    
    -- Count changes in last minute
    local changeCount = #playerVoiceChanges[src].changes
    
    -- Check limit
    if changeCount > Config.Security.MaxVoiceChangesPerMinute then
        -- Exceeded rate limit
        TriggerEvent('lxr-voicerange:server:rateLimitExceeded', src, changeCount, Config.Security.MaxVoiceChangesPerMinute)
        TriggerClientEvent('lxr-voicerange:client:rateLimited', src, changeCount, Config.Security.MaxVoiceChangesPerMinute)
        
        -- Reject change
        return
    end
    
    -- Proceed with validation...
end)
```

### **Rate Limit Examples:**

| Setting | Changes Per Minute | Effective Cooldown |
|---------|-------------------|-------------------|
| 5 | 5 | Every 12 seconds |
| 10 | 10 | Every 6 seconds |
| 20 | 20 | Every 3 seconds |
| 30 | 30 (default) | Every 2 seconds |
| 60 | 60 | Every 1 second |
| 120 | 120 | Every 0.5 seconds |

**Choosing a Rate Limit:**

**Conservative (Hardcore RP):**
```lua
MaxVoiceChangesPerMinute = 10  -- Very limited changes
```

**Balanced (Recommended):**
```lua
MaxVoiceChangesPerMinute = 30  -- Default setting
```

**Relaxed (Casual Servers):**
```lua
MaxVoiceChangesPerMinute = 60  -- Generous allowance
```

### **Rate Limit Bypass Prevention:**

❌ **Cannot be bypassed by:**
- Client-side modifications
- Script injectors
- Menu mods
- Rapid key pressing

✅ **Protected by:**
- Server-side enforcement
- Per-player tracking
- Timestamp validation
- Automatic cleanup

---

## 📊 Layer 5: Logging & Monitoring

### **Purpose:**
Detect and log suspicious activity for investigation

### **Configuration:**

```lua
Config.Security = {
    LogSuspiciousActivity = true  -- Enable console logging
}
```

### **Logged Events:**

#### **1. Rate Limit Violations**

```lua
-- Example log output
[LXR-VoiceRange] [SECURITY] Player 1 (John_Doe) exceeded rate limit: 45/30 changes
[LXR-VoiceRange] [SECURITY] Player 1 (John_Doe) possible spam attack detected
```

#### **2. Invalid Distance Attempts**

```lua
-- Example log output
[LXR-VoiceRange] [SECURITY] Player 3 (Jane_Smith) attempted invalid distance: 100.0m (max: 20.0m)
[LXR-VoiceRange] [SECURITY] Player 3 (Jane_Smith) possible exploit attempt
```

#### **3. Validation Failures**

```lua
-- Example log output
[LXR-VoiceRange] [SECURITY] Player 5 validation failed: Invalid range 'custom_range'
[LXR-VoiceRange] [SECURITY] Player 7 validation failed: Player entity not found
```

### **Log Format:**

```lua
-- Standard log format
string.format('[LXR-VoiceRange] [%s] Player %s (%s) %s',
    level,      -- INFO, WARNING, SECURITY
    playerId,   -- Source player ID
    playerName, -- Player name
    message     -- Event description
)
```

---

## 🚨 Attack Scenarios & Mitigations

### **Scenario 1: Unlimited Voice Range Exploit**

**Attack:**
```lua
-- Attacker tries to set 1000m voice range
ExecuteCommand('voicerange 1000')
-- or
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'yell', 1000.0)
```

**Mitigation:**
```lua
-- Server validation rejects
if distance > Config.Security.MaxAllowedDistance then
    -- Logged: "Player X attempted invalid distance: 1000.0m (max: 20.0m)"
    -- Request rejected
    -- Player notified: "Invalid voice range"
    return
end
```

**Result:** ✅ Attack prevented, logged, player unchanged

---

### **Scenario 2: Voice Range Spam Attack**

**Attack:**
```lua
-- Attacker spams voice changes rapidly
while true do
    TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'normal', 6.0)
    Wait(10)  -- Every 10ms
end
```

**Mitigation:**
```lua
-- Client cooldown prevents most attempts (500ms default)
-- Server rate limiting catches the rest (30/minute)

-- After 30 changes in 60 seconds:
if changeCount > Config.Security.MaxVoiceChangesPerMinute then
    -- Logged: "Player X exceeded rate limit: 31/30"
    -- All further requests rejected for remainder of minute
    TriggerEvent('lxr-voicerange:server:rateLimitExceeded', playerId, 31, 30)
    return
end
```

**Result:** ✅ Attack prevented after 30 changes, player rate-limited

---

### **Scenario 3: Custom Voice Range Injection**

**Attack:**
```lua
-- Attacker creates custom range
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'megaphone', 500.0)
```

**Mitigation:**
```lua
-- Server validates range exists in config
if not Config.VoiceRanges[range] then
    -- Logged: "Player X validation failed: Invalid range 'megaphone'"
    -- Request rejected
    return
end

-- Server validates distance matches configured range
local validDistance = false
for rangeName, config in pairs(Config.VoiceRanges) do
    if math.abs(config.distance - distance) < 0.1 then
        validDistance = true
    end
end

if not validDistance then
    -- Logged: "Player X attempted invalid distance: 500.0m (not in configured ranges)"
    return
end
```

**Result:** ✅ Attack prevented, invalid range rejected

---

### **Scenario 4: Negative Distance Exploit**

**Attack:**
```lua
-- Attacker tries negative distance (undefined behavior)
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'whisper', -10.0)
```

**Mitigation:**
```lua
-- Server validates minimum distance
if distance < Config.Security.MinAllowedDistance then
    -- Logged: "Player X attempted invalid distance: -10.0m (min: 1.0m)"
    return
end
```

**Result:** ✅ Attack prevented, negative value rejected

---

### **Scenario 5: Disconnected Player Exploit**

**Attack:**
```lua
-- Attacker sends requests after disconnect
-- (Can happen with certain exploit menus)
```

**Mitigation:**
```lua
-- Server validates player exists
local playerPed = GetPlayerPed(playerId)
if not playerPed or playerPed == 0 then
    -- Logged: "Player X validation failed: Invalid player entity"
    return
end

if not DoesEntityExist(playerPed) then
    -- Logged: "Player X validation failed: Player entity does not exist"
    return
end
```

**Result:** ✅ Attack prevented, zombie requests rejected

---

## 🔧 Security Best Practices

### **1. Always Enable Server Validation**

```lua
-- ✅ DO THIS (Production)
Config.Security.EnableServerValidation = true

-- ❌ NEVER DO THIS (Production)
Config.Security.EnableServerValidation = false  -- Only for testing!
```

### **2. Use Appropriate Rate Limits**

```lua
-- ✅ Good rate limits
Config.Security.MaxVoiceChangesPerMinute = 30  -- Balanced
Config.Security.MaxVoiceChangesPerMinute = 20  -- Strict RP

-- ⚠️ Questionable rate limits
Config.Security.MaxVoiceChangesPerMinute = 120  -- Very permissive
Config.Security.MaxVoiceChangesPerMinute = 5   -- Too strict for normal use

-- ❌ Dangerous rate limits
Config.Security.MaxVoiceChangesPerMinute = 999  -- Basically disabled
Config.Security.MaxVoiceChangesPerMinute = 0   -- Completely disabled
```

### **3. Set Realistic Distance Bounds**

```lua
-- ✅ Realistic bounds (Recommended)
Config.Security = {
    MinAllowedDistance = 1.0,   -- 1 meter minimum
    MaxAllowedDistance = 20.0   -- 20 meters maximum
}

-- ⚠️ Extended bounds (Use with caution)
Config.Security = {
    MinAllowedDistance = 0.5,
    MaxAllowedDistance = 50.0  -- Very long range allowed
}

-- ❌ Unrealistic bounds (Not recommended)
Config.Security = {
    MinAllowedDistance = 0.1,
    MaxAllowedDistance = 1000.0  -- Essentially unlimited
}
```

### **4. Enable Logging for Monitoring**

```lua
-- ✅ Enable on production (at least initially)
Config.Security.LogSuspiciousActivity = true

-- Check logs regularly for:
-- - Repeated rate limit violations
-- - Invalid distance attempts
-- - Patterns of abuse
```

### **5. Ensure Voice Ranges Fit Within Bounds**

```lua
-- ✅ All ranges within security bounds
Config.VoiceRanges = {
    whisper = { distance = 2.0 },   -- Within 1.0 - 20.0
    normal = { distance = 6.0 },    -- Within 1.0 - 20.0
    yell = { distance = 15.0 }      -- Within 1.0 - 20.0
}

Config.Security = {
    MinAllowedDistance = 1.0,
    MaxAllowedDistance = 20.0
}

-- ❌ Range exceeds bounds (Will be rejected!)
Config.VoiceRanges = {
    yell = { distance = 25.0 }  -- EXCEEDS MaxAllowedDistance!
}

Config.Security = {
    MaxAllowedDistance = 20.0  -- yell range will fail validation!
}
```

### **6. Regular Security Audits**

**Weekly Checklist:**
- [ ] Review suspicious activity logs
- [ ] Check for repeated rate limit violations
- [ ] Monitor for unusual patterns
- [ ] Verify no unauthorized changes to config
- [ ] Test validation with known exploits

**Monthly Checklist:**
- [ ] Review security settings for optimization
- [ ] Update rate limits based on server behavior
- [ ] Test integration with new scripts
- [ ] Backup configuration files
- [ ] Update resource if new version available

---

## 📈 Security Metrics

### **Measuring Security Effectiveness:**

```lua
-- Track security events over time
local securityMetrics = {
    totalValidations = 0,
    rateLimitViolations = 0,
    invalidDistances = 0,
    invalidRanges = 0,
    blockedRequests = 0
}

-- Calculate security score
local function GetSecurityScore()
    if securityMetrics.totalValidations == 0 then
        return 100
    end
    
    local blockedPercentage = (securityMetrics.blockedRequests / securityMetrics.totalValidations) * 100
    
    -- Higher blocked % might indicate:
    -- - Active attack attempts (bad)
    -- - Overly strict settings (consider review)
    
    return 100 - blockedPercentage
end
```

**Interpreting Metrics:**

| Blocked % | Interpretation | Action |
|-----------|---------------|--------|
| 0-5% | Normal operation | ✅ Good |
| 5-15% | Some invalid requests | ⚠️ Monitor |
| 15-30% | Frequent violations | ⚠️ Investigate |
| 30-50% | Major issues | 🚨 Review settings |
| 50%+ | Under attack or misconfigured | 🚨 Immediate action |

---

## 🛠️ Security Testing

### **Test 1: Distance Validation**

```lua
-- Test maximum distance rejection
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'yell', 100.0)
-- Expected: Rejected, logged

-- Test minimum distance rejection
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'whisper', 0.1)
-- Expected: Rejected, logged

-- Test valid distance
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'normal', 6.0)
-- Expected: Accepted
```

### **Test 2: Rate Limiting**

```lua
-- Spam test (run in loop)
for i = 1, 50 do
    TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'normal', 6.0)
    Wait(100)
end
-- Expected: First 30 accepted, remaining 20 rejected
```

### **Test 3: Invalid Range**

```lua
-- Test non-existent range
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'custom', 10.0)
-- Expected: Rejected, logged
```

### **Test 4: Framework Injection**

```lua
-- Test with modified framework object
Framework = nil
TriggerServerEvent('lxr-voicerange:server:validateVoiceChange', 'normal', 6.0)
-- Expected: Server validates independently, works correctly
```

---

## 🔐 Advanced Security Features

### **Optional: IP-Based Rate Limiting**

```lua
-- Track by IP instead of player ID (more robust)
local ipRateLimits = {}

function GetPlayerIP(playerId)
    return GetPlayerEndpoint(playerId):match("(.-):")
end

RegisterNetEvent('lxr-voicerange:server:validateVoiceChange', function(range, distance)
    local src = source
    local ip = GetPlayerIP(src)
    
    -- Rate limit by IP instead of player ID
    if not ipRateLimits[ip] then
        ipRateLimits[ip] = {changes = {}}
    end
    
    -- ... rest of rate limiting logic using ipRateLimits[ip]
end)
```

### **Optional: Webhook Notifications**

```lua
-- Alert admins of security events
function SendSecurityWebhook(title, description, severity)
    PerformHttpRequest(Config.Security.WebhookURL, function() end, 'POST', json.encode({
        embeds = {{
            title = title,
            description = description,
            color = severity == 'high' and 15158332 or 16776960,  -- Red or Yellow
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }), {['Content-Type'] = 'application/json'})
end

-- Send on rate limit violations
AddEventHandler('lxr-voicerange:server:rateLimitExceeded', function(playerId, attempts, limit)
    local playerName = GetPlayerName(playerId)
    SendSecurityWebhook(
        'Rate Limit Exceeded',
        string.format('%s (ID: %s) exceeded rate limit: %s/%s', playerName, playerId, attempts, limit),
        'medium'
    )
end)
```

### **Optional: Automated Bans**

```lua
-- Auto-kick on excessive violations
local playerViolations = {}

AddEventHandler('lxr-voicerange:server:rateLimitExceeded', function(playerId, attempts, limit)
    playerViolations[playerId] = (playerViolations[playerId] or 0) + 1
    
    if playerViolations[playerId] >= 5 then
        -- 5 rate limit violations = kick
        DropPlayer(playerId, 'Kicked: Excessive voice range spam detected')
        print(string.format('[LXR-VoiceRange] [SECURITY] Player %s auto-kicked for excessive violations', playerId))
    end
end)
```

---

## 📞 Security Support

Security concerns or questions?

1. **Review this security guide thoroughly**
2. **Enable logging and monitor for patterns**
3. **Test security features on development server**
4. **Report exploits privately:** security@wolves.land (if applicable)
5. **Visit Discord:** [wolves.land Discord](https://discord.gg/CrKcWdfd3A)
6. **Open GitHub Issue:** [Report Issue](https://github.com/iBoss21/lxr-voicerange/issues) (non-security bugs only)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**

[← Back to Main README](../README.md) | [← Events Guide](events.md) | [Next: Performance →](performance.md)
