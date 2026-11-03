# Development notes

## Design principles

- Keep UI rendering separate from feature implementation.
- Keep settings in `Config.lua`.
- Keep tab and control declarations in `FeatureCatalog.lua`.
- Keep lifecycle and reusable UI logic in `BapruHub.lua` and the support modules under `Core/` and `UI/`.
- Keep the bootstrap script minimal.
- Preserve the reference feature names as catalog entries without implementing exploit functionality.
- Keep the official project name as Bapru Hub throughout the codebase and documentation.

## Adding a UI-only setting

Add an item to a category in `FeatureCatalog.lua`:

```lua
{ Id = "my_preference", Name = "My preference", Kind = "toggle", Default = false }
```

Supported control kinds in this scaffold:
- `label`
- `toggle`
- `slider`

## Connecting callbacks

Use the returned `BapruHub` object and its `SetValue` / `GetValue` methods. Extend the framework with an explicit callback registration method when you add legitimate functionality for an experience you own.

## Input and cleanup

The framework stores global input and viewport connections and disconnects them in `Destroy()`. If you add new event connections, add them to `self.Connections` so closing the UI does not leave orphaned listeners.
