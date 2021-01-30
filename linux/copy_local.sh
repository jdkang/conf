#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cp $SCRIPT_DIR/.tmux.conf ~/.tmux.conf
cp $SCRIPT_DIR/.vimrc ~/.vimrc

if [ ! -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
	git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
	cat <<EOF >> ~/.bashrc
# git prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
EOF
fi
