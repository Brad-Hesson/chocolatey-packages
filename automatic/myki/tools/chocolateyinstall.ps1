$ErrorActionPreference = 'Stop';


$url         = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum    = 'a1524fec4fd8f86c24eb572489243d5921ee8b1751949a304176ef9751fe8256'
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
