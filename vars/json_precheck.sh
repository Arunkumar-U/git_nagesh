#!/bin/bash

# Validate JSON file
jsonlint templates/ctmjobs/acc/CONTROL-M_JAVA_ACC.json

# Check the previous exit status of jsonlint
if [ $? -eq 0 ]; then
    echo "JSON is valid."
else
    echo "JSON is invalid."
fi
