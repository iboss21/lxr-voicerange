```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# ⚙️ LXR Voice Range - Installation Guide

**Step-by-step installation instructions**

---

## 📋 Prerequisites

Before installing LXR Voice Range, ensure you have:

✅ **RedM Server** - Build 1491 or higher recommended  
✅ **FXServer** - Latest artifact recommended  
✅ **Framework** (Optional) - LXR-Core, RSG-Core, VORP, RedEM, QBR, QR, or Standalone  
✅ **Server Access** - Ability to add/restart resources  
✅ **Basic Knowledge** - Understanding of FiveM/RedM resource structure  

---

## 📦 Method 1: Release Download (Recommended)

### **Step 1: Download**
1. Visit [GitHub Releases](https://github.com/iBoss21/lxr-voicerange/releases)
2. Download the latest `lxr-voicerange.zip` file
3. Extract the ZIP to your desktop

### **Step 2: Install**
1. Copy the `lxr-voicerange` folder to your server's `resources/` directory
2. Verify the folder is named **exactly** `lxr-voicerange` (no spaces, no variations)

### **Step 3: Configure**
1. Open `resources/lxr-voicerange/config.lua` in a text editor
2. Review and adjust settings as needed (see [Configuration Guide](configuration.md))
3. Save the file

### **Step 4: Enable**
1. Open your `server.cfg` file
2. Add this line: `ensure lxr-voicerange`
3. Save `server.cfg`

### **Step 5: Restart**
1. Restart your RedM server
2. Check console for the startup banner
3. Join your server and press `Z` to test

---

## 🔄 Method 2: Git Clone (For Developers)

### **Step 1: Clone Repository**
```bash
cd resources/
git clone https://github.com/iBoss21/lxr-voicerange.git
```

### **Step 2: Verify Folder Name**
```bash
# Folder MUST be named lxr-voicerange
ls -la lxr-voicerange/
```

### **Step 3: Configure & Enable**
Follow Steps 3-5 from Method 1 above.

---

## ⚙️ Configuration

### **Basic Configuration (Quick Start)**

The default configuration works out of the box, but you may want to adjust:

1. **Language** - Change `Config.Lang` to your preferred language:
   ```lua
   Config.Lang = 'en'  -- Options: 'en', 'ka', 'it'
   ```

2. **Framework** - Usually auto-detected, but can be set manually:
   ```lua
   Config.Framework = 'auto'  -- or 'lxr-core', 'rsg-core', 'vorp_core', etc.
   ```

3. **Voice Distances** - Adjust if needed:
   ```lua
   Config.VoiceRanges = {
       whisper = { distance = 2.0 },   -- Short
       normal = { distance = 6.0 },    -- Medium
       yell = { distance = 15.0 }      -- Long
   }
   ```

4. **Key Binding** - Change the voice key if needed:
   ```lua
   Config.Keys = {
       VoiceChange = 0x3C3DD371  -- Z key (default)
   }
   ```

For detailed configuration options, see the [Configuration Guide](configuration.md).

---

## 🔌 Framework-Specific Setup

### **LXR-Core / RSG-Core**
No additional setup required. The resource will auto-detect and integrate.

**Optional:** If using `ox_lib`, ensure it's started before `lxr-voicerange`:
```cfg
ensure ox_lib
ensure lxr-core  # or rsg-core
ensure lxr-voicerange
```

### **VORP Core**
No additional setup required. VORP notifications work out of the box.

```cfg
ensure vorp_core
ensure lxr-voicerange
```

### **RedEM:RP**
Auto-detected. Ensure RedEM is started first:

```cfg
ensure redem_roleplay
ensure lxr-voicerange
```

### **QBR-Core / QR-Core**
Auto-detected. Recommended with `ox_lib`:

```cfg
ensure ox_lib
ensure qbr-core  # or qr-core
ensure lxr-voicerange
```

### **Standalone Mode**
Works without any framework:

```cfg
ensure lxr-voicerange
```

---

## ✅ Verification

### **Console Check**
After server restart, look for this banner in the console:

```
═══════════════════════════════════════════════════════════════════════
🐺 LXR Voice Range System - Loaded
═══════════════════════════════════════════════════════════════════════

