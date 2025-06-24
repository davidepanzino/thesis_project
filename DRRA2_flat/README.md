# DRRA2 Flat Integration

This repository contains the full design environment and scripts for flat floorplanning, power planning, and backend automation of a DRRA2-based architecture using the SiLago framework.

---

## 📁 Folder Structure

- `rtl/` – RTL source files (SystemVerilog)
- `syn/` – Synthesis scripts and constraints (e.g., Genus)
- `phy/`
  - `scr/` – Floorplanning, power planning, P&R TCL scripts (Innovus)
  - `db/` – Design databases (left empty)
  - `rpt/` – Reports and metrics (left empty)
- `dummy/` – Folder from which to run Cadence Innovus
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

## ⚙️ Full Design Flow

### 1. Clone the Repository

```bash
git clone https://github.com/davidepanzino/thesis_project.git
cd thesis_project
```

---

### 2. Synthesize the Design (Optional)

Move into the synthesis folder and run the synthesis script:

```bash
cd exe
./genus_topdown.sh
```

**Note**: This step can be skipped if you use the pre-generated `fabric.v` netlist and `constraints.sdc` file already present in the repository. Only run this if you're working with a modified design and need to re-synthesize it. 

---

### 3. Generate Floorplanning Script

Before running the automation:
- Ensure your synthesized netlist is named `fabric.v`(if not, rename it)
- Ensure your constraint file is named `constraints.sdc`(if not, rename it)

Then, from the `SCRIPTS` folder:

```bash
cd ../SCRIPTS
python3 flat.py
python3 pads_script_flat.py  # Optional, for power rail analysis
```

These scripts will automatically generate the TCL files used for floorplanning. The power planning script is fixed for this particular design.

---

### 4. Launch Innovus and Prepare Floorplan

Start Innovus from the `dummy` folder:

```bash
cd ../dummy
innovus -stylus
```

Inside Innovus, source the following scripts in order:

```tcl
source ../phy/scr/read_design.tcl
source ../phy/scr/floorplan.tcl
source ../phy/scr/power_planning.tcl
source ../phy/scr/general_flow.tcl
```

### 5. Power Rail Analysis

Run:

```tcl
source ../SCRIPTS/power_rail_analysis.tcl
```

This performs the early rail analysis using probe data and pad locations.

---

### 6. Area Parametric Extraction

From the same Innovus session, run:

```tcl
source ../SCRIPTS/normal_wires_data.tcl
source ../SCRIPTS/pg_wires_data.tcl
```

The extracted values can then be post-processed using the Python script:

```bash
cd ../SCRIPTS
python3 grid_area.py
```

This provides routing area statistics for normal and power wires.

---

## 📝 Notes

- Folders `dummy/`, `phy/db/` and `phy/rpt/` are empty by default and will be populated during execution.
- `.keep` files are included in empty folders so they appear in Git.

---

## 📩 Contact

**Davide Finazzi**  
📧 finazzi.davide01@outlook.it 
🔗 https://github.com/davidepanzino

