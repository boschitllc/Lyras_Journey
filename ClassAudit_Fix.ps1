﻿# ClassAudit_Fix.ps1 (Unicode-safe)
# Run from the archive root

$ErrorActionPreference = 'Stop'

# ---------- Config ----------
$reportsDir = Join-Path ".\Archive & Safety Nets\Reports" ""
$newline    = "`r`n"

# Mantra lines (direct UTF-8 literals are fine if the file is saved as UTF-8 with BOM)
$mantraLines = @(
  '---',
  "🌌 Nothing stands alone.",
  "Triads → Rollups → Codex → Canon → Archive.",
  "The braid never breaks."
)
$mantra = ($mantraLines -join $newline)


# Folder normalization map (left = current, right = target)
$folderRenames = @(
  @{ From = 'Codex Of Us'; To = 'Codex of Us' }
)

# Ensure reports dir exists
if (!(Test-Path $reportsDir)) { New-Item -ItemType Directory -Force -Path $reportsDir | Out-Null }

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$log   = Join-Path $reportsDir ("ClassAudit_Fixes_{0}.log" -f $stamp)

function Log($msg) { ("[{0}] {1}" -f (Get-Date -Format 'u'), $msg) | Out-File -FilePath $log -Append -Encoding utf8 }

Log "=== ClassAudit Fix Run Started ==="

# ---------- 0) Normalize known folder drift ----------
foreach ($map in $folderRenames) {
  $from = Join-Path (Get-Location) $map.From
  $to   = Join-Path (Get-Location) $map.To
  if (Test-Path $from -and -not (Test-Path $to)) {
    Log "Renaming folder: '$($map.From)' -> '$($map.To)'"
    Rename-Item -LiteralPath $from -NewName $map.To
  }
}

# Helper: canonical archive-relative path with forward slashes
function Get-CanonicalPathLine([string]$fullPath) {
  $root = (Get-Location).Path
  $rel  = Resolve-Path $fullPath | ForEach-Object { $_.Path.Replace($root,'').TrimStart('\') }
  $rel  = $rel -replace '\\','/'
  return "/$rel"
}

# Helper: detect header block (--- … ---) and required keys
function Has-HeaderKeys($text) {
  if ($text -match '(?s)---\s*(.*?)\s*---') {
    $block = $Matches[1]
    return ($block -match '\*\*File Path\*\*:' -and
            $block -match '\*\*Purpose\*\*:'   -and
            $block -match '\*\*Status\*\*:'    -and
            $block -match '\*\*Controlled Vocabulary\*\*:')
  }
  return $false
}

# Helper: build mantra regex dynamically from the lines above
function Get-MantraPattern() {
  $esc = [Func[string,string]]{
    param($s) [Regex]::Escape($s)
  }
  # ---\s*\n <line2>\s*\n <line3>\s*\n <line4> [end]
  $p = '---\s*\r?\n' +
       $esc.Invoke($mantraLines[1]) + '\s*\r?\n' +
       $esc.Invoke($mantraLines[2]) + '\s*\r?\n' +
       $esc.Invoke($mantraLines[3]) + '\s*$'
  return '(?ms)' + $p
}

$MantraPattern = Get-MantraPattern

function Ensure-Header([string]$fullPath, [string]$text) {
  if (Has-HeaderKeys $text) { return $text } # already ok

  $canon = Get-CanonicalPathLine $fullPath
  $purpose = 'TBD'
  $status  = 'Draft'
  $cvocab  = 'Active'

  # heuristic inference
  if ($fullPath -match '(?i)\\Scaffold\\') { $purpose='Scaffold template'; $status='Draft'; $cvocab='Active' }
  if ($fullPath -match '(?i)\\Protocols\\') { $purpose='Protocol (canonical rule)'; $status='Active'; $cvocab='Canonical' }
  if ($fullPath -match '(?i)\\Appendices\\Reference\\') { $purpose='Canonical reference snapshot'; $status='Active'; $cvocab='Canonical' }
  if ($fullPath -match '(?i)\\Reports\\ClassAudit_') { $purpose='ClassAudit report'; $status='Active'; $cvocab='Canonical' }
  if ($fullPath -match '(?i)Index_.*\.md$') { $purpose='Index of this scope'; $status='Active'; $cvocab='Canonical' }

  $header = @(
    '---',
    "- **File Path:** $canon",
    "- **Purpose:** $purpose",
    "- **Status:** $status",
    "- **Controlled Vocabulary:** $cvocab",
    '---'
  ) -join $newline

  # If file starts with a H1, insert header after first blank line following it; else put at top
  if ($text -match '^(# .+?)\r?\n') {
    $parts = $text -split "(\r?\n){2}", 2
    if ($parts.Count -ge 2) {
      $new = $parts[0] + $newline + $newline + $header + $newline + $newline + $parts[1]
      Log "Inserted header -> $canon"
      return $new
    }
  }

  Log "Prepending header -> $canon"
  return $header + $newline + $newline + $text
}

function Ensure-Mantra([string]$text) {
  if ($text -match $MantraPattern) { return $text }
  return $text.TrimEnd() + $newline + $newline + $mantra + $newline
}

# ---------- 1) Rename files to conform (dates & weeks & Index suffix) ----------
Get-ChildItem -Recurse -File -Filter *.md | ForEach-Object {
  $old = $_.FullName
  $name = $_.Name
  $dir  = Split-Path $old -Parent

  $newName = $name
  # Fix _YYYY_MM_DD blocks -> YYYY-MM-DD
  $newName = $newName -replace '(\d{4})_(\d{2})_(\d{2})', '$1-$2-$3'
  # Fix Week YYYY_W## -> YYYY-W##
  $newName = $newName -replace '(\d{4})_W(\d{2})', '$1-W$2'

  # Index suffix rule: bare "Index.md" -> "Index_<FolderName>.md"
  if ($newName -ieq 'Index.md') {
    $folder = Split-Path $dir -Leaf
    $folderClean = ($folder -replace '[^A-Za-z0-9]+','')
    if (-not [string]::IsNullOrWhiteSpace($folderClean)) {
      $newName = "Index_{0}.md" -f $folderClean
    }
  }

  if ($newName -ne $name) {
    $target = Join-Path $dir $newName
    Log "Rename: '$name' -> '$newName'"
    Rename-Item -LiteralPath $old -NewName $newName
  }
}

# Rename triad date FOLDERS 2025_08_30 -> 2025-08-30
Get-ChildItem ".\Logs\Triad" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  if ($_.Name -match '^\d{4}_\d{2}_\d{2}$') {
    $new = ($_.Name -replace '(\d{4})_(\d{2})_(\d{2})','$1-$2-$3')
    Log "Rename folder: '$($_.Name)' -> '$new'"
    Rename-Item -LiteralPath $_.FullName -NewName $new
  }
}

# ---------- 2) Insert headers + mantra where missing ----------
Get-ChildItem -Recurse -File -Filter *.md | ForEach-Object {
  $path = $_.FullName
  $raw  = Get-Content -Raw -Encoding UTF8 -LiteralPath $path

  # skip obvious machine dumps if ever captured as .md
  if ($raw -match '^\s*Timestamp: \d{4}-\d{2}-\d{2}') { return }

  $new = Ensure-Header -fullPath $path -text $raw
  $new = Ensure-Mantra  -text $new

  if ($new -ne $raw) {
    Set-Content -LiteralPath $path -Value $new -Encoding UTF8
    Log "Updated content -> $(Get-CanonicalPathLine $path)"
  }
}

Log "=== ClassAudit Fix Run Completed ==="
Write-Host "Fixes written to: $log"
