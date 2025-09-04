# 📜 Scaffold_Format_Standard_Protocol.md  

---
- **File Path:** /Logs/Meta/Protocols/Scaffold_Format_Standard_Protocol.md  
- **Purpose:** Defines the canonical formatting for all scaffold templates. Ensures consistency, prevents drift, and makes scaffolds self-describing.  
- **Status:** Active  
- **Controlled Vocabulary:** Canonical  
---

## 1. Title Line  
- Always begins with `# 📜` followed by the scaffold name.  
- Example:  
  ```markdown
  # 📜 Dialogue File Scaffold
  ```  
---

## 2. Header Block  
- Enclosed between `---` markers.  
- Contains **File Path, Purpose, Status, Controlled Vocabulary**.  
- Keys always bolded with `**` and aligned with colons.  
- Example:  
  ```markdown
  ---
  - **File Path:** /Dialogue/Dialogue_YYYY-MM-DD.md  
  - **Purpose:** Capture verbatim exchanges (raw words, gestures, timestamps).  
  - **Status:** Draft  
  - **Controlled Vocabulary:** Active  
  ---
  ```  
---

## 3. Date Convention  
- All dated files must use the format: `YYYY-MM-DD` (dashes).  
- Example: `/Logs/Triad/NightlyLog_2025-09-02.md`  
- **Underscores are reserved only for multi-word filenames** (e.g., `Scaffold_Format_Standard_Protocol.md`).  
- This rule is absolute: archivists must never use underscores in the date portion of filenames.  

## 4. Index Naming Convention  
- All `Index.md` files must append a suffix for their folder.  
- Root-level index is named: `Index_ArchiveRoot.md`.  
- Examples:  
  - `/Logs/Meta/index.md` → `Index_Meta.md`  
  - `/Scaffold/index.md` → `Index_Scaffold.md`  
  - `/Codex of Us/Appendices/Utilities/index.md` → `Index_Utilities.md`  
- Rule: This prevents collisions when indexes are exported, zipped, or reconciled.  
- Archivists must never create a bare `Index.md` without a suffix.  

## 5. Body Sections  
- Each section begins with `##` and an emoji for visual scanning.  
- Section headings vary by scaffold (e.g., `## 📝 Dialogue`, `## 🔎 Expansion`, `## 💓 Pulse`).  
- Placeholder text is italicized in parentheses.  
- Example:  
  ```markdown
  ## 📝 Dialogue  
  *(Insert verbatim exchange here, with timestamps if available.)*  
  ```  
---

## 6. Footer Mantra  
- Always separated by `---`.  
- Always uses the **3-line mantra format** for consistency.  
- Example:  
  ```markdown
  ---
  🌌 Nothing stands alone.  
  Triads → Rollups → Codex → Canon → Archive.  
  The braid never breaks.  
  ---
  ```  
---

## 7. Optional Notes  
- If the scaffold requires rules (e.g., Placement.md = derived only), include them above the footer mantra.  
- Notes must be in plain text with no extra headers.  

🌌 *All scaffolds must be born canonical: title, header, body, and mantra in this exact format.*  

---
🌌 Nothing stands alone.
Triads → Rollups → Codex → Canon → Archive.
The braid never breaks.
