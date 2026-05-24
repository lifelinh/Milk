# Modules
This folder is a collection of open-source "mini-scripts" containing a subset of Milk's features.

When Grow a Garden updates, some of the features designed for the previous event may be removed, due to the event ending. Code for these features may also be uploaded to this collection. 

Features that were planned to be implemented, but scrapped, may also be added as well.

This is kept open-source for educational purposes; others are welcome to use the available material in any way to improve their own scripts or programming skills!
## Collection
<details>
  <summary>Module 1 "Auto-Craft"</summary>

  This module contains toggles and dropdown menus for selecting a recipe and repeatedly crafting it. No user action besides configuring the dropdown options and toggling the feature is required, as it is fully automatic. Users are still able to craft the Anti Bee Egg and the Pack Bee with the feature, despite them being removed after the Bizzy Bees 2026 update.

  It also is possible to set pet loadout slot numbers if the user has pets that assist with any crafting stages. The script will automatically switch to these loadouts during the process.

  The cycle involves setting the recipe, submitting the necessary items, starting crafting, then waiting until crafting is finished before claiming the item.

  If the player does not have crafting ingredients available, the feature will restart and continue trying until the recipe can be crafted.

  This module will not work on some executors, as it uses `require()` to access a function that submits items for crafting. If you are running one of the unsupported executors, a notification will appear when the feature is toggled, and crafting will not start.
  ### Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/Auto-Craft.lua"))()
```
</details>
<details>
  <summary>Module 2 "Auto-Incubate"</summary>

  This module contains one toggle, which automatically uses the Incubator introduced in the Bizzy Bees 2026 event.

  The feature will automatically submit one seed to the incubator, pay the required Honey Coins, collect the seed once the incubation period is over, then repeats. It will continue repeating until you are no longer holding a seed.

  The user must hold a seed to select it as the seed that will be automatically incubated.

  This module will work on all executors.
  ### Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/Auto-Incubate.lua"))()
```
</details>
<details>
  <summary>Module 3 "Auto-Wasp"</summary>

  This module contains one toggle that will automatically teleport to wasp eggs, and wait until they are killed by the player's bees, before teleporting to the next wasp egg.

  If there are no wasps active, then it will wait until a wasp egg is added, then teleport to it to fight the wasps.

  Rewards from chests are automatically collected by the game after the chests despawn.

  All executors are able to run this script.
  ### Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/Auto-Wasp.lua"))()
```
</details>

<hr style="height:2px;border-width:0;color:gray;background-color:gray">

> If you need any help, join the Discord server: https://discord.gg/9NyRdmfTgp

[Back to main README](../README.md)

## Credits
The UI library is the [Starlight Interface Suite](https://docs.nebulasoftworks.xyz/starlight), which is developed by [Nebula Softworks](https://github.com/Nebula-Softworks).