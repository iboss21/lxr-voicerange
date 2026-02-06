# 🐺 Client Scripts

**Client-side voice range control for LXR Voice Range system**

---

## Purpose

This directory contains client-side scripts that handle:
- Voice range cycling and control
- Visual indicator rendering
- Key press detection and input handling
- Framework notification integration
- Performance optimization and caching

---

## Files

### `voice.lua`
Main client script for voice proximity control.

**Responsibilities:**
- Detect Z key presses for voice cycling
- Apply RedM native voice functions
- Render colored circle indicators
- Send notifications via framework bridge
- Manage client-side state and caching
- Handle performance optimization

---

## Key Functions

**ChangeVoiceRange(newRange)**  
Changes the current voice range and applies native settings.

**DrawVoiceIndicator()**  
Renders a colored circle indicator showing current voice range.

**GetNextVoiceRange()**  
Cycles to the next voice range in the configured order.

**CanChangeVoice()**  
Checks cooldown to prevent voice change spam.

---

## Event Handlers

- `playerSpawned` - Initialize voice settings on spawn
- `QBCore:Client:OnPlayerLoaded` - Framework player loaded (LXR/RSG/QBR/QR)
- `RSGCore:Client:OnPlayerLoaded` - RSG-specific player loaded
- `vorp:SelectedCharacter` - VORP character selection
- `redemrp:playerLoaded` - RedEM player loaded

---

## Performance

The client script is heavily optimized:
- **FPS Impact:** ~0ms (negligible)
- **Cached Player Ped:** Updates every 100ms instead of every frame
- **Conditional Waits:** Longer waits when system idle
- **Smart Rendering:** Visual indicator only when holding key

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
