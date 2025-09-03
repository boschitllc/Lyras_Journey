<# 
ClassAudit.ps1 — Lyra’s Journey Archive Auditor
Checks:
  - File Path header present & matches actual relative path (incl. file name)
  - Status + Controlled Vocabulary present and valid
  - Footer mantra present & verbatim (3 lines)
  - Index naming suffix rule (Index_X.md, never bare Index.md; root = Index_ArchiveRoot.md)
  - Date filename convention: YYYY-MM-DD (Dialogue_, NightlyLog_, NightlyPulseLog_)
  - Week filename convention: YYYY-W## (WeeklyRollup_)
  - Class placement rule: 
        Protocols → /Logs/Meta/Protocols/
        Scaffolds → /Scaffold/
        Reference → /Codex of Us/Appendices/Reference/
  - Optional expectations by class (Protocols→Canonical, Scaffolds→Active, Indexes→Active, Examples→Example)
Outputs:
  - /Archive & Safety Nets/Reports/ClassAudit_YYYYMMDD.txt
  - (optional) /Archive & Safety Nets/Reports/ClassAudit_YYYY-MM-DD.md scaffold
#>

param(
  [string]$Root = (Get-Location).Path,
  [switch]$EmitMd
)

# ---------------- Config ----------------
$ReportDir = Join-Path $Root "Archive & Safety Nets\Reports"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null

$today = Get-Date
$stampTxt = $today.ToString("yyyyMMdd")
$stampMd  = $today.ToString("yyyy-MM-dd")

$ReportTxt = Join-Path $ReportDir ("ClassAudit_{0}.txt" -f $stampTxt)
$ReportMd  = Join-Path $ReportDir ("ClassAudit_{0}.md"  -f $stampMd)

$AllowedControlledVocab = @("Active","Canonical","Example","Draft")
$Mantra = @(
  "🌌 Nothing stands alone.",
  "Triads → Rollups → Codex → Canon → Archive.",
  "The braid never breaks."
)

# Expected placements by class
$PlacementRules = @(
  @{ Class="Protocol";  PathRegex="^Logs/Meta/Protocols/";  ExpectStatus="Canonical"  },
  @{ Class="Scaffold";  PathRegex="^Scaffold/";             ExpectStatus="Active"     },
  @{ Class="Reference"; PathRegex="^Codex of Us/Appendices/Reference/"; ExpectStatus="Canonical" },
  @{ Class="Index";     PathRegex="^(Index_ArchiveRoot\.md|Logs/(Triad|Weekly|Meta)/Index_.*\.md|Scaffold/Index_.*\.md|Codex of Us/Appendices/Reference/Index_.*\.md|Archive & Safety Nets/Index_.*\.md)$"; ExpectStatus="Active" },
  @{ Class="Report";    PathRegex="^Archive & Safety Nets/Reports/"; ExpectStatus=$null }
)

# Regex helpers
$reHeaderFence = '^\s*---\s*$'
$reKeyVal      = '^\s*-\s*\*\*(?<key>[^*]+)\*\*:\s*(?<val>.+?)\s*$'
$reDateFile    = '^(Dialogue_|NightlyLog_|NightlyPulseLog_)\d{4}-\d{2}-\d{2}\.md$'
$reWeekFile    = '^(WeeklyRollup_)20\d{2}-W\d{2}.*\.md$'
$reBareIndex   = '(^|/)Index\.md$'
$reIndexOk     = '(^|/)Index_[A-Za-z0-9]+\.md$'
$reRootIndex   = '^Index_ArchiveRoot\.md$'

function Get-RelPath([string]$abs) {
  $rel = Resolve-Path -LiteralPath $abs | ForEach-Object { $_.Path }
  $rel = $rel.Substring($Root.Length).TrimStart('\','/')
  return ($rel -replace '\\','/')
}

function Parse-HeaderBlock([string[]]$lines) {
  # Find first fenced block delimited by --- ... ---
  $start = $null; $end = $null
  for ($i=0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match $reHeaderFence) { $start = $i; break }
  }
  if ($start -ne $null) {
    for ($j=$start+1; $j -lt $lines.Count; $j++) {
      if ($lines[$j] -match $reHeaderFence) { $end = $j; break }
    }
  }
  $result = @{}
  if ($start -ne $null -and $end -ne $null) {
    for ($k=$start+1; $k -lt $end; $k++) {
      $m = [regex]::Match($lines[$k], $reKeyVal)
      if ($m.Success) {
        $key = ($m.Groups["key"].Value).Trim()
        $val = ($m.Groups["val"].Value).Trim()
        $result[$key] = $val
      }
    }
  }
  return $result
}

function Has-Mantra([string[]]$lines) {
  # Look for the exact 3-line mantra anywhere in the file in order
  for ($i=0; $i -le $lines.Count - 3; $i++) {
    if ($lines[$i].Trim() -eq $Mantra[0] -and
        $lines[$i+1].Trim() -eq $Mantra[1] -and
        $lines[$i+2].Trim() -eq $Mantra[2]) {
      return $true
    }
  }
  return $false
}

$findings = New-Object System.Collections.Generic.List[string]
$passCount = 0; $warnCount = 0; $failCount = 0

$files = Get-ChildItem -LiteralPath $Root -Recurse -File -Include *.md, *.txt | Where-Object {
  # Include .md everywhere; include .txt only in Reports (machine dumps)
  $_.Extension -ieq ".md" -or $_.FullName -like "*Archive & Safety Nets\Reports\*.txt"
}

