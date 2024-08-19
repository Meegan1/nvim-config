# NVim Configuration

This project includes configuration files for Neovim and VSCode-Neovim.

## Requirements

- [] Neovim Remote (`brew install neovim-remote`)

## Installation

1. Install Neovim v0.9.5:

MacOS (See <https://github.com/vscode-neovim/vscode-neovim/issues/2000#issuecomment-2145473728>):

```bash
brew uninstall neovim
wget https://raw.githubusercontent.com/Homebrew/homebrew-core/63aa44faba5b5274a1a7579510cd5a570a2cca5f/Formula/n/neovim.rb
brew install -s neovim.rb
```

2. Clone this repository to your home directory:

```bash
git clone git@github.com:Meegan1/nvim-config.git ~/.config/nvim
```

3. Copy the keybindings.json file to vscode keybindings (workbench.action.openGlobalKeybindingsFile)
