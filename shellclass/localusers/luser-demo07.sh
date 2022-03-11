#!/bin/bash

# Demonstrate the use of shift and while loops

# Display the first three parameters
echo "Parameter 1: ${1}"
echo "Parameter 2: ${2}"
echo "Parameter 3: ${3}"
echo

# Loop through all the position arguments with a while loop
while [[ "${#}" > 0 ]]
do
	echo "Number of parameters: ${#}"
	echo "${1}"
	shift
done

