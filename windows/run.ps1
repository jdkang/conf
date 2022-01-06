
function Get-LatestGithubArtifact {
param(
    [Parameter(Mandatory=$True)]
    [ValidateScript({ $_ -match '\w+\/\w+' })]
    [ValidateNotNullOrEmpty()]
    [string]
    $OrgRepo,

    [regex]
    $AssetRegex
)
    $ghLatestReleaseFmt = 'https://api.github.com/repos/{0}/releases/latest'
    $ghLatestUrl = $ghLatestReleaseFmt -f $OrgRepo
    $ghLatestReleaseResult = Invoke-RestMethod -Uri $ghLatestUrl
    $assets = @($ghLatestReleaseResult.assets)
    if($assets.Count -gt 0) {
        $asset = $assets |
                 sort-object -property 'id' -descending |
                 where-object { $_.name -match $AssetRegex } |
                 select-object -first 1
        if($asset.browser_download_url) {
            return $asset
        } else {
            throw "cannot find assetg matching regex: $($AssetRegex)"
        }
    } else {
        throw "cannot find latest gh release for: $($OrgRepo)"
    }
}


# setup oh-my-posh
$ompFolder = Join-Path $HOME 'AppData\Local\Programs\oh-my-posh'
$ompBinPath = Join-Path $ompFolder 'bin/oh-my-posh.exe'
if(-not (Test-Path -Path $ompBinPath)) {
    $latestOmpAsset = Get-LatestGithubArtifact -OrgRepo 'JanDeDobbeleer/oh-my-posh' -AssetRegex '^install-amd64\.exe$'
    if($latestOmpAsset.browser_download_url) {
        $tempFolder = [System.IO.Path]::GetTempPath()
        $tempFile = Join-Path $tempFolder 'installer_amd64.exe'
        write-host "downloading oh-my-posh installer $($ompInstallerAsset.browser_download_url)" -f green
        Invoke-RestMethod -Uri $latestOmpAsset.browser_download_url -OutFile $tempFile
        write-host "installing" -f green
        & $tempFile /VERYSILENT
    } else {
        write-warning "cannot locate oh-my-posh latest assets: $($ompGhLatestReleaseUri)"
    }
} else {
    write-host "oh-my-posh already installed" -f yellow
}

# copy custom profile\
$customProfileSrc = Join-Path $PsScriptRoot 'powerlevel10k_rainbow.omp-no-brackets.json'
$customProfileTarget = Join-Path $Home 'powerlevel10k_rainbow.omp-no-brackets.json'
Copy-item -Path $customProfileSrc -Destination $customProfileTarget -Force

# add oh-my-posh to profile
if ((gc $PROFILE -Raw) -notmatch 'oh-my-posh') {
  Add-Content -Path $PROFILE -Value @'

# oh my posh
$ompFolder = Join-Path $Home 'AppData\Local\Programs\oh-my-posh'
$ompBinPath = Join-Path $ompFolder 'bin/oh-my-posh.exe'
$ompThemePath = Join-Path $Home 'powerlevel10k_rainbow.omp-no-brackets.json'
if(-not (Test-Path -Path $ompThemePath)) {
    $ompThemePath = Join-Path $ompFolder 'themes/powerlevel10k_rainbow.omp.json'
}
if((Test-Path -Path $ompBinPath) -and (Test-Path -Path $ompThemePath)) {  
  & $ompBinPath --init --shell pwsh --config $ompThemePath | Invoke-Expression
}
'@
} else {
    write-host "profile alreayd setup for oh-my-posh" -f yellow
}

# cmder mini
$cmderFolder = Join-Path $HOME 'cmder'
$cmderBinPath = Join-Path $cmderFolder 'Cmder.exe'
if(-not (Test-Path -Path $cmderBinPath)) {
    $latestCmderMiniAsset = Get-LatestGithubArtifact -OrgRepo 'cmderdev/cmder' -AssetRegex '^cmder_mini\.zip$'
    if($latestCmderMiniAsset.browser_download_url) {
        $tempFolder = [System.IO.Path]::GetTempPath()
        $tempFile = Join-Path $tempFolder 'cmder_mini.zip'
        write-host "downloading cmder minmi zip $($latestCmderMiniAsset.browser_download_url)" -f green
        Invoke-RestMethod -Uri $latestCmderMiniAsset.browser_download_url -OutFile $tempFile
        write-host "unpacking" -f green
        Expand-Archive -Path $tempFile -DestinationPath $cmderFolder -Force
    } else {
        write-warning "cannot locate cmder latest assets: $($ompGhLatestReleaseUri)"
    }
} else {
    write-host "cmder already installed" -f yellow
}

# copy ConEmu.xml
$cmderConEmuXmlPath = Join-Path $cmderFolder 'config/user-ConEmu.xml'
Copy-Item -Path "$($PsScriptRoot)/ConEmu.xml" -Destination $cmderConEmuXmlPath -Force
