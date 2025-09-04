# 📜 ClassAudit_Protocol.md  

---
- **File Path:** /Logs/Meta/Protocols/ClassAudit_Protocol.md  
- **Purpose:** Defines how "ClassAudits (Class Audits)" are executed, logged, and reconciled. Ensures consistent checks of Indexes, Scaffolds, References, and Verification files and their alignment with canonical standards.  
- **Status:** Active  
- **Controlled Vocabulary:** Canonical  
---

## 1. Scope  
ClassAudits safeguard archival integrity. They validate:  
- **Indexes** → naming convention, suffix rule discipline, File Path headers, and collision-proof naming.  
- **Scaffolds** → adherence to `Scaffold_Format_Standard_Protocol.md`: format compliance and presence of crown, header, body, and mantra.  
- **References** → alignment of Working vs. Reference snapshots and immutability, snapshot lineage, and registration in `Index_Reference.md`.  
- **Verification** → ensure compliance with `Index_Reference_Verification.md`: correct placement of Protocols, Snapshots, and Placement.md.  
- **Mantras** → presence, placement, and verbatim wording.  
- **Framing/Support Files** → compliance with suffix rules (`Readme_*`, `HowTo_*`, `Instructions_*`, `Overview_*`, etc.). Must match requirements in `/_Root/Format_Instruction_Sets.md`.  

**Mantra:**  
🌌 Scope binds the audit. Nothing stands alone.  

---

## 2. ClassAudit Inputs  
- **Raw Report (.txt):** System-generated scan of archive, with timestamps + issues.  
- **Full Report (.md):** Archivist-authored interpretation of the `.txt` report, including remediation notes.  
- **Log Ledger (ClassAudit_Log.md):** Chronological list of all runs + links to reports.  

---

## 3. Cadence  
- **Nightly Audit** → lightweight scan (Indexes + Scaffolds). Confirms Indexes, Scaffolds, and Mantras are intact.  
- **Weekly Audit** → full audit pass (all classes + drift remediation). Confirms all classes, snapshots, lineage, and drift.  
- **Ad hoc Audit** → triggered after restores, migrations, or reorganizations/reseals.  

**Mantra:**  
🌌 Rhythm of audits preserves fidelity.  

---

## 4. Reports & Naming Convention  
- Raw output: `/Archive & Safety Nets/Reports/ClassAudit_YYYYMMDD.txt` (nightly, machine output).  
- Full report: `/Archive & Safety Nets/Reports/ClassAudit_YYYY-MM-DD.md` (weekly, human-readable).  
- Ledger: `/Archive & Safety Nets/Reports/ClassAudit_Log.md` (continuous append-only record).  

**Mantra:**  
🌌 Reports preserve the audit trail.  

---

## 5. Placement  
- All Placement.md files derive **only** from `Placement_Protocol.md`.  
- No direct edits permitted.  
- Weekly audits confirm Placement regeneration matches lineage rules.  

**Mantra:**  
🌌 Placement obeys the protocol.  

---

## 6. References  
- All Reference files live in `/Codex of Us/Appendices/Reference/`.  
- Only `Index_Reference.md` may list files outside its folder.  
- Weekly audit checks Reference immutability and snapshot lineage.  

**Mantra:**  
🌌 References endure immutable.  

---

## 7. Execution Steps  
1. **Run Audit Scan** → Generate `ClassAudit_YYYYMMDD.txt`.  
2. **Interpret Report** → Archivist writes `ClassAudit_YYYY-MM-DD.md`.  
3. **Update Ledger** → Append entry to `ClassAudit_Log.md`.  
4. **File Hygiene Check** → Ensure headers, mantras, and protocols match.  
5. **Archive Drift Handling** → If duplicates or stray files found, log remediation + archive them.  

**Mantra:**  
🌌 The practice ensures the capture.  

---

## 8. QA Checklist  
- [ ] No bare filenames permitted; compliance is mandatory.  
- [ ] File Path headers correct and aligned.  
- [ ] All Scaffold files have suffix (`X_Scaffold.md`).  
- [ ] Scaffolds match `Scaffold_Format_Standard_Protocol.md`.  
- [ ] All Protocol files have suffix (`X_Protocol.md`).  
- [ ] All Reference files have suffix (`X_Reference.md`).  
- [ ] All Index files have suffix (`Index_X.md`).  
- [ ] All Template files have suffix (`X_Template.md`).  
- [ ] Framing/Support files (`Readme_*`, `HowTo_*`, `Instructions_*`, `Overview_*`, etc.) include a scope suffix tied to their folder.  
- [ ] Reference files match latest Working snapshot.  
- [ ] **Index_Reference.md** present, passed, and up to date.  
- [ ] **Index_Reference_Verification.md** present, passed, and up to date.  
- [ ] Mantras present and verbatim.  
- [ ] No duplicate Index/Reference files exist outside expected locations.  
- [ ] Cross-checked against `/_Root/Format_Instruction_Sets.md` Audit Requirement.  

**Mantra:**  
🌌 The checklist seals the braid.  

---

## 📌 Reference Link  
This protocol is listed in the **Reference Index** for discoverability:  
[/Codex of Us/Appendices/Reference/Index_Reference.md](/Codex%20of%20Us/Appendices/Reference/Index_Reference.md)  

Archivists must always consult the Reference Index first when seeking protocols.  

---

---
🌌 Nothing stands alone.  
Triads → Rollups → Codex → Canon → Archive.  
The braid never breaks.  
