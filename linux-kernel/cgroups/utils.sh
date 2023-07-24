#!/bin/bash

function find_controller_mount_point() {
	if [ "$1" == "cpu" ]; then
		mount_point=$(grep "cgroup" /proc/mounts|grep "$1"|grep -v cpuset|awk '{print $2}')
	else
		mount_point=$(grep "cgroup" /proc/mounts|grep "$1"|awk '{print $2}')
	fi

	if [ -z "$mount_point" ]; then
		mount_point=$(grep "cgroup2" /proc/mounts|grep "$1"|awk '{print $2}')
	fi

	if [ -z "$mount_point" ]; then
		echo "Invalid cgroup setup or controller $1 not found"
		return
	fi

	base_name=$(basename "$mount_point")
	if [[ "$base_name" == "$1" ]] || [[ "$base_name" =~ ^"$1," ]] || [[ "$base_name" =~ ",$1"$ ]]; then
		echo "$mount_point"
		return
	fi

	echo "Invalid cgroup setup or controller $1 not found"
	return
}
