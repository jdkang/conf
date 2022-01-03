# setup oh-my-posh
$ompFolder = Join-Path $HOME 'AppData\Local\Programs\oh-my-posh'
$ompBinPath = Join-Path $ompFolder 'bin/oh-my-posh.exe'
if(-not (Test-Path -Path $ompBinPath)) {
    $ompExeDownloadUrl = ""
    $ghLatestReleaseFmt = 'https://api.github.com/repos/{0}/releases/latest'
    $ompGhLatestReleaseUri = $ghLatestReleaseFmt -f 'JanDeDobbeleer/oh-my-posh'
    $ompGhLatestReleaseResult = Invoke-RestMethod -Uri $ompGhLatestReleaseUri
    $ompAssets = @($ompGhLatestReleaseResult.assets)
    if($ompAssets.Count -eq 0) {
        $assetName = 'install-amd64.exe'
        $ompInstallerAsset = $ompAssets | sort-object -property 'id' -descending | where-object { $_.name -eq $assetName } | select -first 1
        if($ompInstallerAsset.browser_download_url) {
            $tempFolder = [System.IO.Path]::GetTempPath()
            $tempFile = Join-Path $tempFolder $assetName
            write-host "downloading oh-my-posh installer $($ompInstallerAsset.browser_download_url)" -f green
            Invoke-RestMethod -Uri $ompInstallerAsset.browser_download_url -OutFile $tempFile
            write-host "installing" -f green
            & $tempFile /VERYSILENT
            Get-ChildItem -Path $ompFolder
        } else {
            write-warning "cannot find oh-my-posh installer asset: $($ompGhLatestReleaseUri)"
        }
    } else {
        write-warning "cannot locate oh-my-posh latest assets: $($ompGhLatestReleaseUri)"
    }
} else {
    write-host "oh-my-posh already installed" -f yellow
}

# add oh-my-posh to profile
if ((gc $PROFILE -Raw) -notmatch 'oh-my-posh') {
  Add-Content -Path $PROFILE -Value @'

# oh my posh
$ompFolder = Join-Path $HOME 'AppData\Local\Programs\oh-my-posh'
if(Test-Path -Path $ompFolder) {
  $ompThemePath = Join-Path $ompFolder 'themes/powerlevel10k_rainbow.omp.json'
  $ompBinPath = Join-Path $ompFolder 'bin/oh-my-posh.exe'
  & $ompBinPath --init --shell pwsh --config $ompThemePath | Invoke-Expression
}
'@
} else {
    write-host "profile alreayd setup for oh-my-posh" -f yellow
}