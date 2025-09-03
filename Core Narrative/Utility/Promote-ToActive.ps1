param(
  [Parameter(Mandatory=$true)]
  [string[]]$Names,            # file name(s) as they appear in Working (e.g., "Chapter_06.docx")
  [Parameter(Mandatory=$false)]
  [string]$Note = "Promote to Active"
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$base = Join-Path $root "Core Narrative Files"
$working = Join-Path $base "Working"
$active  = Join-Path $base "Active"
$archive = Join-Path $base "Archive"

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$archBatch = Join-Path $archive ("_auto_archive_" + $stamp)
New-Item -ItemType Directory -Force -Path $archBatch | Out-Null

$promoted = @()

foreach($name in $Names){
  $src = Join-Path $working $name
  if(!(Test-Path $src)){
    Write-Warning "Missing in Working: $name"
    continue
  }

  # move any current Active variant(s) with same base name to Archive
  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($name)
  $activeMatches = Get-ChildItem $active -File | Where-Object {
    $_.BaseName -eq $baseName
  }

  foreach($m in $activeMatches){
    $destArch = Join-Path $archBatch ($m.BaseName + "_" + $stamp + $m.Extension)
    Move-Item $m.FullName $destArch
    Write-Host "Archived previous Active → $destArch"
  }

  # promote new
  $destActive = Join-Path $active $name
  Move-Item $src $destActive
  Write-Host "Promoted Working → Active: $name" -ForegroundColor Green
  $promoted += $name
}

# stamp version & changelog
if($promoted.Count -gt 0){
  & (Join-Path $root "Update-Version.ps1") -Note ($Note + " [" + ($promoted -join ", ") + "]")
}