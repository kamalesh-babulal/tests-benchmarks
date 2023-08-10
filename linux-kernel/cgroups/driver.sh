#!/bin/bash

source utils.sh

print_env

echo "" #print an empty line

function execute_tests()
{
	echo "====> Executing $1 <===="
	pushd "$1" &> /dev/null || exit 1

	for testcase in 0*.sh
	do
		echo "==========================================================="
		echo " Executing $testcase"
		echo "==========================================================="
#	./"$testcase"
	done
	popd &> /dev/null || exit 1
}

execute_tests "scalability-tests"

exit 0
