# DRRA2 Hierarchical Integration

This repository contains the full design environment and scripts for hierarchical floorplanning, power planning, and backend automation of a DRRA2-based architecture using the SiLago framework.

---

## 📁 Folder Structure

- `rtl/` – RTL source files (SystemVerilog)
- `syn/` – Synthesis scripts and constraints (e.g., Genus)
- `phy/`
  - `scr/` – Floorplanning, power planning, P&R TCL scripts (Innovus)
  - `db/` – Design databases
  - `rpt/` – Reports and metrics (left empty by default)
- `dummy/` – Main folder for running Innovus. Now also includes:
  - `CORE_PG_25C_avg_1/` – Rail analysis results (core VDD/VSS)
  - `power/` – Power analysis database and reports
    - `power_db.zip` – Zipped power database (contains `power.db`)
- `exe/` – Folder for launching Genus to synthesize RTL (optional)
- `SCRIPTS/` – Python and TCL automation tools

---

## 🛠️ Prerequisites

- Cadence Genus (for synthesis)
- Cadence Innovus (for physical implementation)
- Bash + TCL environment
- Python 3.x (for automation scripts)
- Access to PDKs and standard cell libraries (via `$PDK_PATH`)

---

## ⚙️ Quick Start Options

### 🚀 Option 1: Load Pre-Generated Database and Results (Recommended)

If you just want to **view the design** or **analyze power and rail metrics**:

1. Unzip the power database first:

   ```bash
   cd dummy/power
   unzip power_db.zip
   ```

2. Open Innovus from the `dummy` folder:

   ```bash
   cd ../
   innovus -stylus
   ```

3. Load the saved database:

   ```tcl
   read_db ../phy/db/fabric.dat
   ```

4. You can now:
   - Inspect layout, placement, and routing
   - Check timing: 
     ```tcl
     report_timing
     ```
   - Load power reports from the `power/` folder
   - View IR drop from `CORE_PG_25C_avg_1/`
   - To view IR drop, run:
     ```tcl
     read_power_rail_results -power_db ./power/power.db -rail_directory CORE_PG_25C_avg_1/
     ```

---

### 🛠️ Option 2: Run Full Design Flow from Scratch

#### 1. Synthesize the RTL (Optional)

```bash
cd exe
./genus_topdown.sh
```

> Skip this step if using the pre-synthesized `fabric.v` and `constraints.sdc`.

#### 2. Generate Automation Scripts

```bash
cd ../SCRIPTS
python3 generate_drra2_tcl.py
python3 pads_script.py  # For power rails
```

#### 3. Floorplan and Partition

```bash
cd ../dummy
innovus -stylus
```

```tcl
source ../phy/scr/read_design.tcl
source ../phy/scr/floorplan.tcl
source ../phy/scr/partition.tcl
```

Then close Innovus.

#### 4. Place-and-Route Partitions

```bash
./launch_all_partitions_parallel.sh   # or sequential version
```

#### 5. Top-Level P&R

```bash
innovus -stylus
source ../phy/scr/pnr_top.tcl
```

#### 6. Assemble Final Design

```bash
innovus -stylus
source ../phy/scr/assembly_design.tcl
```

#### 7. Power Rail Analysis

```tcl
source ../SCRIPTS/power_rail_analysis.tcl
```

#### 8. Area Data Extraction

```tcl
source ../SCRIPTS/normal_wires_data.tcl
source ../SCRIPTS/pg_wires_data.tcl
```

```bash
cd ../SCRIPTS
python3 grid_area.py
```

---

## 📝 Notes

- The power database file `power.db` is compressed as `power_db.zip`. Please unzip it before use.
- You can skip all P&R steps by restoring `db/fabric.dat`.
- Power and rail analysis data is located in the `dummy/` subfolders.
- `.keep` files are used to retain empty directory structure in Git.

---

## 📩 Contact

**Davide Finazzi**  
📧 finazzi.davide01@outlook.it  
🔗 [github.com/davidepanzino](https://github.com/davidepanzino)
