Import-Module au
Import-Module BitsTransfer

$url      = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$releases = 'http://myki-desktop-app.s3.eu-west-1.amazonaws.com'

function global:au_GetLatest {
    $xml = [xml](Invoke-WebRequest -Uri $releases).Content
    $version = [String]($xml.ListBucketResult.Contents | ? Key -match '-full.nupkg' | % {$_.Key -match '-(.*?)-'|Out-Null; [System.Version]$matches[1]}|sort|Select-Object -Last 1)

    $current_checksum = (gi $PSScriptRoot\tools\chocolateyinstall.ps1 | sls '\$checksum *=') -split "=|'" | Select -Last 1 -Skip 1
    if ($current_checksum.Length -ne 64) { throw "Can't find current checksum" }
    $remote_checksum  = Get-RemoteChecksum $url

    if ($current_checksum -ne $remote_checksum) {
        Write-Host 'Remote checksum is different then the current one, forcing update'
        $global:au_old_force = $global:au_force
        $global:au_force = $true
    }

    return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}


update -checksumfor 32