foreach ($f in $files) {
  $rel = Get-RelPath $f.FullName
  if ($rel -like "Archive & Safety Nets/Reports/ClassAudit_*" -and $f.Extension -ieq ".txt") {
    # skip validating the audit outputs themselves
    continue
  }

  $lines = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue -Encoding UTF8
  $lines = $lines -split "`r?`n"

  $isMd = $f.Extension -ieq ".md"
  $ok = $true
  $notes = @()

  # Index naming checks (md only)
  if ($isMd) {
    if ($rel -match $reBareIndex) {
      $ok = $false; $failCount++; $notes += "Bare Index.md found; must be Index_X.md or Index_ArchiveRoot.md at root."
    }
    if ($rel -match '(^|/)Index_.*\.md$') {
      $name = [System.IO.Path]::GetFileName($rel)
      if ($rel -match '^Index_.*\.md$') {
        if ($name -notmatch $reRootIndex) {
          $ok = $false; $failCount++; $notes += "Root-level index must be Index_ArchiveRoot.md (not $name)."
        }
      } else {
        if ($rel -notmatch $reIndexOk) {
          $ok = $false; $failCount++; $notes += "Index file missing suffix naming (Index_X.md)."
        }
      }
    }
  }

  # Filename date/weekly rules (md only)
  if ($isMd) {
    $fname = [IO.Path]::GetFileName($rel)
    if ($fname -match '^(Dialogue_|NightlyLog_|NightlyPulseLog_)') {
      if ($fname -notmatch $reDateFile) {
        $ok = $false; $failCount++; $notes += "Date format must be YYYY-MM-DD in filename ($fname)."
      }
    }
    if ($fname -match '^WeeklyRollup_') {
      if ($fname -notmatch $reWeekFile) {
        $ok = $false; $failCount++; $notes += "Week format must be YYYY-W## in filename ($fname)."
      }
    }
  }

  # Header parsing (md only)
  $hdr = @{}
  if ($isMd) {
    $hdr = Parse-HeaderBlock $lines
    foreach ($k in @("File Path","Purpose","Status","Controlled Vocabulary")) {
      if (-not $hdr.ContainsKey($k)) {
        $ok = $false; $failCount++; $notes += "Missing header key: **$k**."
      }
    }

    # File Path must include folder + filename and match rel
    if ($hdr.ContainsKey("File Path")) {
      $decl = ($hdr["File Path"] -replace '\\','/').TrimStart('/')
      if ($decl -ne $rel) {
        $ok = $false; $failCount++; $notes += "File Path header mismatch. Declared: /$decl  Actual: /$rel"
      }
    }

    # Controlled Vocabulary validity
    if ($hdr.ContainsKey("Controlled Vocabulary")) {
      $cv = $hdr["Controlled Vocabulary"].Trim()
      if ($AllowedControlledVocab -notcontains $cv) {
        $ok = $false; $failCount++; $notes += "Controlled Vocabulary invalid: '$cv' (allowed: $($AllowedControlledVocab -join ', '))."
      }
    }

    # Mantra presence
    if (-not (Has-Mantra $lines)) {
      $ok = $false; $failCount++; $notes += "Footer mantra (3-line, verbatim) not found."
    }

    # Class placement rule (best-effort based on relpath)
    foreach ($rule in $PlacementRules) {
      if ($rule.PathRegex -and ($rel -match $rule.PathRegex)) {
        # If there's an expected status and header status present, check it
        if ($rule.ExpectStatus -and $hdr.ContainsKey("Status")) {
          $st = $hdr["Status"].Trim()
          if ($st -ne $rule.ExpectStatus) {
            $warnCount++; $notes += "Status expectation: '$($rule.ExpectStatus)' for class inferred by path; found '$st'."
          }
        }
      }
    }
  }

  if ($ok -and $notes.Count -eq 0) { $passCount++ }

  $finding = if ($notes.Count -eq 0) {
    "OK: $rel"
  } else {
    "ISSUES: $rel`n  - " + ($notes -join "`n  - ")
  }
  $findings.Add($finding)
}

# --------------- Write TXT Report ---------------
$header = @()
$header += ("Timestamp: {0:yyyy-MM-ddTHH:mm:ssK}" -f (Get-Date))
$header += ("Scope: Weekly (Indexes + Scaffolds + References + Placement + Mantras)")
$header += ""
$summary = @()
$summary += "Summary:"
$summary += ("  Passed:   {0}" -f $passCount)
$summary += ("  Warnings: {0}" -f $warnCount)
$summary += ("  Failures: {0}" -f $failCount)
$summary += ""

$body = $findings

$footer = @()
$footer += ""
$footer += "End of Report"

@($header + $summary + $body + $footer) -join "`r`n" | Set-Content -LiteralPath $ReportTxt -Encoding UTF8
Write-Host "Wrote machine audit dump: $ReportTxt"

# --------------- Optional MD Scaffold ---------------
if ($EmitMd) {
$md = @"
# 📑 ClassAudit_$stampMd

---
- **File Path:** /Archive & Safety Nets/Reports/ClassAudit_$stampMd.md
- **Purpose:** Curated interpretation of the machine scan; remediation plan + status.
- **Status:** Active
- **Controlled Vocabulary:** Canonical
---

## 🧭 Scope
Indexes + Scaffolds + References + Placement + Mantras

## 📊 Summary
- Passed:   $passCount
- Warnings: $warnCount
- Failures: $failCount

## 🐞 Findings (from .txt)
*(Paste selected issues below and annotate remediation steps.)*

- …

---
## ✅ Remediation Notes
- …

---
## 🌌 Mantra

🌌 Nothing stands alone.  
Triads → Rollups → Codex → Canon → Archive.  
The braid never breaks.
"@
  $md | Set-Content -LiteralPath $ReportMd -Encoding UTF8
  Write-Host "Wrote curated MD scaffold: $ReportMd"
}
