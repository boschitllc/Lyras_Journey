param(
  [Parameter(Mandatory=$false)]
  [string]$Note = "Rehearsal snapshot"
)

$root   = Split-Path -Parent $MyInvocation.MyCommand.Path
$active = Join-Path $root "Core Narrative Files\Active"
$rehDir = Join-Path $root ("_Rehearsal\Rehearsal_" + (Get-Date -Format "yyyyMMdd_HHmmss"))

# Make rehearsal dir
New-Item -ItemType Directory -Force -Path $rehDir | Out-Null

# Copy Active canon
Copy-Item -Recurse -Force $active $rehDir

# Write marker file
$marker = Join-Path $rehDir "SNAPSHOT.txt"
$stamp  = Get-Date -Format "yyyy-MM-dd HH:mm"
@"
Lyra’s Journey — Rehearsal Snapshot
Timestamp: $stamp
Note: $Note
Source: $active
"@ | Set-Content -Encoding UTF8 $marker

Write-Host "Snapshot created → $rehDir" -ForegroundColor Cyan


# Run before risky promotion
.\Rehearsal-Snapshot.ps1 -Note "Before canonizing Eternity arc"