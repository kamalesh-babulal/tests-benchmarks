#!/bin/bash

function print_processors() {
	processors=$(grep -c processor /proc/cpuinfo)
	echo -e "Number of cpus\t\t: $processors"
}

function print_os() {
	os_id=$(grep ^"ID=" /etc/os-release|cut -d "=" -f2)
	os_version_id=$(grep ^"VERSION_ID=" /etc/os-release|cut -d "=" -f2)
	echo -e "Operating System\t: $os_id ($os_version_id)"
}

function print_cgroup_setup() {
	cgroup_setup_mode=$(cgget -m)
	echo -en "cgroup_setup mode\t: "
	if [ -z "$cgroup_setup_mode" ]; then
		echo "Missing libcgroup package or cgget missing -m support"
	else
		echo "$cgroup_setup_mode"
	fi
}

function print_env() {
	echo "*************************************************"
	echo "*               System Environment              *"
	echo -e "*************************************************\n"
	print_os
	print_processors
	print_cgroup_setup
}

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
