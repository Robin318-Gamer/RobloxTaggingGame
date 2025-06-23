# Roblox Tagging Game - Deployment Guide

## 📋 Prerequisites

- **Roblox Studio** installed and updated to latest version
- **Roblox Developer Account** (free)
- Basic understanding of Roblox Studio interface

---

## 🚀 Step-by-Step Deployment Instructions

### **Phase 1: Studio Setup**

#### **Step 1: Create New Place**
1. Open **Roblox Studio**
2. Click **"New"** → Select **"Baseplate"** template
3. Save the place: **File** → **Save to Roblox As...** 
4. Name it: `"Tagging Game"` or similar
5. Set description: `"Multiplayer ghost tagging game"`

#### **Step 2: Verify Studio Structure**
Ensure your Studio has these services in the Explorer:
- `ServerScriptService`
- `ReplicatedStorage`
- `StarterPlayer` → `StarterPlayerScripts`
- `Workspace`

---

### **Phase 2: Script Implementation**

#### **Step 3: Copy GameConfig (Shared Module)**
1. In Studio Explorer, right-click **ReplicatedStorage**
2. Select **Insert Object** → **ModuleScript**
3. Rename it to `GameConfig`
4. Delete the default code
5. Copy **ALL** content from `ReplicatedStorage/GameConfig.lua`
6. Paste into the Studio ModuleScript

#### **Step 4: Copy SoundManager (Shared Module)**
1. Right-click **ReplicatedStorage** again
2. Insert another **ModuleScript**
3. Rename it to `SoundManager`
4. Delete default code
5. Copy **ALL** content from `ReplicatedStorage/SoundManager.lua`
6. Paste into Studio

#### **Step 5: Copy GameManager (Server Script)**
1. Right-click **ServerScriptService**
2. Select **Insert Object** → **Script** (NOT ModuleScript)
3. Rename it to `GameManager`
4. Delete default code
5. Copy **ALL** content from `ServerScriptService/GameManager.lua`
6. Paste into Studio

#### **Step 6: Copy GameClient (Client Script)**
1. Navigate to **StarterPlayer** → **StarterPlayerScripts**
2. Right-click **StarterPlayerScripts**
3. Insert **LocalScript** (NOT regular Script)
4. Rename it to `GameClient`
5. Delete default code
6. Copy **ALL** content from `StarterPlayer/StarterPlayerScripts/GameClient.lua`
7. Paste into Studio

---

### **Phase 3: Testing Setup**

#### **Step 7: Configure for Testing**
**✅ Verify GameConfig Debug Settings:**
```lua
GameConfig.Debug = {
    Enabled = true,
    ShowPlayerPositions = true,
    QuickStart = true,  -- IMPORTANT: Skips waiting for min players
    ShowMapGeneration = true
}
```

#### **Step 8: Initial Test**
1. Press **F5** or click the **Play** button
2. **Check Output Window** (View → Output) for errors
3. Look for these success indicators:
   - ✅ `"GameManager initialized"`
   - ✅ `"Map generated successfully"`
   - ✅ Green base platform appears in Workspace
   - ✅ Red ghost room in center
   - ✅ UI appears on screen

#### **Step 9: Multi-Player Testing**
1. Stop the test (Shift + F5)
2. Click **Play** dropdown → **Start Server and Players**
3. Set **Players: 2** (minimum for game)
4. Click **Start**
5. **Verify:**
   - Both players see the UI
   - Game starts automatically (QuickStart = true)
   - One player becomes ghost
   - Ghost gets locked in red room initially

---

### **Phase 4: Troubleshooting**

#### **Common Issues & Solutions:**

**❌ Scripts don't load:**
- Check Output window for red error messages
- Ensure ModuleScripts are in ReplicatedStorage
- Verify LocalScript is in StarterPlayerScripts

**❌ Map doesn't generate:**
- Look for `"Creating base platform"` in Output
- Check if Workspace contains "BasePlatform" object
- Verify GameManager script is running

**❌ UI doesn't appear:**
- Check if GameClient LocalScript is running
- Look for RemoteEvents in ReplicatedStorage
- Verify no errors in client script

