#!/bin/bash


font_zip_name="${1:-FiraCode}"
tmpDir=`mktemp -d`
tempFontDir="${tmpDir}/fonts"

userFontDir="$HOME/.local/share/fonts"
if [[ $(uname) == 'Darwin' ]]; then
    userFontDir="$HOME/Library/Fonts"
fi

# ensure font cache command
if ! command -v fc-list &>/dev/null ; then
    >&2 echo "fc-list not found"
    exit 1
fi

# temp dir
mkdir $tempFontDir

# download font
download_url=""
zip_regex="browser_download_url.*${font_zip_name}\.zip"
latestAsset=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest)
assetMatch=$(grep -Ei $zip_regex <<< $latestAsset)
local_zip_file="${tmpDir}/${font_zip_name}.zip"
if [[ ! -z $assetMatch ]] ; then
    download_url=$( echo $assetMatch | cut -d : -f 2,3 | tr -d \" )
    echo "downloading ${download_url}"
    wget -q -O $local_zip_file $download_url
    echo "unpacking ${local_zip_file}"
    unzip -q $local_zip_file -d $tempFontDir
fi

# install fonts
if [[ $(find $tempFontDir -maxdepth 1 -name '*.ttf' | wc -l) != '0' ]] ; then
    if [ ! -d $userFontDir ] ; then
        echo "creating local font dir ${userFontDir}"
        mkdir -p $userFontDir
    fi
    
    echo "copying fonts to ${userFontDir}"
    cp -f $tempFontDir/*.ttf $userFontDir

    echo "refreshing font cache"
    fc-cache -f
else
    echo "nothing to install"
fi

# cleanup
if [[ -d $tmpDir ]] ; then
    echo "cleaning up temp dir ${tmpDir}"
    rm -rf $tmpDir
fi
