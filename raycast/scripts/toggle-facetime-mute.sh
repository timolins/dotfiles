#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle FaceTime Mute
# @raycast.mode compact
# @raycast.packageName FaceTime
# @raycast.description Toggles mute for the active FaceTime call.

set -u

if ! pgrep -x FaceTime >/dev/null 2>&1; then
  printf 'FaceTime is not running.\n' >&2
  exit 1
fi

# Reports the state the call is left in. Older releases keep a checked "Mute"
# item; newer ones may retitle it "Unmute" while muted.
state=$(osascript <<'APPLESCRIPT'
on run
  tell application "System Events" to tell process "FaceTime"
    set videoMenu to menu 1 of menu bar item "Video" of menu bar 1
    set muteItem to missing value
    set wasMuted to false
    repeat with itemName in {"Mute", "Unmute"}
      try
        set candidate to menu item (itemName as text) of videoMenu
        if enabled of candidate then
          set muteItem to candidate
          if (itemName as text) is "Unmute" then
            set wasMuted to true
          else
            set mark to value of attribute "AXMenuItemMarkChar" of candidate
            set wasMuted to (mark is not missing value and mark is not "")
          end if
          exit repeat
        end if
      end try
    end repeat
    if muteItem is missing value then error "FaceTime mute is unavailable"
    click muteItem
    if wasMuted then return "unmuted"
    return "muted"
  end tell
end run
APPLESCRIPT
) || exit 1

case "$state" in
  muted) printf 'FaceTime muted\n' ;;
  unmuted) printf 'FaceTime unmuted\n' ;;
  *) printf 'FaceTime mute toggled\n' ;;
esac
