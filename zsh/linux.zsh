# Linux (devcontainers). install.sh puts claude and rtk in ~/.local/bin.
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || export PATH="$HOME/.local/bin:$PATH"
