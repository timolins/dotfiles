#!/bin/bash
set -e

cd "$(dirname "$0")/.."
source_dir="$PWD/keyboard/Library/Keyboard Layouts"
layout_dir="$HOME/Library/Keyboard Layouts"
bundle='English QUERTZ.bundle'
source_bundle="$source_dir/$bundle"
installed_bundle="$layout_dir/$bundle"

# Install directly so macOS can discover the bundle after login.
# Only remove old links that point to this checkout.
if [ -L "$layout_dir" ] && [ "$layout_dir" -ef "$source_dir" ]; then
  unlink "$layout_dir"
fi
if [ -L "$layout_dir" ]; then
  echo "Skipping English QWERTZ: $layout_dir is a symlink to another location." >&2
  exit 0
fi
mkdir -p "$layout_dir"

if [ -L "$installed_bundle" ] && [ "$installed_bundle" -ef "$source_bundle" ]; then
  unlink "$installed_bundle"
fi
if [ -e "$installed_bundle" ] || [ -L "$installed_bundle" ]; then
  if [ ! -L "$installed_bundle" ] && [ -d "$installed_bundle" ] && diff -qr "$source_bundle" "$installed_bundle" >/dev/null; then
    echo 'English QWERTZ is already installed.'
  else
    echo "Skipping English QWERTZ: $installed_bundle already exists and differs. Move it aside and rerun to update." >&2
  fi
  exit 0
fi

/usr/bin/ditto "$source_bundle" "$installed_bundle"
echo 'Installed English QWERTZ. Log out and back in, then add it in System Settings → Keyboard → Text Input → Edit → +.'
