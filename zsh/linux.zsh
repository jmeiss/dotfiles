# Linux (devcontainers). install.sh puts claude and rtk in ~/.local/bin.
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || export PATH="$HOME/.local/bin:$PATH"

# A devcontainer mounts exactly one Claude profile as ~/.claude.
alias cce='claude'
