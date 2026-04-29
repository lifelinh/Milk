# Chiffon
The Chiffon modules are a collection of open-source "mini-scripts" containing features that were originally intended to be added to Milk, but were scrapped. These may not be finished products, and not all modules may work on all executors.

When Grow a Garden updates, some of the features designed for the previous event may be removed, due to the event ending. Code for these features may also be uploaded to the Chiffon module collection.

This is kept open-source for educational purposes and utility; it is others are welcome to use the available material in any way to improve their own scripts or programming skills!
## Collection
<details>
  <summary>Module 1 "Auto-Craft"</summary>

  This module contains toggles and dropdown menus for selecting a recipe and repeatedly crafting it. No user action besides configuring the dropdown options and toggling the feature is required, as it is fully automatic.

  The cycle involves setting the recipe, submitting the necessary items, starting crafting, then waiting until crafting is finished before claiming the item.

  If the player does not have crafting ingredients available, the feature will restart and continue trying until the recipe can be crafted.
  ### Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Milk/refs/heads/main/Chiffon/Auto-Craft"))()
```
</details>
<hr style="height:2px;border-width:0;color:gray;background-color:gray">

> If you need any help, join the Discord server: https://discord.gg/Dt79RuG4N3
## Credits
The UI library is the [Starlight Interface Suite](https://docs.nebulasoftworks.xyz/starlight), which is developed by [Nebula Softworks](https://github.com/Nebula-Softworks).