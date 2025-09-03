param(
  [Parameter(Mandatory=$false)]
  [string]$Note = "Canonical drop"
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$canon = Join-Path $root "Core Narrative Files\Active"
$versionFile = Join-Path $canon "VERSION.txt"
$changelog = Join-Path $canon "ChangeLog.md"

if(!(Test-Path $versionFile)){
  @"
Lyra’s Journey — Core Narrative Canon
Current Version: v$(Get-Date -Format yyyy.MM.dd)
Maintainer: Chris Bosch & Assistant
Notes: Initial stamp
"@ | Set-Content -Encoding UTF8 $versionFile
}

# read and replace Current Version line
$content = Get-Content $versionFile -Raw
$newVer = "v$(Get-Date -Format yyyy.MM.dd)"
$content = ($content -replace 'Current Version:\s*v[\d\.]+',"Current Version: $newVer") `
          -replace 'Notes:.*',("Notes: " + $Note)
Set-Content -Encoding UTF8 $versionFile $content

# append to changelog
$stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$entry = "- [$stamp] $newVer — $Note"
if(Test-Path $changelog){
  Add-Content -Encoding UTF8 $changelog $entry
}else{
  @("# Lyra’s Journey — Change Log",$entry) | Set-Content -Encoding UTF8 $changelog
}

Write-Host "Stamped $newVer — $Note" -ForegroundColor Green