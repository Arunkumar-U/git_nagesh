#!/bin/bash

# Validate JSON file
jsonlint 

# Check the exit status of jsonlint
if [ $? -eq 0 ]; then
    echo "JSON is valid."
else
    echo "JSON is invalid."
fi
