#!/bin/bash

# This script dislays various information to the screen

# Display the text "Hello world"
echo 'Hello World!'

# Assign a value to a variable
WORD='script'

# Display that variable
echo "$WORD"

# Demonstrate that single quotes causes variablees NOT to get expanded
echo '$WORD'

# Combine variable with hardcoded text
echo "This is my secreet $WORD" 

# Display the value of the variable using alternative syntx
echo "This is a shell ${WORD}"

# Append text to the variable
echo "${WORD}s are fun!"

# Createa a new variable
ENDING='ed'

# Combine variables
echo "This is ${WORD}${ENDING}"

# Change value stored in variable (reasignment)
ENDING='ing'

# Print new variable
echo "This is ${WORD}${ENDING}"

