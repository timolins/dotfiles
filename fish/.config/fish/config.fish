/opt/homebrew/bin/brew shellenv | source
fish_add_path ~/.local/bin

fish_add_path ~/Library/pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"

mise activate fish | source
zoxide init fish --cmd y | source

fish_add_path $PNPM_HOME
fish_add_path ~/.bun/bin

mise activate fish | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# set -gx ANTHROPIC_BASE_URL "https://ai-gateway.vercel.sh"
# set -gx ANTHROPIC_API_KEY ""
# set -l anthropic_auth_token (security find-generic-password -a "$USER" -s "ANTHROPIC_AUTH_TOKEN" -w 2>/dev/null)
# if test -n "$anthropic_auth_token"
#     set -gx ANTHROPIC_AUTH_TOKEN $anthropic_auth_token
# end
