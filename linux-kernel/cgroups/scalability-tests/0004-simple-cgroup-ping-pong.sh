#!/bin/bash

source ../utils.sh

ITERATIONS=1000

function die() {
	echo "$*" 1>&2
	exit 1
}

cpu_controller=$(find_controller_mount_point "cpu")
# create source and destination directories
mkdir "$cpu_controller/ping-pong-1" || die "Failed to create $cpu_controller/ping-pong-1"
mkdir "$cpu_controller/ping-pong-2" || die "Failed to create $cpu_controller/ping-pong-2"

pid="$$"
i=1

while [ "$i" -le "$ITERATIONS" ]
do
	echo "$pid" > "$cpu_controller/ping-pong-1/cgroup.procs"
	echo "$pid" > "$cpu_controller/ping-pong-2/cgroup.procs"
	i=$(( i + 1 ))
done

# move the pid to parent directory, so avoid rmdir failure
echo "$pid" > "$cpu_controller/cgroup.procs"
rmdir "$cpu_controller/ping-pong-1" || die "Failed to delete $cpu_controller/ping-pong-1"
rmdir "$cpu_controller/ping-pong-2" || die "Failed to delete $cpu_controller/ping-pong-2"

exit 0
