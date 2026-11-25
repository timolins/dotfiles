# dotfiles

Run setup from an interactive macOS terminal so Homebrew and the optional Tailscale CLI link can prompt for your admin password:

```bash
git clone https://github.com/timolins/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
```

Setup uses the current checkout without pulling updates. It installs the Brewfile apps and CLI tools, links the Fish, Ghostty, Git, mise, and zsh configs without adopting existing files, installs mise tools (including Claude Code), and applies the macOS defaults. If Stow reports an existing config, move it aside or merge it before retrying.

## mise tools in shells

Fish activates mise directly. For zsh, `~/.zshenv` adds mise’s shims to `PATH`, so tools such as Node are also available to non-interactive `zsh -c` commands. To link just the zsh config from this checkout, run `stow --target="$HOME" zsh`. This does not change `PATH` for apps that launch commands without starting zsh or Fish.

## English QWERTZ keyboard

Setup copies the custom bundle into your user `~/Library/Keyboard Layouts` directory instead of symlinking it with Stow. It migrates old keyboard links that point to this checkout and leaves other layouts alone. It does not change your active input source.

1. After installation, log out of macOS and back in so it discovers the layout.
2. Open **System Settings → Keyboard → Text Input → Edit → +** and search for **English QWERTZ**.
3. Add it, then select it from the input menu. If you used **English Quertz** before, add the renamed layout again: macOS treats it as a different input source.

To install just the keyboard (without rerunning setup), run `bash ~/.dotfiles/macos/install-keyboard.sh`. If it reports that a different copy of the bundle already exists, move that bundle out of `~/Library/Keyboard Layouts`, retry, and log out and back in.

## Raycast dictation

In **Raycast Settings → Extensions → Script Commands**, add `~/.dotfiles/raycast/scripts` as a script directory. Run **Toggle Dictation** twice to check that it starts and stops Superwhisper. Assign a hotkey in Raycast if you want one.

**Toggle Dictation** tries to mute FaceTime when dictation starts and restores mute when it stops, but only if it muted the call itself. If prompted, allow Raycast Accessibility and Automation access to System Events. The script uses FaceTime’s English **Video → Mute** menu and Superwhisper’s timestamped recording folders; it skips muting if it can’t identify the recording state or read FaceTime’s mute state. Set `SUPERWHISPER_RECORDINGS_DIR` in Raycast’s environment if its configured folder can’t be detected.

Test on a call where you can safely check the mute indicator. Use the same Raycast command to start and stop. If you end dictation another way, or the call changes mid-dictation, check FaceTime’s mute state manually.
