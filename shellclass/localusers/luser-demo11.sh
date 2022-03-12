#!/bin/bash

# This script demonstrates the use of Command Line Options with getopts, by generating a password
# The user can set the password length the -l option and add a special character with -s
# Verbose mode can be activiated by -v

usage() {
  echo "USAGE: ${0} [-vs] [-l LENGTH]" >&2
  echo '  -l Length	Specify the password length'
  echo '  -s		Append a special character to the password'
  echo '  -v		Increase verbosity'
  exit 1
}

# Logger method
log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" == 'true' ]]
    then
	echo "${MESSAGE}"
  fi
  logger "${MESSAGE}"
}

# Set default password length
LENGTH=48

# Process command line options
while getopts vl:s OPTION
  do
    case ${OPTION} in
      v)
	VERBOSE='true'
	log 'Verbose mode is on'
	;;
      l)
	LENGTH="${OPTARG}"
	;;
      s)
	USE_SPECIAL_CHARACTERS='true'
	;;
      ?)
	usage
	;;

  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

if [[ "${#}" -gt 0 ]]
then
  usage
fi



log 'Generating a password'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
  log 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password:'

# Display the password.
echo "${PASSWORD}"

exit 0


















































































