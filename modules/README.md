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
  ### Instructions
  Copy the line below, paste it into your executor, and run it. This will load the latest version of the module.
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
  ### Instructions
  Copy the line below, paste it into your executor, and run it. This will load the latest version of the module.
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
  ### Instructions
  Copy the line below, paste it into your executor, and run it. This will load the latest version of the module.
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/Auto-Wasp.lua"))()
```
</details>
<details>
  <summary>Module 4 "Auto-Find Easter Bunny Reward"</summary>

  This module contains one toggle that will automatically teleport to eggs that are created by the Easter Bunny pet. This will collect it for rewards.

  If there are no eggs, then it will wait until the Easter Bunny performs its ability, and teleport to the egg upon creation.

  Beware that if the egg spawns inside a large plant, the script may be unable to reach it unless an external no-clip feature is enabled.

  All executors are able to run this script.
  ### Instructions
  Copy the line below, paste it into your executor, and run it. This will load the latest version of the module.
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/Auto-Find-Easter-Bunny-Reward.lua"))()
```
</details>
<details>
  <summary>Module 5 "Auto-Robbery"</summary>

  This module was created upon special request; it is not for Grow a Garden. It contains a feature for a [different game](https://www.roblox.com/games/2418863943/Roanoke-VA-Driving-RP).

  It simply teleports to points of interests, and fires a proximity prompt to collect cash.
  ### Instructions
  Copy the line below, paste it into your executor, and run it. This will load the latest version of the module.
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/2418863943.lua"))()
```

</details>
<details>
  <summary>Module 6 "Prompt Purchase"</summary>

  This module contains a searchable dropdown menu that contains all products that are purchasable with Robux. It includes items from previous events that may have been removed, but are still purchasable.

  To use it, select or search for an item, then press "Buy." It will first attempt to purchase with tokens; if tokens are unavailable, then Robux will be used instead.

  There also is the option to send an item as a gift to another player in the server; only items that have a giftable counterpart can be selected. Choose the non-gift version from the product list, and select the player. Then, press the `Send Gift` button. 

  Purchasing with tokens is unavailable for executors that are unable to use `require()`. This includes Xeno and Solara.

  Also, many executors disable using Robux to purchase items, which can cause errors if tokens are not available. Please reach out to your executor developers to find out how to re-enable Robux purchasing. The source code is publicly viewable, so there is no need for concern about safety.
  
  This module uses the [Maclib UI library](https://brady-xyz.gitbook.io/maclib-ui-library), as the Starlight UI does not support searchable dropdown menus, which absolutely was necessary, given that over 1.2k products exist.
  ### Instructions
  Copy the line below, paste it into your executor, and run it. This will load the latest version of the module.
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/modules/Prompt-Purchase.lua"))()
```

</details>

<hr style="height:2px;border-width:0;color:gray;background-color:gray">

> If you need any help, join the Discord server: https://discord.gg/9NyRdmfTgp

[Back to main README](../README.md)

## Credits
The UI library is the [Starlight Interface Suite](https://docs.nebulasoftworks.xyz/starlight), which is developed by [Nebula Softworks](https://github.com/Nebula-Softworks).
