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

# enable dircolors
export CLICOLOR=1
test -r $HOME/.dircolors && eval "$(gdircolors $HOME/.dircolors)"

# fancy cat
export BAT_THEME=gruvbox-dark
alias cat=bat

alias grep=rg
alias vim=nvim
alias less=/opt/homebrew/Cellar/less/661/bin/less

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

# load pure prompt
autoload -U promptinit; promptinit
prompt pure

export MOB_TIMER_ROOM=team-tardigrades-42
export MOB_OPEN_COMMAND="idea %s"

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

# Load Angular CLI autocompletion.
source <(ng completion script)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/A19D46E/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/A19D46E/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/A19D46E/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/A19D46E/tools/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(atuin init zsh --disable-up-arrow)"

# go
export PATH="$HOME/go/bin/:$PATH"

# opencode
export PATH=/Users/A19D46E/.opencode/bin:$PATH
export PATH="/Users/A19D46E/.local/bin:$PATH"
