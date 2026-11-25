# Make mise tools available even in non-interactive zsh sessions.
_mise_shims="${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}/shims"
case ":$PATH:" in
  *":$_mise_shims:"*) ;;
  *) export PATH="$_mise_shims${PATH:+:$PATH}" ;;
esac
unset _mise_shims
