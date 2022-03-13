#!/bin/bash

# A list of open port on the virtual machines, without anything else
# Use -4 as an argument to limit to only tcp4 port
# No security for positional argument for the $1, as we dont care
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
