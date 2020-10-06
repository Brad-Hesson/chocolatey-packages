$ErrorActionPreference = 'Stop';


$url         = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum    = 'c2a5a91f1d22dcf779ad1110a632ac841260e0fd4c0a258244710c37f46824d6'
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
