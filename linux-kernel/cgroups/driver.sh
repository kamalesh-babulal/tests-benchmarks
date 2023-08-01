#!/bin/bash

source utils.sh

print_env

echo "" #print an empty line

for testcase in 0*.sh
do
	echo "==========================================================="
	echo " Executing $testcase"
	echo "==========================================================="
	./"$testcase"
done

exit 0
