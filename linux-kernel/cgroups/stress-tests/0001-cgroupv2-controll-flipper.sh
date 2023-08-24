#!/bin/bash

source ../utils.sh

ITERATIONS=100000

last_dir=""
function die() {
	echo "$*" 1>&2
	exit 1
}

ret=$(is_unified)
[ "$ret" -ne 1 ] && die "Expected cgroup v2 setup"

cpu_controller=$(find_controller_mount_point "cpu")
cd "$cpu_controller" || die "Failed to change dir $cpu_controller"
mkdir "stress" || die "Failed to create dir stress"

for i in $(seq 1 "$ITERATIONS")
do
	echo "-cpu" > stress/cgroup.subtree_control
	echo "+cpu" > stress/cgroup.subtree_control
done

rmdir "stress" || die "Failed to remove dir stress"
exit 0
