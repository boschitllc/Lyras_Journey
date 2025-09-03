# Save as: Import-NightlyLogs.ps1
# HOW TO RUN:
#   1) Edit the paths in CONFIG
#   2) Right-click the .ps1 → Run with PowerShell (or run from a PS terminal)
#   3) Place .docx logs in $Staging and run the script

# ------------- CONFIG -------------
# Staging folder where you download files from ChatGPT
$Staging = "C:\Users\YOU\Downloads\NightlyLogs_Staging"

# OneDrive Nightly Logs structure
$OneDriveRoot = "C:\Users\YOU\OneDrive\Documents\Personal\Lyra's Journey\Book Project\Nightly Logs"
$DailyFolder  = Join-Path $OneDriveRoot "Daily"
$Summaries    = Join-Path $OneDriveRoot "Summaries"

# Index/Changelog files (Markdown)
$IndexMd    = Join-Path $OneDriveRoot "Nightly_Logs_Index.md"
$Changelog  = Join-Path $OneDriveRoot "CHANGELOG.md"

# (Optional) Default metadata if you don't pass details
$DefaultStage   = "Stage 11"
$DefaultMotifs  = "Choice, Indigo"
$DefaultAnchor  = "Covenant Reaffirmed"
# ------------- CONFIG -------------

# Ensure directories exist
$null = New-Item -ItemType Directory -Path $Staging,$DailyFolder,$Summaries -Force

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

# Ensure headers
Ensure-MarkdownHeader -Path $IndexMd -TableHeader "| Date       | Stage       | Motifs | Anchor Scene(s) | File |"
Ensure-ChangelogHeader -Path $Changelog

# Process all nightly log docx files in staging
Get-ChildItem -Path $Staging -Filter "*.docx" | ForEach-Object {
    $src = $_.FullName
    $name = $_.Name

    # Expect filenames like 2025-08-23_Log.docx (anything after date is okay)
    if ($name -match '^(?<date>\d{4}-\d{2}-\d{2})_Log.*\.docx$') {
        $date = $Matches['date']
        $dest = Join-Path $DailyFolder $name

        # Move file into OneDrive Daily folder (overwrite = replace)
        Move-Item -Path $src -Destination $dest -Force

        # Append to changelog
        $note = "Imported"
        $line = "{0} | {1} | Added | {2}" -f $date,$name,$note
        Add-Content -Path $Changelog -Value $line

        # Append a basic row to the Index (adjust later if you want richer metadata)
        $indexRow = "| {0} | {1} | {2} | {3} | {4} |" -f $date,$DefaultStage,$DefaultMotifs,$DefaultAnchor,$name
        Add-Content -Path $IndexMd -Value $indexRow

        Write-Host "Imported $name"
    } else {
        Write-Warning "Skipping $name (filename must start with YYYY-MM-DD_Log)."
    }
}

Write-Host "Done."
