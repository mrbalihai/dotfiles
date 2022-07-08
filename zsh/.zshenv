export PATH=${HOME}/.local/bin:/usr/local/bin:/usr/local/opt/libpq/bin:${PATH}

export EDITOR="nvim"
export VISUAL="nvim"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${XDG_CONFIG_HOME}/local/share"
export XDG_CACHE_HOME="${XDG_CONFIG_HOME}/cache"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZSH_PLUGINS="${ZDOTDIR}/plugins"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_CONFIG_HOME}/tmux/plugins"

export HISTFILE="${ZDOTDIR}/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
export RUSTUP_HOME="${XDG_CONFIG_HOME}/rustup"
export CARGO_HOME="${XDG_CONFIG_HOME}/cargo"
source "${CARGO_HOME}/env"
