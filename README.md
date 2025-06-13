Overview
This is a 2D pixel-style RPG game created as part of the DI32009 coursework. The game features classic role-playing mechanics including exploration, combat, dialogue with NPCs, inventory management, and enemy AI systems. Players take on the role of a hero tasked with uncovering secrets, solving environmental puzzles, and defeating enemies to protect their village.

Core Features
Real-time combat system with melee attacks and AI-controlled enemies.
Inventory and equipment management with drag-and-drop functionality.
NPC dialogue system that guides story progression and quest objectives.
Encrypted save and load system using Godot’s secure config files.
Dynamic enemy behavior (patrolling, chasing, fleeing) via a behavior tree AI model.
Navigation and auto-pathfinding using NavigationAgent2D.
Visual layering with Y-sorting for realistic depth perception.
Multi-scene level transitions and clue-based puzzle solving.

How to Play
WASD / Arrow keys – Move the player
C – Interact with NPCs / Continue dialogue
Left Mouse Button – Attack enemies
I – Open inventory
Drag items to equipment slots to equip gear
Defeat enemies or avoid them based on strategy
Explore, solve clues, and reach the goal

Save & Load
You can open the menu and click Save to securely store your current game state (encrypted). Click Continue Game on the main menu to load the latest save file.

Completion Criteria
Reach the final level and defeat all enemies

Collect hidden treasure chests
Solve storyline puzzles through NPC dialogues
Demonstrate all core systems working as intended

Project Structure
scenes/: Game scenes (worlds, menu, player, enemy, NPCs)
scripts/: GDScript files for player, AI, UI, and system logic
assets/: Art assets (sprites, tilesets, audio)
save/: Local encrypted save files

Reference & Assets
Art Assets Used:
Kenney. (n.d.). Cute Fantasy Characters - 16x16 Top-Down Pixel Art Asset Pack. itch.io.
Available at: https://kenmi-art.itch.io/cute-fantasy-characters-16x16-top-down-pixel-art-asset-pack [Accessed 13 Jun 2025].

Devworm, n.d. RPG Art in Godot 4 [online]. itch.io. Available at: https://devworm.itch.io/rpg-art-in-godot-4 [Accessed 16 May 2025].
 
Kenney, 2025. Tiny Town [online]. Kenney.nl. Available at: 
https://kenney.nl/assets/tiny-town [Accessed 16 May 2025].
License: Creative Commons CC0.
 
Kenney, 2025. Roguelike RPG Pack [online]. Kenney.nl. Available at: https://kenney.nl/assets/roguelike-rpg-pack [Accessed 16 May 2025]. License: Creative Commons CC0.
 
Kenney, n.d. Tiny Dungeon [online]. Kenney.nl. Available at: https://kenney.nl/assets/tiny-dungeon [Accessed 16 May 2025].
License: Creative Commons CC0.

Segel (2023) *Adventurer and Slime game Sprites*. OpenGameArt.org. Available at: https://opengameart.org/content/adventurer-and-slime-game-sprites (Accessed: 13 June 2023).
License: Creative Commons CC0.

IndigoFenix (2018) *NPC Dancers*. OpenGameArt.org. Available at: https://opengameart.org/content/npc-dancers
(Accessed: 25 August 2018). Licensed under: CC0.
