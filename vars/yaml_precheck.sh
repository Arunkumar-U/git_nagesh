#!/bin/bash

# Function to check each line of the YAML file
check_yaml_file() {
    local file=$1
    local errors=()
    local in_job_folder_names=false

    while IFS= read -r line; do
        # Trim leading and trailing whitespace for processing
        trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Check if we are entering the jobFolderNames section
        if [[ $trimmed_line == "jobFolderNames:" ]]; then
            in_job_folder_names=true
            continue
        fi

        # Skip lines outside of the jobFolderNames section
        if [[ $in_job_folder_names == false ]]; then
            continue
        fi

        # Skip completely empty lines
        if [[ -z "$trimmed_line" ]]; then
            continue
        fi

        # Check if the line adheres to the rule
        if [[ ! $line =~ ^\ \-\ [^[:space:]]+\.json$ ]]; then
            errors+=("Error: The line '$line' does not meet the required format")
           # echo "Please check the proper indentation/filename"
        fi
    done < "$file"

    if [ ${#errors[@]} -eq 0 ]; then
        echo "YAML file is valid."
    else
        echo "Please check the indentation/foldername"
        for error in "${errors[@]}"; do
          echo "$error"
        done
        exit 1
    fi
}
# Main script execution
yaml_file="/home/runner/work/git_nagesh/git_nagesh/vars/test/main.yml"
check_yaml_file "$yaml_file"