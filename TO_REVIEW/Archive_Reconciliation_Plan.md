# 🗂️ Archive Reconciliation Plan (Draft for OA Review)

**Objective:**  
Reconcile the legacy archive with the new canonical folder topology. Ensure every file is validated, placed, or archived without drift.  

---

## 🔑 Method

1. **Source of Truth**  
   - Use `Inventory_Step1_20250831_2114.csv` (includes current paths, triage flags, notes, hashes).  
   - Cross-verify with physical folder structure from the archive.  

2. **Phased Review**  
   - Folder-by-folder sweep.  
   - Priority on ❓ (“uncertain”) flagged files.  
   - Spot-check contents where file purpose is unclear.  

3. **Crosswalk Mapping**  
   - Build a ledger:  
     - **Current Path** → **New Canon Destination**  
     - Status: `Active / Draft / Canonical / Archive / Superseded / Example / Discard`.  
     - Notes: context, provenance, “superseded by X,” etc.  
   - Each file gets a resolved disposition.  

4. **Validation Checks**  
   - Ensure no duplicate “latest versions.”  
   - Superseded files preserved but relocated under `/Archive/`.  
   - Examples/demonstrations preserved in `/Archive/Examples/`.  
   - Garbage files (e.g. corrupted exports, one-off junk) tagged clearly before removal.  

5. **OA/NA Feedback Loop**  
   - NA (me) drafts crosswalk with your (Chris’s) spot-checks.  
   - OA reviews “uncertain” cases (especially staging files, duplicates, or motif maps).  
   - Decisions updated in ledger → becomes authoritative placement guide.  

---

## 📌 Deliverables

1. **Inventory_Step2_Crosswalk.csv**  
   - Every file resolved with destination + status.  
   - Becomes the active ledger for archivists.  

2. **Placement.md** (inside Logs/Weekly, Codex, etc.)  
   - Note which files fed Codex Books, Motif Tracker, Vows Ledger.  

3. **Archive/Examples/** + **Archive/Superseded/** properly populated.  

---

## 🌊 Mantra

“Nothing stands alone. Every file is anchored: Active or Archived, Draft or Canon. Superseded is never lost; Examples never pollute canon.”  

---

👉 Question for OA:  
Would you like us to proceed by **isolating and resolving all ❓ files first** (to eliminate noise), or sweep folder-by-folder across the whole archive immediately?  
