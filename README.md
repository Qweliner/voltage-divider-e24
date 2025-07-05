# Voltage Divider Calculator (E24 Series)

MATLAB (R2015+) console‑based tool to select two resistors from the E24 series  
such that  
\`\`\`  
Vout = Vin * (R2 / (R1 + R2))  
\`\`\`  
matches a desired output voltage within minimal error.

## Features

- Reads E24 resistor base values from `e24.txt` (also supports Cyrillic filename `е24.txt`).
- Prefers resistors ≥ 10 Ω (falls back to smaller values if needed).
- Fully console-based: run with F5 in MATLAB, enter Vin and Vout, get results immediately.
- Formats output in Ω, kΩ, MΩ automatically.

## Files

- **voltage_divider_calc.m** — Main script (press F5 to run).  
- **find_best_pair.m** — Helper function that brute‑forces best R1/R2 pair.  
- **e24.txt** — Base E24 values (space‑separated on one line).  
- **LICENSE** — MIT License text.

## Installation & Usage

1. Clone or download this repository.  
2. Ensure MATLAB ≥ 2015 is installed.  
3. Place all files in the same folder.  
4. Open `voltage_divider_calc.m` in MATLAB and press **F5**.  
5. Enter **Vin** and **Vout** when prompted.  
6. Enjoy your resistor pair and achieved Vout!

```bash
git clone https://github.com/<your‑username>/voltage-divider-e24.git
cd voltage-divider-e24
# Open in MATLAB, then F5
