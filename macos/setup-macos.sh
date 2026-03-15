#!/bin/bash

# Dock: show only open apps
defaults write com.apple.dock static-only -bool true
# Dock: minimize windows into app icon
defaults write com.apple.dock minimize-to-application -bool true
# Dock: zero delay auto-hide
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
# Dock: wipe default pinned apps
defaults write com.apple.dock persistent-apps -array

# Finder: column view by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Finder: search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Finder: show ~/Library
chflags nohidden ~/Library

# Hot corners: bottom-left = sleep display, bottom-right = show desktop
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

killall Dock
killall Finder

echo "macOS defaults applied!"
