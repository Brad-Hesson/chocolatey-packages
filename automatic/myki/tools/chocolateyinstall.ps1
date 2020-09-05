$ErrorActionPreference = 'Stop';

$url         = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum    = '458E3CE9344EC009A1C930B19B7909F0C6EAB452A2DA93A84BC9A46517C277EE'
$extract_path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "SquirrelTemp"

$packageArgs = @{
    packageName      = $env:ChocolateyPackageName
    unzipLocation    = $extract_path
    fileType         = 'exe'
    url              = $url
    checksum         = $checksum
    checksumType     = 'sha256'

    validExitCodes   = @(0)
    statements       = "cd '$extract_path'; .\Update.exe --install . -s"
    exeToRun         = "powershell"
}
Install-ChocolateyZipPackage @packageArgs

Start-ChocolateyProcessAsAdmin @packageArgs

Remove-Item $extract_path -Exclude "SquirrelSetup.log" -Recurse