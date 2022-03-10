#!/bin/bash

# Only execute as root
if [[ "${UID}" -ne 0 ]]
then 
	echo 'Can only be run as root'
	exit 1
fi

# Input username, name, and initial password
USER_NAME_MAX_LENGTH=8
read -p 'Select username (no more than 8 characters): ' USER_NAME
read -p 'What is your name: ' NAME
read -p 'Select initial password: ' PASSWORD

# Check that username is not tool long
if [[ ${#USER_NAME} > ${USER_NAME_MAX_LENGTH} ]]
then
	echo 'Too long username'
	exit 1
fi

# Create a user with home directory
useradd -c "${NAME}" -m ${USER_NAME}

# Inform user if not successfull creation
if [[ ${?} != 0 ]]
then
	echo 'Account creation failed'
	exit 1
fi 

# Set password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Force password change
passwd -e ${USER_NAME}

if [[ ${?} != 0 ]]
then
	echo 'Failed while setting password'
	exit 1
fi

# Print out information
echo '----------------------------------------'
echo 'Account creation successful'
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Created by host: $(hostname)"
echo '----------------------------------------'




