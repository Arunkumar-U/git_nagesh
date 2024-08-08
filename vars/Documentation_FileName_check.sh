#!/bin/bash

# Input JSON file
input_file=$1

# Function to check for DocumentationFile object and its FileName value
check_documentation_file() {
  local parent_object=$1
  local object_name=$2
  local object_path="$parent_object.\"$object_name\""

  # Check if DocumentationFile exists
  has_documentation_file=$(jq -e "$object_path | has(\"DocumentationFile\")" $input_file)

  if [ "$has_documentation_file" == "true" ]; then
    # Check if FileName within DocumentationFile has a non-empty value
    file_name_value=$(jq -r "$object_path.DocumentationFile.FileName // empty" $input_file)

    if [ -z "$file_name_value" ]; then
      echo "$object_name: DocumentationFile exists but FileName is empty or missing"
    fi
  else
    echo "$object_name: DocumentationFile is missing"
  fi
}

# Get the name of the top-level object
top_level_object=$(jq -r 'keys_unsorted[0]' $input_file)

# Ensure we have a valid top-level object
if [ -z "$top_level_object" ]; then
  echo "Error: No top-level object found in the JSON file."
  exit 1
fi

# Find all nested objects inside the top-level object
nested_objects=$(jq -r ".\"$top_level_object\" | to_entries | map(select(.value | type == \"object\")) | .[].key" $input_file)

# Check for DocumentationFile and FileName in each nested object
missing_or_empty_file_names=()
for obj in $nested_objects; do
  result=$(check_documentation_file ".\"$top_level_object\"" "$obj")
  if [ -n "$result" ]; then
    missing_or_empty_file_names+=("$result")
  fi
done

# Print results
if [ ${#missing_or_empty_file_names[@]} -ne 0 ]; then
  echo "In the following jobs issues were found:"
  for item in "${missing_or_empty_file_names[@]}"; do
    echo "$item"
  done
  exit 1
else
  echo "All objects contain the DocumentationFile object with a non-empty FileName."
fi