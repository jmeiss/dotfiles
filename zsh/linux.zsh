# Linux (devcontainers). install.sh puts claude and rtk in ~/.local/bin.
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || export PATH="$HOME/.local/bin:$PATH"

# Node (nvm), for ccstatusline.
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# A devcontainer mounts exactly one Claude profile as ~/.claude.
alias cce='claude'
