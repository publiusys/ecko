#!/bin/bash

# to run: ./perfsensor.sh loop

currdate=$(date +%m%d%Y%H%M%S)

function orig()
{
    perf stat -a -e power/energy-pkg/ -x, -I 1000
}

function loop()
{
    perf stat -a -e instructions,cache-misses,ref-cycles,power/energy-pkg/,power/energy-ram/ -x, -I 1000 -o "perf.${currdate}.log"
}

$@
