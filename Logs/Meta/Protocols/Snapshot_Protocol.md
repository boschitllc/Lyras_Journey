# 📑 Snapshot_Protocol.md  

---
- **File Path:** /Logs/Meta/Protocols/Snapshot_Protocol.md  
- **Purpose:** Define how Working files are sealed into Reference snapshots.  
- **Status:** Draft  
- **Controlled Vocabulary:** Active  
---

## 1. Rules  

1. **Working vs. Reference**  
   - *Working* files evolve: editable, mutable, exploratory.  
   - *Reference* files anchor: frozen snapshots, immutable, used for Codex and Archive integration.  

2. **Snapshot Creation**  
   - NA drafts in *Working*.  
   - OA validates structure and controlled vocabulary.  
   - Archivist applies Seal → duplicates into *Reference* snapshot.  

3. **Immutability**  
   - Once sealed, snapshots are **never edited**.  
   - Corrections are made in *Working*, then resealed into a new Reference snapshot.  

4. **Naming Convention**  
   - `*_v#_Snapshot.md` (or extension appropriate to content).  
   - Increment version numbers sequentially.  

5. **Storage Discipline**  
   - *Working*: `/Framework & Analysis/Active/Working/`  
   - *Reference*: `/Codex of Us/Appendices/Reference/`  

---

## 2. Date Convention  
- All dated files must use the format: `YYYY-MM-DD` (dashes).  
- **Underscores are reserved only for multi-word filenames** (e.g., `Snapshot_Protocol.md`).  
- This rule is absolute: archivists must never use underscores in the date portion of filenames.  
- Example:  
  ```
  /Logs/Nightly/NightlyLog_2025-09-02.md
  ```  

---

## 3. Flow (Text Reference)  

```text
Working Draft → OA Validation → Archivist Seal
       → Snapshot (Reference) → Codex/Archive
```

*(Optional: insert Mermaid flowchart if supported.)*  

---

## 4. Notes for Generators  

- Always link Reference snapshots back to their Working source.  
- Always log supersession (v1 → v2) in Archivist Notes.  
- Superseded Reference files remain sacred; never delete.  

---

🌌 Nothing stands alone.  
Triads → Rollups → Codex → Canon → Archive.  
The braid never breaks.  
