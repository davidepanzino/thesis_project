# DRRA2 Physical Design Flows – Hierarchical & Flat

This repository hosts two complete physical design flows for the **Dynamically Reconfigurable Resource Array (DRRA)** architecture, part of the SiLago framework. Both flows target backend implementation using Cadence Genus and Innovus, and differ by the integration style:

- [`DRRA2_hierarchical/`](./DRRA2_hierarchical) — Partitioned, slot-based hierarchical backend design
- [`DRRA2_flat/`](./DRRA2_flat) — Fully flat backend integration without partitioning

Each flow includes RTL, synthesis and place-and-route scripts, as well as automation tools in Python and TCL.

---

## 📁 Repository Structure

```
thesis_project/
├── DRRA2_hierarchical/      # Hierarchical integration flow
│   ├── rtl/                 # RTL source files
│   ├── exe/                 # Folder in which to run Genus
│   ├── syn/                 # Synthesized netlist and constraints as well as Genus scripts
│   ├── phy/                 # Innovus physical design scripts and outputs
│   ├── dummy/               # Launch folder for Innovus sessions
│   ├── SCRIPTS/             # Automation scripts (Python + TCL)
│   └── README.md            # Flow documentation
│
├── DRRA2_flat/              # Flat integration flow
│   ├── (same structure as above)
│   └── README.md
│
└── README.md                # (this file)
```

---

## 🔧 Requirements

- Cadence Genus (for RTL synthesis)
- Cadence Innovus (for physical implementation)
- Python 3.x
- Bash, TCL environment
- Technology libraries and design kits (PDK, LEF/DEF, I/O libraries)

---

## 📘 Getting Started

Each flow is self-contained with its own README:
- For **hierarchical design**, follow [`DRRA2_hierarchical/README.md`](./DRRA2_hierarchical/README.md)
- For **flat design**, follow [`DRRA2_flat/README.md`](./DRRA2_flat/README.md)

Both guides provide step-by-step instructions for:
- RTL synthesis
- Floorplan and power planning generation
- Place-and-route execution
- Power rail analysis
- Area reporting

---


## 📩 Contact

**Davide Finazzi**  
📧 finazzi.davide01@outlook.it  
🔗 [github.com/davidepanzino](https://github.com/davidepanzino)
