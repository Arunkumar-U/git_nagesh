#!/bin/bash

# Read the directory containing JSON files from json_directory.txt
JSON_DIR=$(cat /home/runner/work/git_nagesh/git_nagesh/vars/json_directory.txt)

# Check if the directory exists
if [ ! -d "$JSON_DIR" ]; then
  echo "Directory $JSON_DIR does not exist."
  exit 1
fi

# Iterate over all JSON files in the directory
for file in "$JSON_DIR"/*.json; do
  if [ -f "$file" ]; then
    echo "Checking syntax for $file"
    jsonlint "$file" -q
    if [ $? -ne 0 ]; then
      echo "Syntax error in $file"
      exit 1
    else
      echo "Syntax is correct for $file"
    fi
  fi
done

echo "All JSON files have correct syntax."








# #!/bin/bash

# # env setting
# path='/home/runner/work/git_nagesh/git_nagesh/templates/ctmjobs/acc'

# # Validate JSON file
# jsonlint ${path}/CONTROL-M_JAVA_ACC.json

# # Check the previous exit status of jsonlint
# if [ $? -eq 0 ]; then
#     echo "JSON is valid."
# else
#     echo "JSON is invalid."
# fi
