#!/bin/bash

# This script creates an account onm the local system
# You will be prompted for the account name and password


# Ask for user name
read -p 'Choose a username: ' USER_NAME

# Ask for the real name 
read -p 'What is your name: ' NAME

# Ask for password
read -p 'Choose a pasword: ' PASSWORD

# Create the user 
useradd -c "${NAME}" -m ${USER_NAME}

# Set password for the user
# By first echoing out the password, and then piping it, it is sent as 
# standard input to the next command
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Force that user to change password on login
passwd -e ${USER_NAME}
