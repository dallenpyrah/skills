export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm; command node "$@"; }
npm() { nvm; command npm "$@"; }
npx() { nvm; command npx "$@"; }

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export GPG_TTY=${GPG_TTY:-$(tty)}
export OPENCODE_MESSAGE_QUEUE_MODE=hold
export OPENCODE_EXPERIMENTAL_PLAN_MODE=true

source "$(dirname "${(%):-%x}")/aliases.zsh"
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh
