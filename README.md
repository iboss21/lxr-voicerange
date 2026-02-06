```
    ██╗     ██╗  ██╗██████╗       ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║   ██║██╔═══██╗██║██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║   ██║██║   ██║██║██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝
```

# 🐺 LXR Voice Range System

**Production-grade voice proximity control for RedM servers**

A sophisticated voice range system that allows players to cycle through different voice distances (whisper, normal, yell) with visual feedback and multi-framework support.

---

## 🌟 Features

✅ **Multi-Framework Support** - Works with LXR-Core, RSG-Core, VORP Core, RedEM:RP, QBR-Core, QR-Core, and Standalone  
✅ **Three Voice Ranges** - Whisper (2m), Normal (6m), Yell (15m)  
✅ **Visual Indicators** - Colored circles show current voice range  
✅ **Smart Notifications** - Framework-aware notification system  
✅ **Server Validation** - Anti-abuse rate limiting and security  
✅ **Multi-Language** - English, Georgian (ქართული), Italian  
✅ **Performance Optimized** - Zero FPS impact with smart caching  
✅ **Fully Configurable** - Every aspect can be customized  

---

## 📦 Installation

1. Download the latest release from [GitHub](https://github.com/iBoss21/lxr-voicerange)
2. Extract to your resources folder as `lxr-voicerange` (name must match exactly)
3. Add `ensure lxr-voicerange` to your `server.cfg`
4. Configure `config.lua` to match your server needs
5. Restart your server

**⚠️ Important:** The folder MUST be named `lxr-voicerange` - the resource has runtime name protection.

---

## 🎮 Usage

- **Press Z** - Cycle through voice ranges (Whisper → Normal → Yell)
- **Hold Z** - Show colored range indicator circle

**Voice Ranges:**
- 🔵 **Whisper** - 2 meters (quiet, private conversations)
- 🟢 **Normal** - 6 meters (standard talking distance)
- 🔴 **Yell** - 15 meters (shouting, long distance)

---

## 🔧 Configuration

All settings are centralized in `config.lua`. Key configuration sections:

- **Framework Settings** - Auto-detection or manual framework selection
- **Voice Ranges** - Customize distances, labels, and colors
- **Key Bindings** - Change the voice toggle key
- **Security** - Rate limiting and validation settings
- **Performance** - Optimization toggles and cache settings
- **Notifications** - Multi-language messages

See [Configuration Guide](docs/configuration.md) for detailed settings.

---

## 🔌 Framework Support

**Primary Support:**
- **LXR-Core** - Full integration with LXR ecosystem
- **RSG-Core** - Complete RSG framework compatibility

**Full Support:**
- **VORP Core** - Native VORP notifications and events
- **RedEM:RP** - RedEM framework integration
- **QBR-Core** - QBCore for RedM support
- **QR-Core** - QR framework support
- **Standalone** - Works without any framework

Auto-detection is enabled by default. Manual framework selection is also supported.

See [Framework Guide](docs/frameworks.md) for framework-specific details.

---

## 📚 Documentation

Complete documentation is available in the `/docs` folder:

- [📖 Overview](docs/overview.md) - System architecture and features
- [⚙️ Installation](docs/installation.md) - Step-by-step setup guide
- [🔧 Configuration](docs/configuration.md) - All configuration options
- [🔌 Frameworks](docs/frameworks.md) - Framework compatibility details
- [📡 Events](docs/events.md) - Event system and adapter functions
- [🔒 Security](docs/security.md) - Security features and best practices
- [⚡ Performance](docs/performance.md) - Optimization and benchmarks
- [📸 Screenshots](docs/screenshots.md) - Visual examples and media

---

## 🔒 Security Features

- ✅ Server-side validation of all voice changes
- ✅ Rate limiting (configurable per-minute limit)
- ✅ Distance validation (prevents unrealistic ranges)
- ✅ Suspicious activity logging
- ✅ Resource name protection (prevents renaming)
- ✅ Framework event verification

---

## ⚡ Performance

- **Zero FPS Impact** - Optimized native calls and caching
- **Smart Threading** - Conditional waits based on activity
- **Efficient Natives** - Minimal RedM native usage
- **Server Optimized** - Lightweight validation system

---

## 🌍 Server Information

**The Land of Wolves 🐺**  
Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!  
*ისტორია ცოცხლდება აქ!* (History Lives Here!)

- **Type:** Serious Hardcore Roleplay
- **Access:** Discord & Whitelisted
- **Website:** [wolves.land](https://www.wolves.land)
- **Discord:** [Join Server](https://discord.gg/CrKcWdfd3A)
- **Server Listing:** [RedM Servers](https://servers.redm.net/servers/detail/8gj7eb)

---

## 👨‍💻 Credits & Support

**Author:** iBoss21 / The Lux Empire  
**GitHub:** [github.com/iBoss21](https://github.com/iBoss21)  
**Store:** [theluxempire.tebex.io](https://theluxempire.tebex.io)

**Original Code:** Community contribution  
**Enhanced by:** iBoss21 with Land of Wolves branding and multi-framework architecture

---

## 📄 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

This resource is branded for The Land of Wolves server. You may use it on your own server but must maintain credits and attribution.

---

## 🐺 Support & Community

For support, bug reports, or feature requests:
- Open an issue on [GitHub](https://github.com/iBoss21/lxr-voicerange/issues)
- Join our [Discord](https://discord.gg/CrKcWdfd3A)
- Visit [wolves.land](https://www.wolves.land)

---

**🐺 wolves.land - The Land of Wolves - Where History Lives**
