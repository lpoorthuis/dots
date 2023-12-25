#############
# zsh setup #
#############

fpath+=($HOME/.zsh/pure)

# load pure prompt
autoload -U promptinit; promptinit
prompt pure

# configure autocompletion
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle :compinstall filename '/home/lpoorth/.zshrc'

autoload -Uz compinit
compinit

# history settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

#############
# ESSENTIAL #
#############

# auth for bigtable and kubectl
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# needed when building latex container locally
alias golinux=""

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


###############
# FANCY STUFF #
###############

### application overwrites ###

# fancy cat
export BAT_THEME=OneHalfLight # (good with solarized light theme)
alias cat=bat

alias vim=nvim

# kube cluster name in prompt (also add kube-ps1 to plugins)
#PROMPT='$(kube_ps1)'$PROMPT

# fancy git log
alias gitb="git log --graph --decorate --oneline"

# fancy autocompletion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# homebrew autocompletion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

####################
# ESSENTIAL FOOTER #
####################

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# pnpm
export PNPM_HOME="/Users/A19D46E/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# bun completions
[ -s "/Users/A19D46E/.bun/_bun" ] && source "/Users/A19D46E/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)
