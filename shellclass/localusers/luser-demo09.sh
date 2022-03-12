#!/bin/bash


# This script demonstrates the case statement


# Example of bad if statement

#if [[ "${1}" == 'Start' ]]
#then
#	echo 'Starting'
#elif [[ "${1}" == 'Stop' ]]
#then
#	echo 'Stopping'
#else
#	echo 'Supply a valid input' >&2
#fi

# Case statement
#case "${1}" in
#	start)
#		echo 'Starting'
#	;;
#	stop)
#		echo 'Stopping'
#	;;
#	# Can add multiple different patterns, could also use *, like stat*, etc.
#	status|state|--status|--state)
#		echo 'Status'
#	;;
#	*)
#		echo 'Need to supply input' >&2
#		exit 1
#	;;
#esac


# The cleanest approch is to put on a single line, if only a single action for each case

case "${1}" in
	start) echo 'Starting' ;;
	stop) echo 'Stopping' ;;
	status|state|--status|--state) echo 'Status' ;;
	*)
		echo 'Need to supply input' >&2
		exit 1
	;;
esac



