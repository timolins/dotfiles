#!/bin/bash
set -e

cd "$(dirname "$0")"

if [ -z "$SETUP_RESTARTED" ]; then
  if git pull 2>/dev/null | grep -q "Updating"; then
    echo "Updated dotfiles, restarting setup..."
    SETUP_RESTARTED=1 exec "$0"
  fi
fi

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
brew bundle --file="$(dirname "$0")/Brewfile"

stow --adopt */

echo "Installing runtimes..."
mise install

echo "Linking Tailscale CLI..."
sudo ln -sf /Applications/Tailscale.app/Contents/MacOS/Tailscale /usr/local/bin/tailscale

echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

echo "Applying macOS defaults..."
./macos/setup-macos.sh

echo "Done!"
