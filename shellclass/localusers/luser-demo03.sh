#!/bin/bash

# Display the UID and username of the user execuing the script, and if they are vagrant users or not.

# Display the UID
echo "Your UID is ${UID}"

# Only display if the UID does not match 1000
UID_TO_TEST_FOR='1000'

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then 
	echo "Your UID does not match ${UID_TO_TEST_FOR}"
	exit 1
fi


# Display the username
USER_NAME=$(id -un)
echo "Your username is ${USER_NAME}"

# Test if the command succeeded
# ${?} contains status code for the last command

if [[ "${?}" -ne 0 ]]
then
	echo "The id command did not execute successfully"
	exit 1
fi 


# Use a string test conditional
USER_NAME_TO_TEST_FOR='vagrant'
if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
	echo "Your username matches our test"
fi


# Test for != for the string
if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
	echo "Your username does not match our test"
	exit 1
fi

exit 0

