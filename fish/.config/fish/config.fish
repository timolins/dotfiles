/opt/homebrew/bin/brew shellenv | source
fish_add_path ~/.local/bin

set -gx PNPM_HOME "$HOME/Library/pnpm"
# pnpm checks PATH before creating its global bin directory.
contains -- "$PNPM_HOME/bin" $PATH; or set -gx PATH "$PNPM_HOME/bin" $PATH
fish_add_path "$PNPM_HOME"

mise activate fish | source
zoxide init fish --cmd y | source

fish_add_path ~/.bun/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# set -gx ANTHROPIC_BASE_URL "https://ai-gateway.vercel.sh"
# set -gx ANTHROPIC_API_KEY ""
# set -l anthropic_auth_token (security find-generic-password -a "$USER" -s "ANTHROPIC_AUTH_TOKEN" -w 2>/dev/null)
# if test -n "$anthropic_auth_token"
#     set -gx ANTHROPIC_AUTH_TOKEN $anthropic_auth_token
# end

# Prefer binaries from the nearest node_modules/.bin.
source ~/.config/fish/conf.d/local_node_bin.fish
