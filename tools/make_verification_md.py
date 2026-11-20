#!/usr/bin/env python3
"""Regenerate docs/verification.md: 2007 MATLAB value vs Octave replay value for every printed result."""
import os, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from verify import RUNS, KEYS, replay, expected

version = subprocess.run(["octave-cli", "--version"], capture_output=True, text=True).stdout.split("\n")[0]
out = ["# Verification record", "",
       "Every saved run in `examples/` was replayed through the 2007 sources with",
       f"{version} (`python3 tools/verify.py`) and compared with the output of the original",
       "2007 MATLAB runs (`examples/expected/`). Each cell shows the 2007 value; a mismatch",
       "would show the replay value next to it.", ""]
total = bad = 0
body = []
for name in RUNS:
    exp = expected(name)
    _, got = replay(name)
    assert len(exp) == len(got), name
    inp = open(os.path.join(ROOT, "examples", name + ".txt")).read().split()
    if name == "reference-network":
        body += ["## Reference network (no jamming)", ""]; col = "Step"; labels = ["initial"]
    elif name.startswith("jam"):
        seq, k = [], 40          # 37 configuration values, then menu "2", plot "y", jammed "y"
        while k + 1 < len(inp):
            seq.append(f"Link{inp[k]}{inp[k+1]}"); k += 3
        body += [f"## Jamming run, Link{name[-2:]} cut first", "",
                 f"Cut order: {', '.join(seq)}. The program refuses to cut the last remaining link.", ""]
        col = "Links cut"; labels = [str(i) for i in range(len(exp))]
    else:
        body += ["## Capability of node 1 (Global Hawk) reduced from 0.8 to 0", ""]
        col = "Capability of node 1"; labels = ["0.8", "0.7", "0.6", "0.5", "0.4", "0.3", "0.2", "0.1", "0"]
    body += [f"| {col} | CRM | Reach | Reach (rerouting) | Richness | Char. tempo | Op. tempo | Match |",
             "|---|---|---|---|---|---|---|---|"]
    for lab, e, g in zip(labels, exp, got):
        ok = all(e[k] == g[k] for k in KEYS); total += 6; bad += sum(e[k] != g[k] for k in KEYS)
        body.append(f"| {lab} | " + " | ".join(e[k] if e[k] == g[k] else f"{e[k]} (replay {g[k]})" for k in KEYS)
                    + f" | {'yes' if ok else 'NO'} |")
    body.append("")
summary = (f"**All {total} printed values match exactly, to the 6 decimals the program prints.**" if bad == 0
           else f"**{bad} of {total} printed values differ.**")
open(os.path.join(ROOT, "docs/verification.md"), "w").write("\n".join(out + [summary, ""] + body))
print(summary)