**❌ Game doesn't start:**
- Ensure `QuickStart = true` for testing
- Check minimum players setting
- Look for timer updates in Output

---

### **Phase 5: Production Configuration**

#### **Step 10: Prepare for Publishing**
1. Open **GameConfig** in ReplicatedStorage
2. **Change debug settings:**
```lua
GameConfig.Debug = {
    Enabled = false,        -- Disable debug output
    ShowPlayerPositions = false,
    QuickStart = false,     -- Require minimum players
    ShowMapGeneration = false
}
```

#### **Step 11: Game Settings**
1. **File** → **Game Settings**
2. **Basic Info:**
   - Name: `"Ghost Tagging Game"`
   - Description: `"Hide from the ghost or tag all players to win!"`
   - Max Players: `10` (matches GameConfig.MaxPlayers)
3. **Access:**
   - Set to **Public** when ready
   - Use **Private** for testing

#### **Step 12: Final Testing**
1. Test with `QuickStart = false`
2. Verify game waits for minimum players
3. Test full game cycle:
   - Waiting → Starting → Preparation → Playing → Finished
4. Check win conditions work correctly

---

### **Phase 6: Publishing & Maintenance**

#### **Step 13: Publish Game**
1. **File** → **Publish to Roblox**
2. **First time:** Creates new game
3. **Updates:** Publishes to existing game
4. **Configure game page** on Roblox website:
   - Add thumbnail screenshots
   - Write compelling description
   - Add relevant tags

#### **Step 14: Monitor & Update**
- **Check player feedback** regularly
- **Monitor game analytics** in Creator Dashboard
- **Update configurations** in GameConfig as needed
- **Test updates** in Studio before publishing

---

## 🎮 Game Configuration Reference

### **Key Settings You Can Adjust:**

| Setting | Default | Description |
|---------|---------|-------------|
| `MinPlayers` | 2 | Minimum players to start |
| `MaxPlayers` | 10 | Maximum server capacity |
| `PreparationTime` | 30s | Ghost lockdown duration |
| `GameTime` | 300s | Main game duration |
| `TagDistance` | 10 | How close to tag players |
| `MapSize` | 200 | Size of generated map |

### **For Balancing:**
- **Too easy for ghost?** Decrease `TagDistance` or `GameTime`
- **Too hard for players?** Increase hiding spots or `PreparationTime`
- **Games too long?** Reduce `GameTime`
- **Not enough players joining?** Lower `MinPlayers`

---

## 🔧 Advanced Customization

### **Adding Custom Maps:**
Replace the `MapGenerator:GenerateRandomMap()` function to load your custom map instead of generating random terrain.

### **Custom Sounds:**
Upload audio files to Roblox and replace the sound IDs in `GameConfig.Sounds`.

### **UI Themes:**
Modify colors in `GameConfig.UI.Colors` to match your preferred theme.

---

## 📞 Support & Debugging

### **Debug Output Messages:**
Enable `GameConfig.Debug.Enabled = true` to see detailed logging:
- `"Player joined: [PlayerName]"`
- `"Game state changed to: [State]"`
- `"Ghost selected: [PlayerName]"`
- `"Map generation completed"`

### **Performance Tips:**
- Keep `MaxPlayers` ≤ 10 for smooth performance
- Monitor part count if adding custom map elements
- Test on mobile devices for broader accessibility

---

## ✅ Deployment Checklist

**Before Publishing:**
- [ ] All scripts copied to correct locations
- [ ] Multi-player testing completed successfully
- [ ] Debug mode disabled (`Enabled = false`)
- [ ] Game settings configured (name, description, max players)
- [ ] Win/lose conditions tested
- [ ] UI displays correctly on different screen sizes
- [ ] No error messages in Output window

**After Publishing:**
- [ ] Game accessible from Roblox website
- [ ] Thumbnail and description added
- [ ] Friends/testers can join and play
- [ ] Monitor for any live issues
- [ ] Collect player feedback for improvements

---

*Last Updated: June 2025*
*Game Version: 1.0*
