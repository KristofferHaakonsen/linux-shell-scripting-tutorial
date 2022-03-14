#!/bin/bash

# Executes all arguments as a single command on every server listed in the /vagrant/servers file by default.

# Executes the provided commands the user executing this script


usage() {
# Provides usage statement and exits with 1
  echo "USAGE: {0} [options] arguments... " >&2
  echo 'Executes all arguments as a single command on every server listed in the /vagrant/servers file by default.' >&2
  echo 'Cannot be run as superuser, use -s for superuser at remote hosts'
  echo '-f file		Specify file of servers' >&2
  echo '-n		Perform a dry run, display commands instead of executing' >&2
  echo '-s		Run all commands as superuser on remote hosts' >&2
  echo '-v		Verbose mode' >&2	
  exit 1
}

# Make sure the script is not being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
  log 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

# Logger method
log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" == 'true' ]]
    then
	echo "${MESSAGE}"
  fi
  logger "${MESSAGE}"
}

# Check options
SERVER_LIST='/vagrant/servers'
TIMEOUT_DELAY='2'

while getopts vnsf: OPTION
  do
    case ${OPTION} in
      v)
        VERBOSE='true'
	log 'Verbose mode on'
	;;
      n)
	DRY_RUN='true'
	log 'Dry run mode on'
	;;
      s)
	SUDO='sudo'
	log 'Remote superuser mode on'
	;;
      f)
	SERVER_LIST="${OPTARG}"
	log "Uses ${SERVER_LIST} as serverlist"
        ;;
      ?) usage ;;
  esac
done


# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# Ensure at least one argument
if [[ "${#}" -lt 1 ]]
then
  echo 'Attempted to run without any commands' >&2
  usage
fi

COMMANDS="${@}"

# Make sure the SERVER_LIST file exists.
if [[ ! -e "${SERVER_LIST}" ]]
then
  echo "Cannot open server list file ${SERVER_LIST}." >&2 
  exit 1
fi

EXIT_STATUS='0'


# Connect to hosts, use timeout
for SERVER in $(cat ${SERVER_LIST})
  do
    if [[ "${VERBOSE}" == 'true' ]]
      then
	log "Executing on: ${SERVER}"
    fi
    
    SSH_COMMAND="ssh -o ConnectTimeout=${TIMEOUT_DELAY} ${SERVER} ${SUDO} ${COMMANDS}"
    if [[ "${DRY_RUN}" == 'true' ]]
      then
        echo 'DRY RUN'
	echo "${SSH_COMMAND}"
      else
 	${SSH_COMMAND}
     	SSH_EXIT_STATUS="${?}"
    
      # Check status
      if [[ "${SSH_EXIT_STATUS}" != 0 ]]
        then
	  EXIT_STATUS=${SSH_EXIT_STATUS}
	  log "Execution on ${SERVER} failed"
      fi
    fi


done


exit "${EXIT_STATUS}"
