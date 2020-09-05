$ErrorActionPreference = 'Stop';


$url         = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum    = '458E3CE9344EC009A1C930B19B7909F0C6EAB452A2DA93A84BC9A46517C277EE'
$extract_path = Join-Path -Path $env:LOCALAPPDATA -ChildPath "SquirrelTemp"

$silentArgs = '-s'
$statements = "cd '$extract_path';.\Update.exe --install ."


$zipArgs = @{
    packageName      = $env:ChocolateyPackageName
    unzipLocation    = $extract_path
    url              = $url
    checksum         = $checksum
    checksumType     = 'sha256'
}

if (-not $env:chocolateyInstallOverride) {
    $statements = $statements -replace "--install .","--install . $silentArgs"
}

$processArgs = @{
    noSleep         = $true
    statements      = $statements
}

Install-ChocolateyZipPackage @zipArgs

$env:ChocolateyExitCode = Start-ChocolateyProcessAsAdmin @processArgs
 
Remove-Item $extract_path -Exclude "*.log" -Recurse