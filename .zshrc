export PATH=${HOME}/.local/bin:/usr/local/bin:${HOME}/Workspace/esp-open-sdk/xtensa-lx106-elf/bin:${PATH}
export ZSH="${HOME}/.oh-my-zsh"

[ ! -d "${ZSH}" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_THEME="robbyrussell"
plugins=(git fzf aws zsh-completions)

source $ZSH/oh-my-zsh.sh
source $HOME/.oh-my-zsh/custom/plugins/fzf-tab-completion/zsh/fzf-zsh-completion.sh

complete -C '/usr/bin/aws_completer' aws
zstyle ':completion:*:*:aws' fzf-search-display true

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install plugin managers for vim and tmux
[ ! -d "${HOME}/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
[ ! -f "${HOME}/.vim/autoload/plug.vim" ] && \
    curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    vim +PlugInstall +qall

# WSL Specific
[[ "$(uname -a)" != *"microsoft"* ]] exit 0
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1
