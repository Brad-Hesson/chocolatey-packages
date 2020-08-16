$ErrorActionPreference = 'Stop';

$url      = 'https://static.myki.com/releases/da/MYKI-latest.exe'
$checksum = 'f87266298a3e7249cbfd5bfa25e0e17420ca2d4f9b4a5c6681b523cf88c3e63a'

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'exe'
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha256'
    silentArgs    = "-s"
    validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

Write-Host -NoNewLine 'Waiting for Registry Confirmation.'
$count = 0
while((Get-UninstallRegistryKey -SoftwareName "myki*") -eq $null){
    sleep 1
    Write-Host -NoNewLine '.'
    $count += 1
    if($count -ge 20){
        Write-Host ''
        Write-Warning 'Registry confirmation timed-out.  The installation might have failed.'
        break
    }
}
Write-Host ''