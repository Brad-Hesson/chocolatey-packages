$ErrorActionPreference = 'Stop';


$url         = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum    = '14b48c99dfcd49a38dd02dc9ff48ca94f461cf3ab80bd565bac08235b5d7b532'
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
