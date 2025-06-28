# DRRA2 Flat Integration

This repository contains the full design environment and scripts for flat floorplanning, power planning, and backend automation of a DRRA2-based architecture using the SiLago framework.

---

## 📁 Folder Structure

- `rtl/` – RTL source files (SystemVerilog)
- `syn/` – Synthesis scripts and constraints (e.g., Genus)
- `phy/`
  - `scr/` – Floorplanning, power planning, P&R TCL scripts (Innovus)
  - `db/` – Design databases
  - `rpt/` – Reports and metrics (left empty)
- `dummy/` – Folder from which to run Cadence Innovus. Now also includes:
  - `CORE_PG_25C_avg_1/` – Rail analysis results (core VDD/VSS)
  - `power/` – Power analysis database and reports
- `exe/` – Folder from which to run Genus for synthesizing the RTL
- `SCRIPTS/` – Python and TCL automation tools

---

## 🛠️ Prerequisites

- Cadence Genus (for synthesis)
- Cadence Innovus (for physical implementation)
- Bash + TCL environment
- Python 3.x (for automation, if scripts are provided)
- Design kits (PDKs, standard cell libraries, I/Os) must be set up and accessible via `$PDK_PATH`

---

## ⚙️ Quick Start Options

### 🚀 Option 1: Load Pre-Generated Database and Results (Recommended)

If you just want to **view the design** or **analyze power and rail metrics**:

1. Open Innovus from the `dummy` folder:

   ```bash
   cd dummy
   innovus -stylus
   ```

2. Load the saved database:

   ```tcl
   read_db ../phy/db/fabric.dat
   ```

3. You can now:
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

#### 1. Synthesize the Design (Optional)

```bash
cd exe
./genus_topdown.sh
```

> Skip this step if using the pre-generated `fabric.v` netlist and `constraints.sdc`.

#### 2. Generate Floorplanning Script

```bash
cd ../SCRIPTS
python3 flat.py
python3 pads_script_flat.py  # Optional, for power rail analysis
```

#### 3. Launch Innovus and Prepare Floorplan

```bash
cd ../dummy
innovus -stylus
```

Inside Innovus, run:

```tcl
source ../phy/scr/read_design.tcl
source ../phy/scr/floorplan.tcl
source ../phy/scr/power_planning.tcl
source ../phy/scr/general_flow.tcl
```

#### 4. Power Rail Analysis

```tcl
source ../SCRIPTS/power_rail_analysis.tcl
```

#### 5. Area Parametric Extraction

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

- You can skip all backend steps by restoring `db/fabric.dat`.
- Power and rail analysis data is located in the `dummy/` subfolders.
- `.keep` files are included in empty folders so they appear in Git.

---

## 📩 Contact

**Davide Finazzi**  
📧 finazzi.davide01@outlook.it  
🔗 https://github.com/davidepanzino
