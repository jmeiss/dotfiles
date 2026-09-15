# macOS only. Homebrew is initialised in ~/.zprofile.

# Rails better_errors: open stack-trace links in VS Code.
export BETTER_ERRORS_EDITOR=vscode

export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"  # takes precedence: `java` resolves here today

# Node (nvm)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Ruby (RVM). Last, so its PATH entry stays last.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Claude Code config profiles
alias cce='CLAUDE_CONFIG_DIR=$HOME/.claude-ergana claude'
alias ccp='CLAUDE_CONFIG_DIR=$HOME/.claude claude'
