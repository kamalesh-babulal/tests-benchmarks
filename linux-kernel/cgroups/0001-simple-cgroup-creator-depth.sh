#!/bin/bash

source utils.sh

ITERATIONS=1000

last_dir=""
function die() {
	echo "$*" 1>&2
	exit 1
}

function create_cgroups() {
	cpu_controller="$1"
	cd "$cpu_controller" || die "Failed to change dir $cpu_controller"
	for cgrp in $(seq 1 "$ITERATIONS")
	do
		mkdir "$cgrp" || die "Failed to create dir $cgrp"
		cd "$cgrp" || die "Failed to create dir $cgrp"
		last_dir=$(pwd)
	done
}

function delete_cgroups() {
	cpu_controller="$1"
	cgrp="$last_dir"

	while [ "$cgrp" != "$cpu_controller" ]
	do
		parent=$(dirname "$cgrp")
		cd "$parent" || die "Failed to change dir $parent"
		rmdir "$cgrp" || die "Failed to delete dir $cgrp"
		cgrp="$parent"
	done
}

cpu_controller=$(find_controller_mount_point "cpu")
echo -n "Time to create $ITERATIONS directories in depth"
time create_cgroups "$cpu_controller"

sleep 1

echo -n "Time to delete $ITERATIONS directories in depth"
time delete_cgroups "$cpu_controller"

exit 0
