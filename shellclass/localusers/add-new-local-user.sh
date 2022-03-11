#!/bin/bash

# This script creates a local user with random password


# Check root user
if [[ "${UID}" != 0 ]]
then 
	echo 'Must be run as root'
	exit 1
fi

# Provide usage statement if no username
if [[ ${#} == 0 ]]
then
	echo 'Usage: ${0} USER_NAME [COMMENT]...'
	exit 1
fi


# User account information0
USER_NAME="${1}"
shift
COMMENT="${*}"
PASSWORD=$(date +%s%N | sha256sum | head -c32)


# Create user
sudo useradd -c "${COMMENT}" -m ${USER_NAME}


# Give feedback if failed
if [[ "${?}" != 0 ]]
then
	echo 'User creation failed'
	exit 1
fi

# Add random password
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

if [[ "${?}" != 0 ]]
then 
	echo "Failed while setting password for ${USER_NAME}"
	exit 1
fi

# Expire password

passwd -e ${USER_NAME}

if [[ "${?}" != 0 ]]
then
	echo "Failed while expiring password for ${USER_NAME}"
	exit 1
fi


# Display user information
echo '------------------------------------'
echo 'User creation completed'
echo "Host: ${HOSTNAME}"
echo "User name: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo '------------------------------------'
exit 0



