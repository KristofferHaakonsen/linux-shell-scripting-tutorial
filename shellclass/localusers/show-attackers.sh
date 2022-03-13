#!/bin/bash

# Count number of failed login attempts and return results for more than 10 fails


LIMIT='10'

# Requires that a file is added as input
LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open file: ${LOG_FILE}" >&2
  exit 1
fi




# Count number of failed login attempts by ip adress
# If more than 10 failed from same ip adress, show: attempts, ip adress, location of ip
# As a CSV

echo 'Count,IP,Location'
grep password ${LOG_FILE} | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
  if [[ "${COUNT}" -ge "${LIMIT}" ]]
    then
      LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
      echo "$COUNT,$IP,$LOCATION"
  else
    # Optimize runtime
    break
  fi
done

exit 0


