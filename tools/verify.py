#!/usr/bin/env python3
"""Replay every saved run in examples/ through the 2007 sources in GNU Octave
and compare each printed result with the output recorded from the original 2007 MATLAB runs
(examples/expected/*.json).

Needs: python3, octave-cli, gnuplot.
Usage:  python3 tools/verify.py [--plots DIR]
"""
import json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

RUNS = ["reference-network"] + [f"jam-first-link{l}" for l in
        ("12", "13", "21", "23", "31", "32", "34", "41", "43")] + ["capability-node1"]
KEYS = ["crm", "reach", "reach_rr", "richness", "char_tempo", "op_tempo"]
RESULT = re.compile(r"^\|(.+?) is:\s+(-?[\d.]+)\|$")
NAMES = {"Reference Connectivity Measure": "crm", "Network Reach": "reach",
         "Network Reach with rerouting option": "reach_rr", "Network Richness": "richness",
         "Network Characteristic Tempo": "char_tempo", "Network Operational Tempo": "op_tempo"}

def boxes(text):
    """Collect the six-value result boxes the program prints, in order."""
    out, cur = [], {}
    for line in text.splitlines():
        m = RESULT.match(line.strip())
        if m:
            cur[NAMES[m.group(1).strip()]] = m.group(2)
            if len(cur) == 6:
                out.append(cur); cur = {}
    return out

def replay(name, png=""):
    args = [os.path.join(ROOT, "run-example.sh"), os.path.join(ROOT, "examples", name + ".txt")]
    if png:
        args.append(png)
    run = subprocess.run(args, capture_output=True, text=True)
    return run.returncode, boxes(run.stdout)

def expected(name):
    with open(os.path.join(ROOT, "examples", "expected", name + ".json")) as f:
        return json.load(f)

def main():
    plots = sys.argv[2] if len(sys.argv) > 2 and sys.argv[1] == "--plots" else ""
    total = bad = 0
    for name in RUNS:
        exp = expected(name)
        rc, got = replay(name, os.path.join(plots, name + ".png") if plots else "")
        print(f"{name}: expected {len(exp)} result boxes, replay {len(got)}")
        if len(got) != len(exp) or rc != 0:
            bad += 1
        for i, (e, g) in enumerate(zip(exp, got)):
            for k in KEYS:
                total += 1
                if e[k] != g[k]:
                    bad += 1
                    print(f"  step {i} {k}: expected {e[k]} replay {g[k]}  MISMATCH")
    print(f"\n{total} printed values compared, {bad} problems")
    sys.exit(1 if bad else 0)

if __name__ == "__main__":
    main()
