#!/bin/bash

# env setting
path='/home/runner/work/git_nagesh/git_nagesh/templates/ctmjobs/acc'

# Validate JSON file
jsonlint "${path}"/CONTROL-M_JAVA_ACC.json

# Check the previous exit status of jsonlint
if [ $? -eq 0 ]; then
    echo "JSON is valid."
else
    echo "JSON is invalid."
fi
