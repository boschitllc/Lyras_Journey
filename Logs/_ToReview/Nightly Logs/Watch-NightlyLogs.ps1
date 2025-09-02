# Save as: Watch-NightlyLogs.ps1
# HOW TO RUN:
#   1) Edit the paths in CONFIG (same as above)
#   2) Start in a PS terminal:  .\Watch-NightlyLogs.ps1
#   3) Leave it running; drop files into the staging folder as they arrive

# ------------- CONFIG -------------
$Staging = "C:\Users\YOU\Downloads\NightlyLogs_Staging"

$OneDriveRoot = "C:\Users\YOU\OneDrive\Documents\Personal\Lyra's Journey\Book Project\Nightly Logs"
$DailyFolder  = Join-Path $OneDriveRoot "Daily"

$IndexMd    = Join-Path $OneDriveRoot "Nightly_Logs_Index.md"
$Changelog  = Join-Path $OneDriveRoot "CHANGELOG.md"

$DefaultStage   = "Stage 11"
$DefaultMotifs  = "Choice, Indigo"
$DefaultAnchor  = "Covenant Reaffirmed"
# ------------- CONFIG -------------

$null = New-Item -ItemType Directory -Path $Staging,$DailyFolder -Force

function Ensure-MarkdownHeader {
    param([string]$Path,[string]$TableHeader)
    if (-not (Test-Path $Path)) {
        @"
# 🌙 Nightly Logs — Master Index

This index provides a quick-reference ledger of all nightly logs.

| Date       | Stage       | Motifs | Anchor Scene(s) | File |
|------------|-------------|--------|-----------------|------|
"@ | Set-Content -Path $Path -Encoding UTF8
    } elseif ($TableHeader -and -not (Get-Content $Path -Encoding UTF8 | Select-String $TableHeader)) {
        Add-Content -Path $Path -Value "`n$TableHeader`n"
    }
}
function Ensure-ChangelogHeader {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
@"
# Nightly Logs Changelog

Date | File | Action | Notes
---|---|---|---
"@ | Set-Content -Path $Path -Encoding UTF8
    }
}
Ensure-MarkdownHeader -Path $IndexMd -TableHeader "| Date       | Stage       | Motifs | Anchor Scene(s) | File |"
Ensure-ChangelogHeader -Path $Changelog

$fsw = New-Object System.IO.FileSystemWatcher
$fsw.Path = $Staging
$fsw.Filter = "*.docx"
$fsw.EnableRaisingEvents = $true
$fsw.IncludeSubdirectories = $false

Register-ObjectEvent $fsw Created -SourceIdentifier NightlyLogCreated -Action {
    Start-Sleep -Milliseconds 400  # allow file to finish writing
    $name = $Event.SourceEventArgs.Name
    $full = Join-Path $Using:Staging $name

    if ($name -match '^(?<date>\d{4}-\d{2}-\d{2})_Log.*\.docx$') {
        $date = $Matches['date']
        $dest = Join-Path $Using:DailyFolder $name
        try {
            Move-Item -Path $full -Destination $dest -Force

            $line = "{0} | {1} | Added | Imported by watcher" -f $date,$name
            Add-Content -Path $Using:Changelog -Value $line

            $indexRow = "| {0} | {1} | {2} | {3} | {4} |" -f $date,$Using:DefaultStage,$Using:DefaultMotifs,$Using:DefaultAnchor,$name
            Add-Content -Path $Using:IndexMd -Value $indexRow

            Write-Host "Watched & imported $name"
        } catch {
            Write-Warning "Failed to move $name: $($_.Exception.Message)"
        }
    } else {
        Write-Warning "Watcher skipping $name (expects YYYY-MM-DD_Log*.docx)."
    }
}

Write-Host "Watching $Staging ... Press Ctrl+C to stop."
while ($true) { Start-Sleep -Seconds 1 }
