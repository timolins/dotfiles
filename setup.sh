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

echo "Applying macOS defaults..."
./macos/setup-macos.sh

echo "Done!"
