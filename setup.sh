#!/bin/bash
set -e

cd "$(dirname "$0")"

if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Please re-run this script after installation completes."
  exit 1
fi

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing packages..."
brew bundle --file="$PWD/Brewfile"

echo "Linking dotfiles..."
stow --target="$HOME" fish ghostty git mise

bash ./macos/install-keyboard.sh

echo "Installing mise tools..."
mise install

tailscale_cli=/Applications/Tailscale.app/Contents/MacOS/Tailscale
tailscale_link=/usr/local/bin/tailscale
if [ -e "$tailscale_link" ] || [ -L "$tailscale_link" ]; then
  echo "Leaving existing $tailscale_link in place."
elif [ -x "$tailscale_cli" ]; then
  echo "Linking Tailscale CLI..."
  sudo mkdir -p "$(dirname "$tailscale_link")"
  sudo ln -s "$tailscale_cli" "$tailscale_link"
else
  echo "Tailscale CLI not found at $tailscale_cli; skipping link." >&2
fi

echo "Applying macOS defaults..."
./macos/setup-macos.sh

echo "Done!"
