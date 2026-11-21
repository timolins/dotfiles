# dotfiles

Run setup from an interactive macOS terminal so Homebrew and the optional Tailscale CLI link can prompt for your admin password:

```bash
git clone https://github.com/timolins/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
```

Setup uses the current checkout without pulling updates. It installs the Brewfile apps and CLI tools, links the Fish, Ghostty, Git, and mise configs without adopting existing files, installs mise tools (including Claude Code), and applies the macOS defaults. If Stow reports an existing config, move it aside or merge it before retrying.

## English QWERTZ keyboard

Setup copies the custom bundle into your user `~/Library/Keyboard Layouts` directory instead of symlinking it with Stow. It migrates old keyboard links that point to this checkout and leaves other layouts alone. It does not change your active input source.

1. After installation, log out of macOS and back in so it discovers the layout.
2. Open **System Settings → Keyboard → Text Input → Edit → +** and search for **English QWERTZ**.
3. Add it, then select it from the input menu. If you used **English Quertz** before, add the renamed layout again: macOS treats it as a different input source.

To install just the keyboard (without rerunning setup), run `bash ~/.dotfiles/macos/install-keyboard.sh`. If it reports that a different copy of the bundle already exists, move that bundle out of `~/Library/Keyboard Layouts`, retry, and log out and back in.
