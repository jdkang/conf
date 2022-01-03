#!/bin/bash

fontDir="$HOME/.local/share/fonts"
tmpDir=`mktemp -d`
mkdir $tmpDir/ttf

if ! command -v fc-list &>/dev/null ; then
    >&2 echo "fc-list not found"
    exit 1
fi

# firacode NF
echo "checking firacode nf"
if ! grep -qi "FiraCode NF" <(fc-list) ; then
    echo "downloading latest zip"
    curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
    | grep -i "browser_download_url.*FiraCode\.zip" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -q -i - -O $tmpDir/FiraCode.zip

    echo "unpacking"
    unzip -q $tmpDir/FiraCode.zip -d $tmpDir/ttf
else
    echo "  already installed"
fi

# install fonts
if [ $(find $tmpDir/ttf -maxdepth 1 -name '*.ttf' | wc -l) != '0' ] ; then
    if [ ! -d $fontDir ] ; then
        echo "creating local font dir"
        mkdir -p $fontDir
    fi
    
    echo "copying fonts"
    cp $tmpDir/ttf/*.ttf $fontDir

    echo "refreshing font cache"
    fc-cache -f
else
    echo "nothing to install"
fi


