# -- Path --
export PATH="$HOME/.local/bin:$PATH"

# -- NVM (lazy load) --
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

# -- SDKMAN --
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# -- GPG --
export GPG_TTY=${GPG_TTY:-$(tty)}

# -- Source aliases --
source "$(dirname "${(%):-%x}")/aliases.zsh"
