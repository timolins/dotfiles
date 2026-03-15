#!/bin/bash

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing packages..."
brew bundle --file="$(dirname "$0")/Brewfile"

cd "$(dirname "$0")"
stow */

echo "Linking Tailscale CLI..."
ln -sf /Applications/Tailscale.app/Contents/MacOS/Tailscale /usr/local/bin/tailscale

echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

echo "Applying macOS defaults..."
./macos/setup-macos.sh

echo "Done!"
