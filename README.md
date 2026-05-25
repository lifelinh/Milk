# Milk
Milk is a script with several automation features for Grow a Garden. It is entirely free and keyless!

<a href="https://github.com/the-amazing-digital-circus/Milk">
  <img 
    src="https://github.com/user-attachments/assets/75c3a14b-e163-4ab0-8d7b-5563647992a0" 
    width="996"
  />
</a>

Grow a Garden updates weekly, and I am committed to keep up with their pacing! I will do my best to keep this script valid for every event or update they release.
## Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/126884695634066"))()
```

## Supported Environments
* Delta
* Madium
* Seliware
* Opiumware
* MacSploit

## Partially Supported Environments
<details>
  <summary>Xeno</summary>

  Auto-Farm will run at a reduced speed if not using the Hyperspeed mode.
</details>
<details>
  <summary>Solara</summary>

  Auto-Farm will run at a reduced speed if not using the Hyperspeed mode.
</details>

## Untested Environments
* Volt
* Velocity
* Potassium
* Wave
* SynapseZ
* SirHurt
* Isaeva
* Volcano
* VegaX
* Codex
* Cryptic

## Features

<details>
  <summary>Automation</summary>

  * __Auto-Farm:__ Choose between different modes for different goals; automatically collects and sells plants based on what you need to do. There are extra options for setting pet loadout slots to automatically do the Magpie method.
  * __Auto-Incubate:__ This feature will exist until the seed incubators are removed; they will repeatedly submit the currently held seed to the incubator, and automatically claim when the process is complete.
  * __Plant All Held Seeds:__ This button will plant all of the currently equipped seed in the same spot, which is the center tile of the left plot half.
  * __Auto-Craft:__ Choose between a dropdown menu to select a recipe, and enable the feature to automatically craft and claim it, given that the resources are available to afford the recipe. This also allows crafting removed recipes from previous events. Automatic pet switching is enabled if the user sets loadout slot numbers in the options.
  * __Auto-Kill Wasps:__ Teleports to active Wasps, when they spawn, to fight them. Rewards are automatically collected.
  * __Auto-Open Cosmetic Crates:__ Automatically opens and places cosmetic crates after opening them, until the user no longer has crates in their inventory. This requires that crates be placed first.
  * __Auto-Claim Season Pass Points:__ This only works when the user has completed Tier 50 of the current Season Pass; it will automatically claim the infinite Season Pass points rewards whenever it is claimable.
  * __Auto-Find Easter Bunny Egg:__ Automatically collects eggs that are created by the Easter Bunny pet.
</details>

<details>
  <summary>Eggs & Pets</summary>

  * __Auto-Apply Pet Boosts:__ Works for small and medium pet toys and treats, and also works for pet leads. Every minute, reapplies toys and treats to active pets. For pet leads, it will reapply every 10 seconds.
  * __Auto-Hatch:__ Automatically hatches and replaces the egg specified by the user, as long as the egg exists in the inventory. Also allows for automatic switching between pet loadout slots that boost hatch speed (while waiting) or increases egg luck (when hatching).
  * __Auto-Sell:__ Automatically sells specified pets, if the pets are found in the user's inventory. This allows for setting a weight threshold to avoid selling pets that are matched but over a certain weight. There also is an option to enter a loadout slot that contains Seals to automatically switch to when selling, for a chance to have eggs refunded.
</details>

<details>
  <summary>Shops</summary>

  - __Auto-Buy:__ Some shops have dropdown menus to select items to automatically buy when they are stocked. This does NOT use any stock APIs, and relies on GUI states; meaning that client-sided stocks provided by the user's pets or other restocking tools can be purchased. Options without dropdown menus will simply buy anything from that shop whenever available.
  - __Instant Buy:__ Immediately buys all currently stocked items in the selected shop.
</details>

<details>
  <summary>Player</summary>

  - __Physics:__ Set a custom walk speed, jump power, or disable collisions with world objects, fly, or use infinite jump.
  - __Teleports:__ Teleport to various important locations in the world, without the need of teleportation tools.
</details>

<details>
  <summary>Settings</summary>

  - __Disable 3D Rendering:__ This unrenders the world, which can cut CPU usage by 50%. It only visually removes 3D rendering; all other features are unaffected by the status of this setting.
  - __Hide GUIs:__ This removes all UI elements that are currently active. This cannot be restored, and rejoining the game is required to "undo" this option. Ideal for reducing screen burn if expecting to stay in game for long periods.
  - __Rejoin Game:__ A button that rejoins the server and attempts to load the script again upon rejoining.
  - __Configurations:__ Options to save the states of features, so that they can be loaded quickly in the future. Also allows for setting a configuration to automatically load when the script is ran.
</details>
<details>
  <summary>Built-in</summary>

  - __Anti-Idle:__ The user will not be kicked for idling while the script is active.
  - __Auto-Rejoin:__ The client will attempt to automatically reconnect to the game if the user is disconnected for any reason.
  - __Execute on Join:__ If using the Rejoin Game button, when automatically rejoined by the client, or if teleporting to other places within the game (from or to trade world), the client will attempt to load the script after connecting, if it was previously active.
</details>

<hr style="height:2px;border-width:0;color:gray;background-color:gray">

> If you need any help, join the Discord server: https://discord.gg/9NyRdmfTgp
## Credits
The UI library is the [Starlight Interface Suite](https://docs.nebulasoftworks.xyz/starlight), which is developed by [Nebula Softworks](https://github.com/Nebula-Softworks).

## Mini Versions

See [`/modules`](./modules) for open-source, lightweight, standalone scripts that contain fewer features.

## Privacy Policy

Last updated: 22 May 2026

Milk collects limited analytics data in order to monitor usage, improve stability, and better understand how the software is used. This script is a personal, non-commercial project and is not operated as a registered business.

### Information Collected

The following information may be collected when the script is used:

* A hashed version of a username used as a unique identifier for analytics purposes
* Country-level geographic information derived from Cloudflare request headers
* Usage timestamps
* Executor & environment information
* Game identifiers
* Aggregate usage statistics and execution counts

Usernames are hashed before storage and are not kept in plaintext. Scripts located in [`/modules`](./modules) do not collect or transmit any data.

### Information Not Collected

This script does not intentionally collect or store:

* Raw IP addresses
* Passwords
* Email addresses
* Payment information
* Private messages or chat content
* Personally identifying real-world information
* Digital items in possession

### Purpose of Data Collection

Collected information is used solely for purposes such as:

* Analytics and usage statistics
* Monitoring software reliability and performance
* Detecting duplicate executions and program misuse
* Improving compatibility and stability
* Understanding regional and demographic usage trends

### Third-Party Services

This script uses the below third-party infrastructure providers to process requests, store data, and perform analysis.

* [Supabase](https://supabase.com)
* [Cloudflare](https://www.cloudflare.com)
* [Metabase](https://www.metabase.com)
* [GitHub](https://docs.github.com/en/site-policy/privacy-policies)

These providers may process technical request information as part of normal operation.

### Data Retention

Analytics data is retained for operational, analytical, and debugging purposes. Data retention periods may change over time as development evolves.

### Data Sharing

Collected data is not sold to third parties. Aggregate or anonymized statistics are only used internally for analytics or development purposes.

### Security

Reasonable efforts are made to limit collected data and store it securely. However, no method of electronic storage or transmission is guaranteed to be completely secure.

### Changes to This Policy

This Privacy Policy may be updated periodically. Continued use of the software after changes are made constitutes acceptance of the updated policy.

### Contact

If you have questions regarding this Privacy Policy, you may contact the owner of the project through the [Discord server](https://discord.gg/9NyRdmfTgp).
