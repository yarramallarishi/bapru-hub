-- This catalog preserves recognizable feature categories from the reference project
-- as informational UI entries only. Each entry is intentionally inert until you
-- connect it to legitimate functionality in a Roblox experience you own.

return {
    {
        Name = "Dashboard",
        Icon = "⌂",
        Description = "Player and session overview",
        Items = {
            { Id = "session_status", Name = "Session status", Kind = "label", Default = "Ready" },
            { Id = "show_notifications", Name = "Desktop notifications", Kind = "toggle", Default = true },
            { Id = "anti_afk", Name = "Anti-AFK", Kind = "toggle", Default = false },
            { Id = "server_hop_timer", Name = "Server-hop timer", Kind = "slider", Min = 10, Max = 180, Default = 45 },
        },
    },
    {
        Name = "Gameplay",
        Icon = "⚔",
        Description = "Reference feature catalogue preserved for UI organization",
        Items = {
            { Id = "auto_dragon_talon", Name = "Auto Dragon Talon", Kind = "toggle", Default = false },
            { Id = "auto_godhuman", Name = "Auto Godhuman", Kind = "toggle", Default = false },
            { Id = "auto_store_fruits", Name = "Auto Store Fruits", Kind = "toggle", Default = false },
            { Id = "auto_equip_best_gear", Name = "Auto Equip Best Gear", Kind = "toggle", Default = false },
            { Id = "auto_join_crew", Name = "Auto Join Crew", Kind = "toggle", Default = false },
            { Id = "auto_server_boost", Name = "Auto Server Boost", Kind = "toggle", Default = false },
            { Id = "auto_elite_pirates", Name = "Auto Elite Pirates", Kind = "toggle", Default = false },
            { Id = "auto_cursed_dual_katana", Name = "Auto Cursed Dual Katana", Kind = "toggle", Default = false },
            { Id = "auto_sharkman_karate", Name = "Auto Sharkman Karate", Kind = "toggle", Default = false },
            { Id = "auto_dark_step", Name = "Auto Dark Step", Kind = "toggle", Default = false },
            { Id = "auto_buy_boats", Name = "Auto Buy Boats", Kind = "toggle", Default = false },
            { Id = "auto_spin_fruit", Name = "Auto Spin Fruit", Kind = "toggle", Default = false },
            { Id = "auto_detect_rare_spawns", Name = "Auto Detect Rare Spawns", Kind = "toggle", Default = false },
            { Id = "auto_optimize_inventory", Name = "Auto Optimize Inventory", Kind = "toggle", Default = false },
            { Id = "auto_trade_optimizer", Name = "Auto Trade Optimizer", Kind = "toggle", Default = false },
            { Id = "auto_mirage_puzzles", Name = "Auto Mirage Puzzles", Kind = "toggle", Default = false },
            { Id = "auto_sea_beast", Name = "Auto Sea Beast", Kind = "toggle", Default = false },
        },
    },
    {
        Name = "Visuals",
        Icon = "◈",
        Description = "Client-side presentation preferences",
        Items = {
            { Id = "visual_indicators", Name = "Visual indicators", Kind = "toggle", Default = false },
            { Id = "visual_intensity", Name = "Visual intensity", Kind = "slider", Min = 0, Max = 100, Default = 65 },
        },
    },
    {
        Name = "Utilities",
        Icon = "✦",
        Description = "General interface utilities",
        Items = {
            { Id = "compact_mode", Name = "Compact mode", Kind = "toggle", Default = false },
            { Id = "ui_scale", Name = "UI scale", Kind = "slider", Min = 75, Max = 125, Default = 100 },
            { Id = "cleanup_on_close", Name = "Cleanup on close", Kind = "toggle", Default = true },
        },
    },
    {
        Name = "Progress",
        Icon = "▤",
        Description = "Progress and checklist panels",
        Items = {
            { Id = "show_progress_panel", Name = "Show progress panel", Kind = "toggle", Default = true },
            { Id = "progress_goal", Name = "Progress goal", Kind = "slider", Min = 0, Max = 100, Default = 55 },
        },
    },
    {
        Name = "Settings",
        Icon = "⚙",
        Description = "Application preferences",
        Items = {
            { Id = "reduce_motion", Name = "Reduce motion", Kind = "toggle", Default = false },
            { Id = "show_debug_log", Name = "Show debug log", Kind = "toggle", Default = false },
            { Id = "reset_window_position", Name = "Reset window position", Kind = "button", Default = "Reset" },
        },
    },
}
