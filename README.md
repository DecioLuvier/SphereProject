# [Sphere - A PalServer plugin](https://www.curseforge.com/palworld/lua-code-mods/sphere)
Sphere is an open-source server-oriented plugin written in Lua for Palworld. It empowers game administrators with commands, such as summoning pals, distributing item kits, and opening up exciting possibilities for the future!

## Setup for Pull requests
To enhance your Lua development experience and align it with the standards of the GitHub repository, follow these steps to configure your environment:

### Install Visual Studio Code Emmylua Extension
   1. Make sure you have JDK 17 or higher.
   2. Open VS Code and press `Ctrl+Shift+X` to open the Extensions view.
   3. Search for `tangzx.emmylua` and install.

### Configure Visual Studio Code
   1. Press `Ctrl+,` to open VS Code settings.
   2. Search for `@ext:tangzx.emmylua`.
   3. Locate `ParameterValidation`.
   4. Enable it.

### Generate Palworld classes and lua types
   1. Open your PalServer and the UE4SS Debugging Tools will show.
   2. In the header, navigate to `Dumpers > Generate Lua types`.
   3. Now you should find countless files in the `shared/types` folder.
   4. Get the Ue4ss [types](https://github.com/UE4SS-RE/RE-UE4SS/blob/b29b40f79ccc08da1e264a85907446da51934d97/assets/Mods/shared/Types.lua#L4) and put in the same folder

# PalGuard Compatibility
   1. Open the [palguard](https://github.com/BloodDragon2580/Palguard/) github
   2. You should download the Linux-Wine-Proton version(Even if you are on Windows)
   3. Install normally by following the tutorial on the repository
   4. Support his creator on their [discord](https://discord.gg/palguard)!
   5. And now yes, you can just drop all Sphere files into the mods folder

# Special Thanks
I would like to extend special thanks to the members of the [UE4SS](https://discord.com/invite/7qhRGHF9Tt) Discord server who generously shared their knowledge and helped answer my questions, making this project possible.

This project was inspired by the [aytimothy](https://github.com/aytimothy/PalworldEssentials/), where i found motivation to start my own project.
