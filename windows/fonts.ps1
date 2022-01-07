param(
    [Parameter(Mandatory=$False,Position=0)]
    [ValidateScript({ $_ -match '^\w+$' })]
    [string]
    $FontZipName = 'FiraCode'
)

# ----------------------------------------------
# func
# ----------------------------------------------
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
            write-warning "cannot find assetg matching regex: $($AssetRegex)"
            throw "font not found"
        }
    } else {
        write-warning "cannot find latest gh release for: $($OrgRepo)"
        throw "latest release not found"
    }
}
function Install-Fonts {
param(
    [Parameter(Mandatory=$True)]
    [ValidateScript({ Test-Path -Path $_ -PathType 'container' })]
    [ValidateNotNullOrEmpty()]
    [string]
    $FolderPath,

    [regex]
    $FileNameRegex = '\.ttf$'
)
    $installFontList = @()
    $installedFontDir = "$($ENV:LocalAppData)\Microsoft\Windows\Fonts"
    $filteredFilesList = @(Get-ChildItem -File -Path $FolderPath | Where-Object { $_.Name -match $FileNameRegex })
    if($filteredFilesList.Count -eq 0) {
        write-warning "No fonts matching regex '$($FileNameRegex)'' were found"
        return
    }
    $installedFontFileNames = @(Get-ChildItem -File -Path $installedFontDir | Select-Object -ExpandProperty 'name')
    foreach($fontFile in $filteredFilesList) {
        $cleanedName = $fontFile.Name -replace '_+',''
        if((($installedFontFileNames -notcontains $cleanedName)) -and
           (($installedFontFileNames -notcontains $fontFile.Name)))
        {
            $installFontList += $fontFile
        }
        else {
            write-host "font already installed: $($fontFile.Name)" -f yellow
        }
    }
    if($installFontList.Count -gt 0) {
        try {
            $objShell = New-Object -ComObject Shell.Application
            $objFolder = $objShell.Namespace(0x14)
            foreach($installFont in $installFontList) {
                write-host "installing font: $($installFont.Name)" -f cyan
                $objFolder.CopyHere($installFont.fullname)
            }
        }
        catch {
            write-warning $_.Exception.Message
        }
    }
}

# ----------------------------------------------
# main
# ----------------------------------------------
$fontAssetRegex = $FontZipName + '\.zip$'
$tempFolder = [System.IO.Path]::GetTempPath()
$tempFontFolder = Join-Path $tempFolder "FiraCodeNF_$(get-date -f 'yyyyMMddHHmmss')"

# download FiraCode nerd font
$latestFiraCodeNfAsset = Get-LatestGithubArtifact -OrgRepo 'ryanoasis/nerd-fonts' -AssetRegex $fontAssetRegex
if($latestFiraCodeNfAsset.browser_download_url) {
    $tempFile = Join-Path $tempFolder 'FiraCodeNF.zip'
    write-host "downloading FiraCode.zip $($latestFiraCodeNfAsset.browser_download_url)" -f green
    Invoke-RestMethod -Uri $latestFiraCodeNfAsset.browser_download_url -OutFile $tempFile
    write-host "unpacking" -f green
    mkdir $tempFontFolder -ea 0 -force | out-null
    Expand-Archive -Path $tempFile -DestinationPath $tempFontFolder -Force
} else {
    write-warning "cannot locate cmder latest assets: $($ompGhLatestReleaseUri)"
}

# install fonts
if(Test-Path -Path $tempFontFolder -PathType 'container') {
    Install-Fonts -FolderPath $tempFontFolder
}

