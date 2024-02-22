# [Sphere - A PalServer plugin](https://www.curseforge.com/palworld/lua-code-mods/sphere)
Sphere is an open-source server-oriented plugin written in Lua for Palworld. It empowers game administrators with commands, such as summoning pals, distributing item kits, and opening up exciting possibilities for the future!

## Setup
To ensure a smooth development experience, follow these steps to set up your environment:

### 1. Install Visual Studio Code Extension
The `Luahelper` extension for Visual Studio Code is essential for efficient development:
- Open VS Code and press `Ctrl+Shift+X` to open the Extensions view.
- Search for `yinfei.luahelper` and install the extension.

### 2. Generate Lua Types
To access Palworld classes and types, generate Lua type information:
   1. Open your PalServer and the UE4SS Debugging Tools will show.
   2. In the header, navigate to `Dumpers > Generate Lua types`.
   3. Now you should find countless files in the `shared/types` folder.

### 3. Configure Visual Studio Code
Ignore unnecessary errors in VS Code to your workflow:
   1. Press `Ctrl+,` to open VS Code settings.
   2. Search for `@ext:yinfei.luahelper`.
   3. Locate `Ignore File or Dir Error`.
   4. Add a new item with the text `"shared/types/"`.

## Contributing
Contributions to the Sphere Project are always welcome! 🚀

## Special Thanks
I would like to extend special thanks to the members of the [UE4SS](https://discord.com/invite/7qhRGHF9Tt) Discord server who generously shared their knowledge and helped answer my questions, making this project possible.

This project was inspired by the [aytimothy](https://github.com/aytimothy/PalworldEssentials/), where i found motivation to start my own project.
