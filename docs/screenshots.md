```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# 📸 LXR Voice Range - Screenshots & Media

**Visual documentation and asset requirements**

---

## 📋 Required Screenshots

All screenshots should be stored in `/docs/assets/screenshots/` and must be taken at **1920x1080** resolution for consistency.

---

## ✅ Screenshot Checklist

### **01_startup_console.png** ✅ REQUIRED
**What to capture:**
- Server console showing the LXR Voice Range startup banner
- Framework detection message
- Version information
- Language and voice range count

**How to capture:**
```bash
# Start server and capture console output
ensure lxr-voicerange
# Screenshot the startup banner
```

**Expected output:**
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

---

### **02_config_sections.png** ✅ REQUIRED
**What to capture:**
- `config.lua` file open in a code editor
- Show the mega-branded header
- Show section banners (████ style)
- Show voice range configuration section

**Recommended editor:**
- VS Code with Lua extension
- Sublime Text
- Notepad++ with Lua highlighting

---

### **03_ui_interaction.png** ✅ REQUIRED
**What to capture:**
- In-game screenshot showing voice range notification
- Player character visible
- Notification showing "Voice Range: Normal" (or other range)
- Clear, readable UI

**How to capture:**
1. Join server
2. Press `Z` to change voice range
3. Take screenshot when notification appears
4. Ensure notification is clearly visible

---

### **04_visual_indicator.png** ✅ REQUIRED
**What to capture:**
- Player character with colored range indicator circle visible
- Hold `Z` key to show the circle
- Capture all three colors if possible:
  - Blue circle (Whisper)
  - Green circle (Normal)
  - Red circle (Yell)

**How to capture:**
1. Join server
2. Press `Z` to cycle to desired range
3. Hold `Z` key to show indicator
4. Take screenshot while holding key
5. Repeat for all three ranges

**Note:** You may need 3 separate screenshots (04a, 04b, 04c) for each color.

---

### **05_framework_detection.png** ✅ REQUIRED
**What to capture:**
- Server console showing framework detection
- Shows: "Framework detected: [framework name]"
- Shows framework bridge initialization message

**Expected output:**
```
═══════════════════════════════════════════════════════════════════════
🐺 LXR Voice Range - Framework Bridge Initialized
═══════════════════════════════════════════════════════════════════════

Active Framework: lxr-core
Framework Ready: true
Notification System: ox_lib

═══════════════════════════════════════════════════════════════════════
```

---

### **06_txadmin_performance.png** ✅ REQUIRED (If using txAdmin)
**What to capture:**
- txAdmin performance monitor showing lxr-voicerange resource
- CPU usage (should be < 0.01%)
- Memory usage (should be minimal)
- Threads count

**How to access:**
1. Open txAdmin panel
2. Go to "Performance" or "Resources"
3. Find `lxr-voicerange` in the list
4. Take screenshot showing its stats

**Alternative:** If not using txAdmin, use in-game `/resmon` command and capture that.

---

### **07_multi_range_comparison.png** ⭐ OPTIONAL
**What to capture:**
- Side-by-side or grid comparison of all three voice ranges
- Show the visual difference in circle sizes
- Label each with the range name and distance

**Suggested layout:**
```
[Whisper - 2m] [Normal - 6m] [Yell - 15m]
  [Blue circle]  [Green circle] [Red circle]
