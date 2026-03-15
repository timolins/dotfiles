#!/bin/bash

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v stow &>/dev/null; then
  echo "Installing stow..."
  brew install stow
fi

if ! command -v fish &>/dev/null; then
  echo "Installing fish..."
  brew install fish
fi

cd "$(dirname "$0")"
stow */

echo "Done!"