Version: 2.0.0
Framework: Auto-detect enabled
Language: en

Voice Ranges: 3 modes configured
Default Range: normal

🐺 wolves.land - The Land of Wolves

═══════════════════════════════════════════════════════════════════════
```

### **In-Game Test**
1. Join your server
2. Press `Z` key
3. You should see a notification: "Voice Range: Normal" (or your language)
4. Hold `Z` key - A colored circle should appear around your character
5. Press `Z` again to cycle through ranges

---

## 🚨 Troubleshooting

### **Issue: "Resource name mismatch" error**

**Cause:** Folder is not named exactly `lxr-voicerange`

**Solution:**
```bash
# Rename the folder
mv lxr-voicerange-main lxr-voicerange
# or
mv lxr-voice lxr-voicerange
```

### **Issue: No notifications showing**

**Cause:** Framework notification system not detected

**Solution 1:** Enable fallback to chat
```lua
Config.Notifications.FallbackToChat = true
```

**Solution 2:** Install `ox_lib` for better notifications
```cfg
ensure ox_lib
```

### **Issue: Visual indicator not showing**

**Cause:** Setting disabled or performance mode active

**Solution:**
```lua
Config.General.ShowVisualIndicator = true
Config.Performance.DrawCircleOnlyWhenHolding = true
```

### **Issue: Voice range not changing**

**Cause:** Native voice system not working or key binding conflict

**Solution 1:** Check key binding
```lua
-- Try a different key
Config.Keys.VoiceChange = 0x760A9C6F  -- G key
```

**Solution 2:** Check if another script conflicts
```bash
# Disable other voice scripts temporarily
```

### **Issue: Server lag/performance problems**

**Cause:** Debug mode enabled or rate limiting too low

**Solution:**
```lua
Config.Debug.EnableDebugPrints = false
Config.Debug.LogVoiceChanges = false
Config.Security.MaxVoiceChangesPerMinute = 30  -- Increase if needed
```

---

## 🔄 Updating

### **From Version 1.x to 2.0**

1. **Backup** your old `config.lua` settings
2. **Delete** the old `lxr-voicerange` folder
3. **Install** the new version using Method 1 or 2 above
4. **Migrate** your custom settings to the new `config.lua`
5. **Restart** your server

**Breaking Changes:**
- File structure changed (old `voice.lua` is now `client/voice.lua`)
- Config structure enhanced (new sections added)
- Server validation added (optional, can be disabled)

### **Keeping Up to Date**

**Git Method:**
```bash
cd resources/lxr-voicerange
git pull origin main
```

**Manual Method:**
1. Download latest release
2. Extract and replace old files
3. Merge config changes if needed

---

## 📝 Server.cfg Example

Complete example with all recommended dependencies:

```cfg
# Core Framework (choose one)
ensure lxr-core
# ensure rsg-core
# ensure vorp_core
# ensure redem_roleplay
# ensure qbr-core
# ensure qr-core

# Recommended Libraries
ensure ox_lib

# Voice Range System
ensure lxr-voicerange

# Voice Chat (separate - not included)
ensure mumble-voip
```

---

## 🎯 Post-Installation

After successful installation:

1. **Test All Ranges** - Cycle through whisper/normal/yell
2. **Test Visual Indicator** - Hold key and verify colored circle
3. **Test Notifications** - Ensure messages show properly
4. **Test with Players** - Have multiple players test together
5. **Check Server Console** - Look for any errors or warnings
6. **Review Configuration** - Adjust settings to match your server's needs

---

## 📞 Need Help?

If you encounter issues:

1. **Check Troubleshooting** section above
2. **Review Configuration** in [Configuration Guide](configuration.md)
3. **Check Console** for error messages
4. **Visit Discord** - [Join wolves.land Discord](https://discord.gg/CrKcWdfd3A)
5. **Open GitHub Issue** - [Report Bug](https://github.com/iBoss21/lxr-voicerange/issues)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**

[← Back to Main README](../README.md) | [Next: Configuration →](configuration.md)
