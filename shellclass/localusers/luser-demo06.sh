#!/bin/bash

# This script generates a random password for ach user specified on the command line

# A parameter is a variable that is being used inside the shellscript 
# An argument is the data passed into the script

# Display what the user typed on the command line
echo "You executed this command ${0}"


# Display the path and file name of the script
echo "You used $(dirname ${0}) as the path to $(basename ${0}) script"

# Tell the user how many arguments they passed in
echo "You passed in ${#} arguments to the script"

# Make sure that atleast one user is provided on the command line
if [[ "${#}" < 1 ]]
then
	echo "Usage: ${0} USER_NAME [USER_NAME]..."
	exit 1
fi


# Generate and display a password for each parameter
# ${@} is a list of all positional arguments

for USER_NAME in "${@}"
do
	PASSWORD=$(date +%s%N | sha256sum | head -c48)
	echo "${USER_NAME}: ${PASSWORD}"
done

