Import-Module au
Import-Module BitsTransfer

$url      = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$releases = 'http://myki-desktop-app.s3.eu-west-1.amazonaws.com'

function global:au_GetLatest {
    $xml = [xml](Invoke-WebRequest -Uri $releases).Content
    $version = [String]($xml.ListBucketResult.Contents | ? Key -match '-full.nupkg' | % {$_.Key -match '-(.*?)-'|Out-Null; [System.Version]$matches[1]}|sort|Select-Object -Last 1)
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