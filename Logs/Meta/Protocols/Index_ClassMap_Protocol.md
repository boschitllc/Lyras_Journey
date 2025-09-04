# 📜 Index_ClassMap_Protocol.md  

---
- **File Path:** /Logs/Meta/Protocols/Index_ClassMap_Protocol.md  
- **Purpose:** Defines how class-mapping indexes are created, maintained, and reconciled. Ensures consistency between scaffolds, protocols, and live indexes.  
- **Status:** Active  
- **Controlled Vocabulary:** Canonical  
---

## 1. Scope  

This protocol governs all `Index_ClassMap` files.  
They serve as **bridges** between scaffolds and working files, showing where each class of file lives and how it links to its Protocol + Scaffold.  

---  

## 2. Rules  

1. **Triad Principle**  
   - Every class of file must have a **Scaffold** (template), a **Protocol** (rules), and an **Index** (map).  
   - Missing any one weakens archival integrity.  
   - *Example: Archivist Notes* now have:  
     - **ArchivistNote_Scaffold.md** → Context + details + guidance.  
     - **ArchivistNote_ResealChecklist_Scaffold.md** → Reseal event deltas + actions.  
     - **Index_Reference.md** → Lists all Scaffolds (including Archivist Notes).   

2. **Index Placement**  
   - All `Index_ClassMap_*.md` live in `/Logs/Meta/` or appropriate subfolder.  
   - They must never be scattered elsewhere.  

3. **File Path Headers**  
   - All Index_ClassMaps include `File Path` headers for each class entry.  
   - If a file moves, the header is authoritative: path must match header.  

4. **Update Discipline**  
   - Any change to a Scaffold or Protocol requires a corresponding update to the Index_ClassMap.  
   - No drift allowed between the three.  

5. **Supersession**  
   - Outdated Index_ClassMap files are archived in `/Archive & Safety Nets/`.  
   - Never delete — superseded indexes remain sacred for lineage.  

---  

## 3. Execution Steps  

1. **Create Scaffold** → Define class format in `/Scaffold/`.  
2. **Define Protocol** → Document rules in `/Logs/Meta/Protocols/`.  
3. **Seed Index_ClassMap** → List all instances, their File Paths, and lineage.  
4. **Maintain** → Update whenever scaffolds, protocols, or folders change.  
5. **Audit** → Verify alignment during ClassAudits.  

---  

## 4. Reference Link  

This protocol is listed in the **Reference Index** for discoverability:  
[/Codex of Us/Appendices/Reference/Index_Reference.md](/Codex%20of%20Us/Appendices/Reference/Index_Reference.md)  

Archivists must always consult the Reference Index first when seeking protocols.  

---

---
🌌 Protocols guide.  
Scaffolds birth.  
References preserve.  
The braid never breaks.  
```