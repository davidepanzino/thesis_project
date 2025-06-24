from collections import defaultdict

# File paths for PG
pg_area_file = "../dummy/area_pg_list.txt"
pg_layer_file = "../dummy/layer_pg_list.txt"
pg_net_file = "../dummy/net_pg_list.txt"

# File paths for Signal Wires
sig_area_file = "../dummy/area_list.txt"
sig_layer_file = "../dummy/layer_list.txt"

# === Parse PG net data (area already in µm²) ===
vdd_layer_areas = defaultdict(float)
vss_layer_areas = defaultdict(float)

with open(pg_area_file) as af, open(pg_layer_file) as lf, open(pg_net_file) as nf:
    area_lines = [float(line.strip()) for line in af if line.strip()]
    layer_lines = [line.strip().split(":")[-1] for line in lf if line.strip()]
    net_lines = [line.strip().split("/")[-1] for line in nf if line.strip()]

if not (len(area_lines) == len(layer_lines) == len(net_lines)):
    raise ValueError("PG files must have the same number of lines")

for area, layer, net in zip(area_lines, layer_lines, net_lines):
    if net == "VDD":
        vdd_layer_areas[layer] += area
    elif net == "VSS":
        vss_layer_areas[layer] += area

# === Parse Signal net data (area is bounding box: x1 y1 x2 y2) ===
sig_layer_areas = defaultdict(float)

with open(sig_layer_file, "r") as lf:
    sig_layers = [line.strip().split(":")[1] for line in lf if line.strip()]

with open(sig_area_file, "r") as af:
    area_rects = [list(map(float, line.strip("{} \n").split())) for line in af if line.strip()]

if len(sig_layers) != len(area_rects):
    raise ValueError("Signal area and layer files must have the same number of entries")

for layer, (x1, y1, x2, y2) in zip(sig_layers, area_rects):
    width = abs(x2 - x1)
    height = abs(y2 - y1)
    area = width * height
    sig_layer_areas[layer] += area

# === Combine and print ===
print("=== Metal Area Breakdown by Layer ===")
header = f"{'Layer':<6} {'VDD Area (µm²)':>15} {'VSS Area (µm²)':>15} {'Signal Area (µm²)':>20} {'Total Area (µm²)':>20} {'PG % of Total':>15}"
print(header)
print("-" * len(header))

all_layers = sorted(set(sig_layer_areas) | set(vdd_layer_areas) | set(vss_layer_areas))

total_vdd = total_vss = total_sig = 0.0

for layer in all_layers:
    vdd = vdd_layer_areas.get(layer, 0.0)
    vss = vss_layer_areas.get(layer, 0.0)
    sig = sig_layer_areas.get(layer, 0.0)
    total = vdd + vss + sig
    pg_total = vdd + vss
    pg_ratio = (pg_total / total) * 100 if total > 0 else 0.0

    print(f"{layer:<6} {vdd:15.2f} {vss:15.2f} {sig:20.2f} {total:20.2f} {pg_ratio:15.2f}%")

    total_vdd += vdd
    total_vss += vss
    total_sig += sig

# === Summary ===
total_pg = total_vdd + total_vss
total_area = total_pg + total_sig
total_pg_percent = (total_pg / total_area) * 100 if total_area > 0 else 0.0

print("\n=== Summary Totals ===")
print(f"Total VDD Area:     {total_vdd:.2f} µm²")
print(f"Total VSS Area:     {total_vss:.2f} µm²")
print(f"Total PG Area:      {total_pg:.2f} µm²")
print(f"Total Signal Area:  {total_sig:.2f} µm²")
print(f"Combined Total:     {total_area:.2f} µm²")
print(f"Overall PG Ratio:   {total_pg_percent:.2f}%")

