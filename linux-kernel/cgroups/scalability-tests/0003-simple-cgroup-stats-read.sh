#!/bin/bash

source utils.sh

ITERATIONS=1000

function read_controller_stats() {
	controller_file="$1"
	i=1
	while [ "$i" -le "$ITERATIONS" ]
	do
		cat "$controller_file" &>  /dev/null
		i=$(( i + 1 ))
	done
}

#Read cpu.stat
cpu_controller=$(find_controller_mount_point "cpu")
echo -n "Time to read $cpu_controller/cpu.stat a $ITERATIONS times"
time read_controller_stats "$cpu_controller/cpu.stat"

#Read memory.stat
memory_controller=$(find_controller_mount_point "memory")
echo -n "Time to read $memory_controller/memory.stat a $ITERATIONS times"
time read_controller_stats "$memory_controller/memory.stat"

#Read cpu.stat + memory.stat
echo -n "Time to read $cpu_controller/cpu.stat and $memory_controller/memory.stat a $ITERATIONS times"
time read_controller_stats "$cpu_controller/cpu.stat $memory_controller/memory.stat"

exit 0
