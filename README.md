# what this?
initial setup scripts for linux and windows shells/termianls. Includes my personal pref confs.

## fonts
The default "with fonts" is `FiraCode Nerd Font`. You can change the font installed by passing the basename of the `.zip` asset as per [Nerd Font Github Releases](https://github.com/ryanoasis/nerd-fonts/releases) -- e.g. `FiraCode`, `Hack`, `CascadiaCode`, etc. It will always pull the latest release.

# linux
- zsh
- oh-my-zsh
- powerline10k customization
- tmux customization
- vim customization
- initial zshrc

## without fonts
```
rm -rf /tmp/jdkconf/ && git clone --depth 1 https://github.com/jdkang/conf.git /tmp/jdkconf && bash /tmp/jdkconf/linux/run.sh
```

## with fonts
```
rm -rf /tmp/jdkconf/ && git clone --depth 1 https://github.com/jdkang/conf.git /tmp/jdkconf && bash /tmp/jdkconf/linux/run.sh && bash /tmp/jdkconf/linux/fonts.sh
```

# windows
IMO Windows Termianl is better than ConEmu long-term but is unreliably installable esp for windows server.

includes:
- oh-my-posh installation (installer has some prompting)
- powerline10k-like customization
- cmder mini + customization

## without fonts
```
rm -recurse -force -ea 0 -path "${ENV:TEMP}\jdkconf" ; git clone --depth 1 https://github.com/jdkang/conf.git "${ENV:TEMP}\jdkconf" ; & "${ENV:TEMP}\jdkconf\windows\run.ps1"
```

## with fonts
```
rm -recurse -force -ea 0 -path "${ENV:TEMP}\jdkconf" ; git clone --depth 1 https://github.com/jdkang/conf.git "${ENV:TEMP}\jdkconf" ; & "${ENV:TEMP}\jdkconf\windows\run.ps1" ; & "${ENV:TEMP}\jdkconf\windows\fonts.ps1"
```