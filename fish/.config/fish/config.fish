/opt/homebrew/bin/brew shellenv | source
fish_add_path ~/.local/bin
fish_add_path ~/Library/pnpm

mise activate fish | source
zoxide init fish --cmd y | source

set -gx AI_GATEWAY_API_KEY (security find-generic-password -a "$USER" -s "AI_GATEWAY_API_KEY" -w)
set -gx OPENCODE_API_KEY (security find-generic-password -a "$USER" -s "OPENCODE_API_KEY" -w)
