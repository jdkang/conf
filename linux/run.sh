#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# oh my zsh
if [ ! -d ~/.oh-my-zsh  
then
    sh -c "$(wget --no-check-certificate https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi
# powerlevel10k theme
if [ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]
then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# conf files
cp $SCRIPT_DIR/.tmux.conf ~/.tmux.conf
cp $SCRIPT_DIR/.vimrc ~/.vimrc
cp $SCRIPT_DIR/.zshrc ~/.zshrc

# reload zsh
exec zsh
