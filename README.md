# Bapru Hub

A modular Roblox client-side UI framework and project scaffold inspired by the reference hub concept, reworked as a clean Bapru Hub implementation.

> This repository contains interface infrastructure and benign client-side utilities. It does not include executor APIs, game-specific exploit automation, remote abuse, automated combat/farming, or anti-cheat bypasses.

## Features

- Dark, responsive Bapru Hub interface
- Purple welcome panel with player profile, session status, and feature search
- Sidebar navigation and searchable feature catalog
- Reusable buttons, toggles, sliders, labels, and notifications
- Central configuration defaults
- Lifecycle cleanup and respawn-aware UI mounting
- Lightweight logging and error reporting
- Modular source layout

## Install in Roblox Studio

1. Create a new `ScreenGui`-based LocalScript project or open an existing place.
2. Put `src/BapruHub.lua` in a `ModuleScript` named `BapruHub` under `ReplicatedStorage`.
3. Put `src/Bootstrap.client.lua` in `StarterPlayer > StarterPlayerScripts`.
4. Put `src/Config.lua` in a `ModuleScript` named `Config` under the same parent as `BapruHub`.
5. Put `src/FeatureCatalog.lua` in a `ModuleScript` named `FeatureCatalog` under the same parent as `BapruHub`.
6. If you want the modular layout, also copy the `Core`, `Features`, and `UI` folders into the same `ReplicatedStorage` parent as `BapruHub`.
7. Update the `require` paths in `Bootstrap.client.lua` if you use a different hierarchy.

## Project layout

```text
bapru-hub/
├── README.md
├── LICENSE
├── .gitignore
├── version.txt
├── src/
│   ├── Bootstrap.client.lua
│   ├── BapruHub.lua
│   ├── Config.lua
│   ├── FeatureCatalog.lua
│   ├── Core/
│   │   ├── Cleanup.lua
│   │   ├── ErrorHandler.lua
│   │   ├── StateManager.lua
│   │   └── TaskManager.lua
│   ├── Features/
│   │   ├── Dashboard.lua
│   │   ├── FeatureModules.lua
│   │   └── Inventory.lua
│   └── UI/
│       ├── Components.lua
│       ├── Notifications.lua
│       └── Theme.lua
└── docs/
    └── DEVELOPMENT.md
```

This keeps the reference project’s overall layout and feature naming while separating UI, state, cleanup, and feature metadata into safer, easier-to-maintain modules and finalizing the Bapru Hub identity.

## Publishing

Upload the repository contents to your GitHub repository `yarramallarishi/bapru-hub`.
The main module's Raw URL will follow this pattern:

`https://raw.githubusercontent.com/yarramallarishi/bapru-hub/main/src/BapruHub.lua`

For normal Roblox Studio projects, use ModuleScripts and `require`. Do not use executor-only `loadstring(game:HttpGet(...))()` loaders.
