#!/bin/bash

# This script generates a list of random passwords

# A random number as a password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"


# Three random numbers togheter
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"


# Time and date as password
PASSWORD=$(date +%s)
echo "${PASSWORD}"


# Time and date as nanoseconds as password
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# Using hash algorithm on nano seconds
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# An even better password, same but with random numbers
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"

# Append a special character to the password
SPECIAL_CHARACTER=$(echo '!#¤%&/()=?}][{€$£@' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"
