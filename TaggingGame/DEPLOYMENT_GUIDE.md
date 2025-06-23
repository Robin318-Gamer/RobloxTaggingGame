
# Roblox Tagging Game - Beginner Deployment Guide

Welcome! This guide will help you set up and publish the Tagging Game in Roblox Studio, even if you have never used Roblox Studio before. Every step is explained in detail. If you get stuck, check the Troubleshooting section or ask for help!


## 📋 Prerequisites

- **Roblox Studio**: Download and install from [roblox.com/create](https://www.roblox.com/create)
- **Roblox Account**: Sign up for free if you don’t have one
- **This Project’s Scripts**: You already have them in this folder

No prior experience with Roblox Studio is required!

---

## 🚀 Step-by-Step Deployment Instructions


### **Phase 1: Open Roblox Studio and Create Your Game**

#### **Step 1: Start a New Project**
1. Open **Roblox Studio** (double-click the icon on your desktop or find it in your Start menu)
2. Click the **New** tab at the top
3. Click the **Baseplate** template (this gives you a flat world to start with)
4. Wait for the editor to load

#### **Step 2: Save Your Game to Roblox**
1. Click **File** (top left) → **Save to Roblox As...**
2. If prompted, log in to your Roblox account
3. Enter a name, e.g., `Tagging Game`
4. Enter a description, e.g., `Multiplayer ghost tagging game`
5. Click **Create**

#### **Step 3: Show the Explorer and Properties Panels**
1. Click the **View** tab at the top
2. Click **Explorer** and **Properties** so both are checked (these panels help you see and manage your game’s structure)

#### **Step 4: Check for These Folders in Explorer**
You should see these items in the Explorer panel:
- **Workspace**
- **ReplicatedStorage**
- **ServerScriptService**
- **StarterPlayer** (expand it to see **StarterPlayerScripts**)

If you don’t see any of these, right-click the top-level game name in Explorer, choose **Insert Object**, and add the missing service (e.g., ReplicatedStorage).

---


### **Phase 2: Add the Scripts to Your Game**

#### **What Are Scripts and Where Do They Go?**
- **ModuleScript**: A reusable code file (like a library)
- **Script**: Runs on the server (controls the game)
- **LocalScript**: Runs on each player’s computer (controls the UI)

#### **Step 5: Add GameConfig (ModuleScript)**
1. In Explorer, right-click **ReplicatedStorage**
2. Click **Insert Object** → **ModuleScript**
3. Rename it to `GameConfig` (right-click, choose Rename)
4. Click the new `GameConfig` to open it
5. Delete all the default code in the script
6. Open `GameConfig.lua` from this project (in Notepad or VS Code)
7. Copy everything (Ctrl+A, Ctrl+C)
8. Paste into the Studio script (Ctrl+V)
9. Press **Ctrl+S** to save

#### **Step 6: Add SoundManager (ModuleScript)**
1. Repeat the above steps, but name it `SoundManager`
2. Copy all code from `SoundManager.lua` and paste it in

#### **Step 7: Add GameManager (Script)**
1. Right-click **ServerScriptService**
2. Click **Insert Object** → **Script**
3. Rename it to `GameManager`
4. Delete all default code
5. Copy all code from `GameManager.lua` and paste it in

#### **Step 8: Add GameClient (LocalScript)**
1. Expand **StarterPlayer** in Explorer
2. Expand **StarterPlayerScripts**
3. Right-click **StarterPlayerScripts**
4. Click **Insert Object** → **LocalScript**
5. Rename it to `GameClient`
6. Delete all default code
7. Copy all code from `GameClient.lua` and paste it in

**Tip:** If you make a mistake, you can always delete the script and start again.

---


### **Phase 3: Test Your Game in Studio**

#### **Step 9: Set Debug Settings for Easy Testing**
Open your `GameConfig` ModuleScript in Studio and make sure this section looks like this:
```lua
GameConfig.Debug = {
    Enabled = true,
    ShowPlayerPositions = true,
    QuickStart = true,  -- Skips waiting for min players
    ShowMapGeneration = true
}
```
This makes testing much easier!

#### **Step 10: Run Your Game**
1. Click the **Home** tab at the top
2. Click the big **Play** button (or press F5)
3. Wait for the game to load
4. If you see a green platform and a red room in the middle, it’s working!
5. If you see errors, click **View** → **Output** to see what went wrong

#### **Step 11: Test with Multiple Players**
1. Click the small arrow under the **Play** button
2. Choose **Start Server and Players**
3. Set **Players: 2** (or more)
4. Click **Start**
5. Two game windows will open (one for each player)
6. Make sure both players see the UI and the game starts automatically

**Tip:** You can move the player with WASD keys and use the mouse to look around.

---


### **Phase 4: Troubleshooting (If You Get Stuck)**

**❌ Scripts don’t work?**
- Double-check you put each script in the right place (see Phase 2)
- Make sure you deleted the default code in each script
- Check the Output window (View → Output) for red error messages

**❌ Map doesn’t appear?**
- Look for a part called `BasePlatform` in Workspace
- If it’s missing, check that GameManager is in ServerScriptService

**❌ UI doesn’t show up?**
- Make sure GameClient is a LocalScript in StarterPlayerScripts
- Check for errors in Output

**❌ Game doesn’t start?**
- Make sure QuickStart is set to true in GameConfig
- You need at least 2 players for the game to start

**Still stuck?**
- Try deleting and re-adding the script
- Ask for help on the [DevForum](https://devforum.roblox.com/)

---


### **Phase 5: Get Ready to Publish Your Game**

#### **Step 12: Turn Off Debug Settings for Real Players**
When you’re happy with your game, open `GameConfig` and change this section:
```lua
GameConfig.Debug = {
    Enabled = false,        -- No debug messages
    ShowPlayerPositions = false,
    QuickStart = false,     -- Wait for real players
    ShowMapGeneration = false
}
```

#### **Step 13: Set Game Info and Access**
1. Click **File** → **Game Settings**
2. Fill in:
   - **Name:** Ghost Tagging Game
   - **Description:** Hide from the ghost or tag all players to win!
   - **Max Players:** 10 (or your preferred number)
3. Click the **Permissions** tab
4. Set to **Public** when you want everyone to play, or **Private** for testing

#### **Step 14: Final Testing**
1. Set `QuickStart = false` in GameConfig
2. Click **Play** and make sure the game waits for enough players
3. Play through a full game to check everything works

---


### **Phase 6: Publish and Share Your Game!**

#### **Step 15: Publish to Roblox**
1. Click **File** → **Publish to Roblox**
2. The first time, this creates your game on the Roblox website
3. Next times, it updates your game
4. Go to the Roblox website, find your game, and add a thumbnail and description

#### **Step 16: Share and Improve**
- Invite friends to play and test
- Watch for feedback and bugs
- Update your scripts in Studio and re-publish as needed

---


## 🎮 Game Configuration Reference (For Beginners)


### **Key Settings You Can Adjust:**

| Setting | Default | Description |
|---------|---------|-------------|
| `MinPlayers` | 2 | Minimum players to start |
| `MaxPlayers` | 10 | Maximum server capacity |
| `PreparationTime` | 30s | Ghost lockdown duration |
| `GameTime` | 300s | Main game duration |
| `TagDistance` | 10 | How close to tag players |
| `MapSize` | 200 | Size of generated map |


### **Tips for Balancing the Game:**
- **Too easy for ghost?** Decrease `TagDistance` or `GameTime`
- **Too hard for players?** Increase hiding spots or `PreparationTime`
- **Games too long?** Reduce `GameTime`
- **Not enough players joining?** Lower `MinPlayers`

---


## 🔧 Advanced Customization (Optional)

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


## ✅ Deployment Checklist (For Beginners)


**Before Publishing:**
- [ ] Did you put each script in the right place? (see Phase 2)
- [ ] Did you test with 2 or more players?
- [ ] Did you turn off debug mode for real players? (`Enabled = false`)
- [ ] Did you set the game name, description, and max players?
- [ ] Did you play a full game to check win/lose?
- [ ] Does the UI look good on your screen?
- [ ] Are there no red errors in the Output window?

**After Publishing:**
- [ ] Can you find your game on the Roblox website?
- [ ] Did you add a thumbnail and description?
- [ ] Can your friends join and play?
- [ ] Are you watching for any live issues?
- [ ] Are you collecting feedback for improvements?

---


---

*Last Updated: June 2025*
*Game Version: 1.0*
