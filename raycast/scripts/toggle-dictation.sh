#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle Dictation
# @raycast.mode silent
# @raycast.packageName Superwhisper
# @raycast.description Toggles Superwhisper dictation and manages FaceTime mute.

set -u

umask 077
state_dir="$HOME/Library/Caches/raycast-dictation"
mkdir -p "$state_dir" || exit 1
marker="$state_dir/facetime-muted"
lock="$state_dir/lock"
mkdir "$lock" 2>/dev/null || exit 1
trap 'rmdir "$lock"' EXIT

# Superwhisper stores recordings under a selectable parent folder.
parent=$(defaults read com.superduper.superwhisper appFolderDirectory 2>/dev/null) || parent="$HOME/Documents"
recordings="${SUPERWHISPER_RECORDINGS_DIR:-$parent/superwhisper/recordings}"

# Exit 0 for recording, 1 for idle, 2 if the on-disk format is unrecognized.
recording_state() {
  local path name latest=0 now
  for path in "$recordings"/*; do
    [ -d "$path" ] || continue
    name=${path##*/}
    case "$name" in *[!0-9]*) continue ;; esac
    [ "${#name}" -eq 10 ] || continue
    if [ "$name" -gt "$latest" ]; then latest=$name; fi
  done
  [ "$latest" -gt 0 ] || return 2
  [ ! -f "$recordings/$latest/meta.json" ] || return 1
  now=$(date +%s) || return 2
  [ "$latest" -le "$now" ] && [ "$((now - latest))" -lt 3600 ] || return 2
  printf '%s\n' "$latest"
}

facetime_mute() {
  osascript - "$1" <<'APPLESCRIPT'
on run argv
  set actionName to item 1 of argv
  tell application "System Events" to tell process "FaceTime"
    set muteItem to menu item "Mute" of menu 1 of menu bar item "Video" of menu bar 1
    if not enabled of muteItem then error "FaceTime mute is unavailable"
    set mark to value of attribute "AXMenuItemMarkChar" of muteItem
    if mark is missing value or mark is "" then
      if actionName is not "mute" then return "unmuted"
      click muteItem
      -- The click can succeed before FaceTime refreshes its checkmark.
      -- Restore reads the live mute state before deciding whether to click.
      return "mute-clicked"
    else if mark is "✓" then
      if actionName is "restore" then click muteItem
      return "muted"
    end if
    error "Unknown FaceTime mute state"
  end tell
end run
APPLESCRIPT
}

recording_state >/dev/null
recording_status=$?
pid=$(pgrep -x FaceTime 2>/dev/null) || pid=''
restore() {
  [ -n "$pid" ] && [ "$(pgrep -x FaceTime 2>/dev/null)" = "$pid" ] || return 1
  facetime_mute restore >/dev/null
}

if [ "$recording_status" -eq 0 ]; then
  open -g 'superwhisper://record' || exit 1
  if [ -f "$marker" ] && [ "$(<"$marker")" = "$pid" ]; then
    sleep 0.3
    restore && rm -f "$marker"
  fi
elif [ -f "$marker" ]; then
  # Recording may have ended outside Raycast. Never unmute an unknown call.
  rm -f "$marker"
  printf 'Dictation state changed outside Raycast; check FaceTime mute manually.\n' >&2
  open -g 'superwhisper://record'
else
  if [ "$recording_status" -eq 1 ] && [ -n "$pid" ]; then
    if [ "$(facetime_mute mute 2>/dev/null)" = mute-clicked ]; then
      if ! printf '%s\n' "$pid" > "$marker"; then
        restore || :
      fi
    fi
  fi
  if ! open -g 'superwhisper://record'; then
    if [ -f "$marker" ]; then restore && rm -f "$marker"; fi
    exit 1
  fi
fi
