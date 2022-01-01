#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# oh my zsh
sh -c "$(wget --no-check-certificate https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# conf files
cp $SCRIPT_DIR/.tmux.conf ~/.tmux.conf
cp $SCRIPT_DIR/.vimrc ~/.vimrc
cp $SCRIPT_DIR/.zshrc ~/.zshrc

