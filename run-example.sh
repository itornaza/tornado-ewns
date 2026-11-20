#!/usr/bin/env bash
# Replay a saved input file through the 2007 program in GNU Octave.
#
#   ./run-example.sh examples/reference-network.txt         # print results only
#   ./run-example.sh examples/jam-first-link12.txt out.png  # also save the 2 x 2 plot
#
# The input file holds exactly what a user would type at the prompts, one value per line.
set -euo pipefail
input="$(realpath "${1:?usage: $0 <input-file> [plot.png]}")"
png="${2:+$(realpath -m "$2")}"
cd "$(dirname "$0")"
# Run headless: no display, so Octave draws with gnuplot and the plot is written to a file.
EWNS_PNG="$png" DISPLAY= octave-cli --no-gui --quiet --eval "
  warning('off', 'Octave:gnuplot-graphics'); warning('off', 'Octave:fltk-graphics');
  graphics_toolkit('gnuplot');
  set(0, 'defaultfigurevisible', 'off');
  addpath('src');
  tornadoEWNS;
  png = getenv('EWNS_PNG');
  if ~isempty(png) && ~isempty(get(0, 'children'))
    print(png, '-dpng', '-S1100,800');
    fprintf('Plot saved to %s\n', png);
  end
" < "$input"
