#############
# ESSENTIAL #
#############

# auth for bigtable and kubectl
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export GOOGLE_CLOUD_LOCATION=europe-west1
export GOOGLE_CLOUD_PROJECT=rd-pickachu-prod792-dev

# needed when building latex container locally
alias golinux=""


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
for _brew_zsh_site_functions in /opt/homebrew/share/zsh/site-functions /usr/local/share/zsh/site-functions; do
  [[ -d "$_brew_zsh_site_functions" ]] && FPATH="$_brew_zsh_site_functions:${FPATH}"
done
unset _brew_zsh_site_functions

autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-${ZSH_VERSION}"
mkdir -p "${_zcompdump:h}"
if [[ -n $_zcompdump(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
if [[ -s "$_zcompdump" && ( ! -s "${_zcompdump}.zwc" || "$_zcompdump" -nt "${_zcompdump}.zwc" ) ]]; then
  zcompile "$_zcompdump"
fi
unset _zcompdump

# load pure prompt
autoload -U promptinit; promptinit
prompt pure

# Set Ghostty tab title to current directory name only (basename)
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  _ghostty_hook_title() {
    # Redefine to: report CWD via OSC 7 (for dir inheritance) + set title via OSC 2 (basename only)
    _ghostty_report_pwd() {
      builtin print -nu $_ghostty_fd '\e]7;kitty-shell-cwd://'"$HOST""$PWD"'\a'
      builtin print -nu $_ghostty_fd '\e]2;'"${PWD:t}"'\a'
    }
    # Only need to patch once, then remove this hook
    precmd_functions=(${precmd_functions:#_ghostty_hook_title})
  }
  precmd_functions+=(_ghostty_hook_title)
fi

export MOB_TIMER_ROOM=team-tardigrades-42
export MOB_OPEN_COMMAND="idea %s"

####################
# ESSENTIAL FOOTER #
####################

export SDKMAN_DIR="$HOME/.sdkman"
_sdkman_lazy_load() {
  unset -f sdk _sdkman_lazy_load
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}
sdk() { _sdkman_lazy_load; sdk "$@"; }

# pnpm
export PNPM_HOME="/Users/A19D46E/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load Angular CLI autocompletion from a cache file.
if command -v ng >/dev/null 2>&1; then
  _ng_bin="$(command -v ng)"
  _ng_completion_cache="${HOME}/.cache/ng-completion.zsh"
  mkdir -p "${HOME}/.cache"
  if [ ! -r "$_ng_completion_cache" ] || [ "$_ng_bin" -nt "$_ng_completion_cache" ]; then
    ng completion script > "$_ng_completion_cache" 2>/dev/null
  fi
  [ -r "$_ng_completion_cache" ] && source "$_ng_completion_cache"
  unset _ng_bin _ng_completion_cache
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/A19D46E/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/A19D46E/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/A19D46E/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/A19D46E/tools/google-cloud-sdk/completion.zsh.inc'; fi

# fancy history
eval "$(atuin init zsh --disable-up-arrow)"

# dir related conv

# go
export PATH="$HOME/go/bin/:$PATH"

# git agent commit
export PATH="$HOME/workspace/lpoorth/git-agent/bin:$PATH"

# opencode
export PATH=/Users/A19D46E/.opencode/bin:$PATH
export PATH="/Users/A19D46E/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
 [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun completions
[ -s "/Users/A19D46E/.bun/_bun" ] && source "/Users/A19D46E/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
eval "$(direnv hook zsh)"

# Set MCPORTER_CONFIG based on current directory under rewe-digital-fulfillment
_mcporter_chpwd() {
  local config_base="$HOME/.mcporter"
  local ffp_base="$HOME/workspace/rewe-digital-fulfillment"
  if [[ "$PWD" == "$ffp_base"/* ]]; then
    if [[ "$PWD" == *frontend* ]]; then
      export MCPORTER_CONFIG="$config_base/mcporter_frontend.json"
      echo "mcporter: config set to frontend"
    else
      export MCPORTER_CONFIG="$config_base/mcporter_ffp.json"
      echo "mcporter: config set to default"
    fi
  elif [[ -n "$MCPORTER_CONFIG" ]]; then
    unset MCPORTER_CONFIG
    echo "mcporter: config unloaded"
  fi
}
# guard against duplicate registration on re-source
if (( ! ${chpwd_functions[(Ie)_mcporter_chpwd]} )); then
  chpwd_functions+=(_mcporter_chpwd)
fi
_mcporter_chpwd  # run once for the initial directory
