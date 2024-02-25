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
export BAT_THEME=gruvbox-dark
alias cat=bat

alias vim=nvim

# fancy ls
alias ls="ls --color=always"
alias ll="ls -lisa"
eval $(dircolors ~/.dir_colors/bliss.dircolors)

# fancy ctrl r
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --select-1 --exit-0"

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

