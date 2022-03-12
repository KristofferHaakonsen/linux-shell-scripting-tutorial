#!/bin/bash

# This scripts deletes local users

log() {
  # Logs the actions, displays if verbose
  local MESSAGE="${0}	${@}"
  if [[ "${VERBOSE}" == 'true' ]]
    then
	echo "${MESSAGE}"
  fi
  logger "${MESSAGE}"

}

usage() {
  # Prints usage information
  echo "${0} [options] USER_NAME..." >&2
  echo 'Disables user local accounts' >&2
  echo '-d	Deletes the accounts instead of disabling them' >&2
  echo '-r	Removes the home directory of the accounts' >&2
  echo '-a	Stores the home directory of the accounts in the /archives directory' >&2
  echo '-v	Enables more verbose settings' >&2
  exit 1
}

check_last_status() {
  # Checks  the status of the last command.
  # If failed, logs first argument and exit with status 1
  # If success, logs second argument
  if [[ "${?}" != 0 ]]
    then
      log "${1}"
      exit 1
    else
      log "${2}"
  fi
}


# Ensure superuser
if [[ "${UID}" != 0 ]]
  then
    usage
fi

# Check the options
while getopts adrv OPTION
  do
    case ${OPTION} in
      v)
	readonly VERBOSE='true'
        log 'Verbose mode'
      ;;
      d)
	readonly DELETE_USER='true'
        log 'Delete mode'
      ;;
      r)
	readonly REMOVE_HOME_DIR='-R'
        log 'Remove home directory mode'
      ;;
      a)
	readonly ARCHIVE='true'
        log 'Arcive mode'
      ;;
      *)
	usage
      ;;
  esac
done


# Remove options
shift "$(( OPTIND-1 ))"

# Ensure at least one user
if [[ "${#}" < 1 ]]
  then
    usage
fi


# Loop through all names
while [[ "${#}" > 0 ]]
 do

  # Gather username and userid and check if real user
  USER_NAME="${1}"
  USER_ID=$(id "${USER_NAME}" -u 2> /dev/null )

  if [[ ${?} != 0 ]]
    then 
      log "Not a valid user: ${USER_NAME}"
      usage
  fi

  # Check if username is less than 1000
  if [[ ${USER_ID} < 1000 ]]
    then
      log "Failed, will not delete system account: ${USER_NAME}"
      exit 1
  fi

  # Create archive
  if [[ "${ARCHIVE}" == 'true' ]]
    then
        mkdir "/archives" -p
        tar -cz -f "/archives/${USER_ID}${USER_NAME}-BACKUP.tar.gz" "/home/${USER_NAME}" 2> /dev/null
        check_last_status "Archiving failed: ${USER_NAME}" "Archiving success: ${USER_NAME}"
  fi

  # Disable or delete account
  if [[ "${DELETE_USER}" == 'true' ]]
    then
      userdel ${REMOVE_HOME_DIR} "${USER_NAME}" 2> /dev/null
      check_last_status "Failed while deleting: ${USER_NAME}" "Successfully deleted: ${USER_NAME}"
    else
    chage -E 0 "${USER_NAME}" 2> /dev/null
    check_last_status "Failed while suspending: ${USER_NAME}" "Successfully suspended: ${USER_NAME}"
  fi

  shift
done

exit 0
