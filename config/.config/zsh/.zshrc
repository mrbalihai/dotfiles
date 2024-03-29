fpath=($DOTFILES/zsh/plugins $fpath)

setopt AUTO_CD # Go to folder path without using cd.
setopt AUTO_PUSHD # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.

setopt CORRECT # Spelling correction
setopt CDABLE_VARS # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB # Use extended globbing syntax.

setopt EXTENDED_HISTORY # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS # Do not display a previously found event.
setopt HIST_IGNORE_SPACE # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS # Do not write a duplicate event to the history file.
setopt HIST_VERIFY # Do not execute immediately upon history expansion.

bindkey -v
export KEYTIMEOUT=1

_comp_options+=(globdots) # With hidden files

source ${ZSH_PLUGINS}/completion.zsh
source ${ZSH_PLUGINS}/fzf_completion.zsh
source ${ZSH_PLUGINS}/fzf_key_bindings.zsh
source ${ZSH_PLUGINS}/cursor_mode.zsh
source ${ZSH_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ${ZSH_PLUGINS}/prompt.zsh

autoload -U compinit; compinit
autoload -Uz cursor_mode; cursor_mode

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install plugin managers && plugins for tmux if they don't exist
[ ! -d "${TMUX_PLUGIN_MANAGER_PATH}/tpm" ] && \
    git clone https://github.com/tmux-plugins/tpm ${TMUX_PLUGIN_MANAGER_PATH}/tpm && \
    ${TMUX_PLUGIN_MANAGER_PATH}/tpm/bin/install_plugins

source ~/.config/zsh/secrets.zsh

alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"
alias tmux="tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf"

if command -v tmux >/dev/null 2>&1; then
    # if not inside a tmux session, and if no session is started, start a new session
    [ -z "${TMUX}" ] && (tmux attach || tmux) >/dev/null 2>&1
fi
