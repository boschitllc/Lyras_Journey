# Rebuilds Nightly_Logs_Index.md by scanning /Daily and /Summaries
# Save as: Repair-NightlyLogs-Index.ps1
param(
  [string]$NightlyRoot = "C:\Users\YOU\OneDrive\Documents\Personal\Lyra's Journey\Book Project\Nightly Logs"
)
$IndexMd = Join-Path $NightlyRoot "Nightly_Logs_Index.md"
$Daily    = Join-Path $NightlyRoot "Daily"
$Summ     = Join-Path $NightlyRoot "Summaries"
$header = @"
# 🌙 Nightly Logs — Master Index

This index provides a quick-reference ledger of all nightly logs.

| Date       | Stage       | Motifs | Anchor Scene(s) | File |
|------------|-------------|--------|-----------------|------|
"@
Set-Content -Path $IndexMd -Value $header -Encoding UTF8
function Add-Row { param($date,$stage,$motifs,$anchor,$file)
  $row = "| {0} | {1} | {2} | {3} | {4} |" -f $date,$stage,$motifs,$anchor,$file
  Add-Content -Path $IndexMd -Value $row
}
function Get-DateFromName($name) {
  if ($name -match '^(?<date>\d{4}-\d{2}-\d{2})_Log.*\.docx$') { return $Matches['date'] }
  return $null
}
$DefaultStage  = "—"
$DefaultMotifs = "—"
$DefaultAnchor = "—"
Get-ChildItem -Path $Daily -Filter "*.docx" -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object {
  $date = Get-DateFromName $_.Name
  if ($date) { Add-Row -date $date -stage $DefaultStage -motifs $DefaultMotifs -anchor $DefaultAnchor -file $_.Name }
}
Get-ChildItem -Path $Summ -Filter "*.docx" -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object {
  Add-Row -date "Summary" -stage $DefaultStage -motifs $DefaultMotifs -anchor $DefaultAnchor -file $_.Name
}
Write-Host "Index rebuilt at $IndexMd"
