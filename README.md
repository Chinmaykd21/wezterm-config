# WezTerm Configuration (macOS)

A high-productivity terminal setup for macOS featuring automated project workspaces, 4-pane split layouts, and directory-aware automation.

## ✨ Features

- **Project Picker (`Cmd + P`)**: Fuzzy search and jump into project workspaces instantly.
- **Automated Layouts**: Selecting a project automatically splits the window into a 4-pane quadrant.
- **Custom Pane Commands**: Define specific scripts (e.g., dev servers, linters, watchers) to run automatically upon opening a project.
- **Theming**: Deeply integrated with Catppuccin Mocha and Meslo Nerd Font.

## 🛠 Prerequisites

Before installing, ensure you have the following on your Mac:

1. **Homebrew**: The easiest way to manage dependencies.
2. **Search Utility (`fd`)**: Required for the project picker to scan directories.
   ```bash
   brew install fd
   ```
3. **Nerd Font**: This config uses `MesloLGS Nerd Font Mono` for icons and glyphs.
   - [Download MesloLGS NF here](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)

## 🚀 Installation

1. **Install WezTerm**:
   ```bash
   brew install --cask wezterm
   ```

2. **Clone this repository** to the standard XDG configuration path:
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git ~/.config/wezterm
   ```

3. **Launch WezTerm**. On the first run, it will automatically download the necessary plugins.

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Cmd + P` | Open Project Picker / Workspace Switcher |
| `Cmd + D` | Split Pane Right |
| `Cmd + Shift + D` | Split Pane Down |

## ⚙️ Customizing Projects

To add your own automated 4-pane project, edit the `project_configs` table in `wezterm.lua`. 

The key should match the name of your project folder. You can define custom commands for each of the 4 quadrants (Top-Left, Top-Right, Bottom-Left, Bottom-Right):

```lua
local project_configs = {
    ["your-project-folder-name"] = {
        scheme = "Catppuccin Mocha",
        panes = {
            { cwd = ".", cmd = "npm run dev" },      -- Pane 1
            { cwd = ".", cmd = "npm run lint" },     -- Pane 2
            { cwd = ".", cmd = "git status" },       -- Pane 3
            { cwd = "../sibling-dir", cmd = "ls" }   -- Pane 4 (Supports relative paths)
        }
    }
}
```

## 📝 License
MIT
