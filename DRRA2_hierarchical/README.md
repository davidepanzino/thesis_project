# DRRA2 Hierarchical Integration

This repository contains the full design environment and scripts for hierarchical floorplanning, power planning, and backend automation of a DRRA2-based architecture using the SiLago framework.

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

### 1. Synthesize the Design (Optional)

Move into the synthesis folder and run the synthesis script:

```bash
cd exe
./genus_topdown.sh
```

**Note**: This step can be skipped if you use the pre-generated `fabric.v` netlist and `constraints.sdc` file already present in the repository. Only run this if you're working with a modified design and need to re-synthesize it. 

---

### 2. Generate Floorplanning, Power, and Pin Constraint Scripts

Before running the automation:
- Ensure your synthesized netlist is named `fabric.v`(if not, rename it)
- Ensure your constraint file is named `constraints.sdc`(if not, rename it)

Then, from the `SCRIPTS` folder:

```bash
cd ../SCRIPTS
python3 generate_drra2_tcl.py
python3 pads_script.py  # Optional, for power rail analysis
```

These scripts will automatically generate the TCL files used for floorplanning, pin placement, partitioning, and power planning.

---

### 3. Launch Innovus and Prepare Floorplan

Start Innovus from the `dummy` folder:

```bash
cd ../dummy
innovus -stylus
```

Inside Innovus, source the following scripts in order:

```tcl
source ../phy/scr/read_design.tcl
source ../phy/scr/floorplan.tcl
source ../phy/scr/partition.tcl
```

At this stage, partitions are committed.  
👉 **Now close Innovus.**

---

### 4. Run Partitioned Place-and-Route

From the `dummy` folder, you have two options:

- To run **in parallel** (faster, requires more licenses and memory):

  ```bash
  ./launch_all_partitions_parallel.sh
  ```

- To run **sequentially** (slower, but lower resource usage):

  ```bash
  ./launch_all_partitions.sh
  ```

This step will perform placement, CTS, and routing for each partition.

---

### 5. Perform Top-Level P&R

After all partitions have completed, reopen Innovus from `dummy`:

```bash
innovus -stylus
```

Then run:

```tcl
source ../phy/scr/pnr_top.tcl
```

This performs top-level place-and-route for the overall design.

---

### 6. Final Assembly

Finally, in a **new** Innovus session:

```bash
innovus -stylus
```

Then run:

```tcl
source ../phy/scr/assembly_design.tcl
```

This script assembles all partitions and top-level logic into the final hierarchical layout, ready for power analysis.


---

### 7. Power Rail Analysis

Open Innovus from the `dummy` folder and run:

```tcl
source ../SCRIPTS/power_rail_analysis.tcl
```

This performs the early rail analysis using probe data and pad locations.

---

### 8. Area Parametric Extraction

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

- Folders `phy/db/` and `phy/rpt/` are empty by default and will be populated during execution.
- `.keep` files are included in empty folders so they appear in Git.

---

## 📩 Contact

**Davide Finazzi**  
📧 finazzi.davide01@outlook.it 
🔗 https://github.com/davidepanzino
