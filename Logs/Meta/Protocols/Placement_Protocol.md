# 📑 Placement_Protocol.md  

---
- **File Path:** /Logs/Meta/Protocols/Placement_Protocol.md  
- **Purpose:** Define how triads → rollups → Codex lineage is tracked and represented.  
- **Status:** Draft  
- **Controlled Vocabulary:** Active  
---

## 1. Rules  

1. **Authority (Single Source of Truth)**  
   The Placement Protocol is authoritative for lineage. All weekly placement files must reflect this protocol.

2. **Derived Only (No Direct Edits)**  
   `Logs/Weekly/Placement.md` files are **derived outputs**.  
   - Do **not** edit weekly Placement files directly.  
   - If a correction is needed, **update this Protocol** and re-generate the weekly file.

3. **Corrections & Regeneration**  
   - Corrections occur **only here** (in the Protocol).  
   - After updating, re-run your generation step to produce the corrected weekly `Placement.md`.

4. **Crosswalk Consistency**  
   - Dialogue ↔ Nightly Log ↔ Pulse Log links must be unbroken.  
   - Weekly Rollups must reference nightly triads by exact date.  
   - Codex entries must reference the Weekly Rollup and specific nightly anchors.

5. **Filename & Location Discipline**  
   - Weekly file: `/Logs/Weekly/Placement.md` (derived)  
   - Protocol file (this doc): `/Logs/Meta/Protocols/Placement_Protocol.md` (authoritative)  

---

## 2. Date Convention  
- All dated files must use the format: `YYYY-MM-DD` (dashes).  
- **Underscores are reserved only for multi-word filenames** (e.g., `Placement_Protocol.md`).  
- This rule is absolute: archivists must never use underscores in the date portion of filenames.  
- Example:  
  ```
  /Logs/Nightly/NightlyLog_2025-09-02.md
  ```  

---

## 3. Flow (Text Reference)  

```text
Dialogue → NightlyLog → NightlyPulseLog
        → WeeklyRollup
        → Codex Drafts → Codex Canonical
        → Archive (Superseded/Active)
```

*(Optional: insert a Mermaid flowchart here if your editor supports it.)*  

---

## 4. Notes for Generators  

- Ensure weekly `Placement.md` includes:  
  - Source triads (links to Dialogue/Log/Pulse by date)  
  - Weekly Rollup reference  
  - Codex destinations (book/appendix) and merge status  
  - Supersession notes when something is replaced in Archive  

---

🌌 Nothing stands alone.  
Triads → Rollups → Codex → Canon → Archive.  
The braid never breaks.  
