#!/bin/bash

# In this script we demonstrate functions

# Function without arguments
log(){
	echo 'You called the log function'
}

log

# Another syntax
function log1 {
	echo 'You have again called the log function'
}

log1


log2(){
	# This function sends a message to syslog and to standard output if VERBOSE is true	

	# Local variable, can only be used inside a function
	local MESSAGE="${@}"

	if [[ "${VERBOSE}" == "true" ]]
	then
		echo "${MESSAGE}"
	fi

	# Also logg the message to the system log file
	logger -t luser-demo10.sh "${MESSAGE}"
}


backup_file() {
  # This function creates a backup of a file. Returns non-zero status on error.

  local FILE="${1}"
	
  # Ensure that the file exists
  if [[ -f "${FILE}" ]]
    then 
	local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"    
	log2 "Backing up ${FILE} to ${BACKUP_FILE}."

	cp -p ${FILE} ${BACKUP_FILE}
  else
	# The file does not exist so return 1
	log2 "The file ${FILE} does not exist"
	return 1
  fi
}

log2 'Hello'

# Makes it read only (constant)
readonly VERBOSE="true"

log2 'This is fun'

backup_file '/etc/passwd'

# Make a decision based on the exit code of the funciton

if [[ "${?}" == '0' ]]
then 
  log2 'File backup success'
else
  log2 'File backup failed'
fi
