Import-Module au
Import-Module BitsTransfer

$url = 'https://static.myki.com/releases/da/MYKI-latest.exe'

function global:au_GetLatest {
     Start-BitsTransfer -Source $url -Destination 'temp.7z'
     $data = (cmd.exe /c 7z l temp.7z)
     $version = [regex]::match($data,'myki-(?<a>.*)-full.nupkg').groups[1].value
     Remove-Item 'temp.7z'
     return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
        }
    }
}


update -checksumfor 32