```

---

### **08_notification_languages.png** ⭐ OPTIONAL
**What to capture:**
- Screenshots of notifications in different languages
- English, Georgian, Italian
- Shows multi-language support

**How to capture:**
1. Change `Config.Lang` in config.lua
2. Restart resource
3. Trigger voice change
4. Screenshot notification
5. Repeat for each language

---

### **09_security_logs.png** ⭐ OPTIONAL (If security logging enabled)
**What to capture:**
- Server console showing security log entries
- Rate limit warnings
- Invalid distance attempts
- Suspicious activity logs

**How to enable:**
```lua
Config.Security.LogSuspiciousActivity = true
Config.Debug.LogVoiceChanges = true
```

---

### **10_resource_files.png** ⭐ OPTIONAL
**What to capture:**
- File explorer showing the resource directory structure
- All folders visible (client, server, shared, docs)
- File names visible

---

## 📁 Storage Structure

Screenshots should be organized as follows:

```
docs/assets/screenshots/
├── 01_startup_console.png          # Required
├── 02_config_sections.png          # Required
├── 03_ui_interaction.png           # Required
├── 04a_visual_indicator_whisper.png # Required (Blue)
├── 04b_visual_indicator_normal.png  # Required (Green)
├── 04c_visual_indicator_yell.png    # Required (Red)
├── 05_framework_detection.png      # Required
├── 06_txadmin_performance.png      # Required
├── 07_multi_range_comparison.png   # Optional
├── 08_notification_languages.png   # Optional
├── 09_security_logs.png            # Optional
└── 10_resource_files.png           # Optional
```

---

## 🎬 Video Demonstrations (Optional)

Consider creating video demonstrations:

### **Short Demo Video (30-60 seconds)**
- Show voice range cycling
- Demonstrate visual indicators
- Show notification system
- Display smooth performance

### **Installation Tutorial (5-10 minutes)**
- Step-by-step installation
- Configuration walkthrough
- Testing and verification
- Troubleshooting common issues

### **Framework Integration Video**
- Show auto-detection working
- Demonstrate different frameworks
- Show notification systems

**Suggested platforms:**
- YouTube
- Streamable
- GitHub video attachments

---

## 📸 Screenshot Guidelines

### **Technical Requirements:**
- **Resolution:** 1920x1080 (Full HD)
- **Format:** PNG (preferred) or JPG
- **Quality:** High quality, no compression artifacts
- **Brightness:** Clear and readable

### **Content Requirements:**
- **Visibility:** UI elements clearly visible
- **Context:** Show relevant information
- **Clean:** No unrelated HUD elements if possible
- **Professional:** No offensive content or language

### **Naming Convention:**
```
[number]_[description]_[optional_variant].png

Examples:
01_startup_console.png
04a_visual_indicator_whisper.png
08_notification_languages_georgian.png
```

---

## 🖼️ Using Screenshots

Screenshots will be used for:

1. **Documentation** - Embedded in markdown files
2. **GitHub README** - Featured in main README.md
3. **Store Listings** - If listed on tebex or similar
4. **Social Media** - Promotional content
5. **Support** - Troubleshooting reference

---

## 📤 Contributing Screenshots

If you'd like to contribute screenshots:

1. **Fork** the repository
2. **Add** screenshots to `/docs/assets/screenshots/`
3. **Follow** naming conventions above
4. **Submit** a pull request
5. **Include** description of what's captured

---

## 🎨 Branding Requirements

All screenshots and media must:

✅ **Maintain** wolves.land branding where visible  
✅ **Show** professional server setup  
✅ **Respect** copyright and credits  
✅ **Avoid** offensive or inappropriate content  
✅ **Represent** the resource accurately  

---

## 🚫 What NOT to Include

Do not capture screenshots with:

❌ Offensive player names or chat messages  
❌ Other servers' branding (unless demo purposes)  
❌ Pirated or cracked software indicators  
❌ Exploits or glitches  
❌ Unrelated mods that might confuse users  

---

## 📊 Screenshot Status

Current screenshot availability:

| Screenshot | Status | Priority | Notes |
|------------|--------|----------|-------|
| 01_startup_console | ⏳ Pending | HIGH | Need console capture |
| 02_config_sections | ⏳ Pending | HIGH | Code editor view |
| 03_ui_interaction | ⏳ Pending | HIGH | Notification visible |
| 04_visual_indicator | ⏳ Pending | HIGH | All 3 colors needed |
| 05_framework_detection | ⏳ Pending | HIGH | Framework bridge init |
| 06_txadmin_performance | ⏳ Pending | MEDIUM | Performance stats |
| 07_multi_range_comparison | ⏳ Pending | LOW | Nice to have |
| 08_notification_languages | ⏳ Pending | LOW | Shows translation |
| 09_security_logs | ⏳ Pending | LOW | Security features |
| 10_resource_files | ⏳ Pending | LOW | File structure |

**Legend:**
- ✅ Available - Screenshot exists and meets requirements
- ⏳ Pending - Needs to be captured
- 🔄 Update Needed - Exists but needs to be redone
- ❌ Not Available - Cannot be captured

---

## 📞 Questions?

For questions about screenshots or media:

- **Discord:** [Join wolves.land Discord](https://discord.gg/CrKcWdfd3A)
- **GitHub:** [Open an Issue](https://github.com/iBoss21/lxr-voicerange/issues)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved**

[← Back to Main README](../README.md)
