$ErrorActionPreference = 'Stop';


$url         = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum    = '04315774adf74f637cab366d26b2ab721ac87c0c477eb0c25520065863b360f0'
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
