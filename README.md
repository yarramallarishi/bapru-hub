# Bapru Hub

A modular Roblox client-side UI framework and project scaffold using the QuantumHub concept as a visual and organizational reference.

> This repository contains interface infrastructure and benign client-side utilities. It does not include executor APIs, game-specific exploit automation, remote abuse, automated combat/farming, or anti-cheat bypasses.

## Features

- Dark, responsive QuantumHub-inspired interface
- Sidebar navigation and searchable feature catalog
- Reusable buttons, toggles, sliders, labels, and notifications
- Central configuration defaults
- Lifecycle cleanup and respawn-aware UI mounting
- Lightweight logging and error reporting
- Modular source layout

## Install in Roblox Studio

1. Create a new `ScreenGui`-based LocalScript project or open an existing place.
2. Put `src/QuantumHub.lua` in a `ModuleScript` named `QuantumHub` under `ReplicatedStorage`.
3. Put `src/Bootstrap.client.lua` in `StarterPlayer > StarterPlayerScripts`.
4. Put `src/Config.lua` in a `ModuleScript` named `Config` under the same parent as `QuantumHub`.
5. Put `src/FeatureCatalog.lua` in a `ModuleScript` named `FeatureCatalog` under the same parent as `QuantumHub`.
6. Update the `require` paths in `Bootstrap.client.lua` if you use a different hierarchy.

## Project layout

```text
bapru-hub/
├── README.md
├── LICENSE
├── .gitignore
├── version.txt
├── src/
│   ├── Bootstrap.client.lua
│   ├── QuantumHub.lua
│   ├── Config.lua
│   └── FeatureCatalog.lua
└── docs/
    └── DEVELOPMENT.md
```

## Publishing

Upload the repository contents to your GitHub repository `yarramallarishi/bapru-hub`.
The main module's Raw URL will follow this pattern:

`https://raw.githubusercontent.com/yarramallarishi/bapru-hub/main/src/QuantumHub.lua`

For normal Roblox Studio projects, use ModuleScripts and `require`. Do not use executor-only `loadstring(game:HttpGet(...))()` loaders.
