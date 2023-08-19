#!/bin/bash

function print_processors() {
	processors=$(grep -c processor /proc/cpuinfo)
	echo -e "Number of cpus\t\t: $processors"
}

function print_memory() {
	phy_mem=$(free -g|grep -iv total|head -n1|awk   '{print $1" "$2}')
	swap_mem=$(free -g|grep -iv total|grep -iv ^mem|head -n1|awk   '{print $1" "$2}')
	echo -e "Memory\t\t\t: $phy_mem $swap_mem"
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
	print_memory
}

function find_controller_mount_point() {
	cgroupv2=0
	if [ "$1" == "cpu" ]; then
		mount_point=$(grep "cgroup" /proc/mounts|grep "$1"|grep -v cpuset|awk '{print $2}')
	else
		mount_point=$(grep "cgroup" /proc/mounts|grep "$1"|awk '{print $2}')
	fi

	if [ -z "$mount_point" ]; then
		mount_point=$(grep "cgroup2" /proc/mounts|awk '{print $2}')
		cgroupv2=1
	fi

	if [ -z "$mount_point" ]; then
		echo "Invalid cgroup setup or controller $1 not found"
		return
	fi

	base_name=$(basename "$mount_point")
	if [[ "$base_name" == "$1" ]] || [[ "$base_name" =~ ^"$1," ]] || [[ "$base_name" =~ ",$1"$ ]] || [[ "$cgroupv2" -eq 1 ]]; then
		echo "$mount_point"
		return
	fi

	echo "Invalid cgroup setup or controller $1 not found"
	return
}

function is_unified() {
        mode=$(cgget -m)

	if [[ "$mode" = Unified* ]]; then
                echo "1"
        else
                echo "0"
        fi
}

function is_hybrid() {
        mode=$(cgget -m)

        if [[ "$mode" = Hybrid* ]]; then
                echo "1"
        else
                echo "0"
        fi
}

function is_legacy() {
        mode=$(cgget -m)

        if [[ "$mode" = Legacy* ]]; then
                echo "1"
        else
                echo "0"
        fi
}
