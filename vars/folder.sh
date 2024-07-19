#!/bin/bash

#Get the hostname and assign the value to host variable

host=$(hostname)

#Using if condition setting the server_name

if [ "$host" == "vmctmemststwe01.tooling.shd.eu-int-aholddelhaize.com" ]; then
  server_name="vmctmemststwe01.tooling.shd.eu-int-aholddelhaize.com:8443"
elif [ "$host" == "vmctmemsaccwe01.tooling.shd.eu-int-aholddelhaize.com" ]; then
  server_name="vmctmemsaccwe01.tooling.shd.eu-int-aholddelhaize.com:8443"
elif [ "$host" == "vmctmemsprdwe01.tooling.shd.eu-int-aholddelhaize.com" ]; then
  server_name="vmctmemsprdwe01.tooling.shd.eu-int-aholddelhaize.com:8443"
else
  echo "Unknown hostname: $host"
  exit 1
fi

echo "servername:  $server_name"

#Assigning the token value to the variable 'token'
token=$(cat token.txt)

#Extracting the jobFolderNames from '/controlmem/jac/main.yml'
jobFolderNames=$(grep -E '^\s+-\s+' /controlmem/jac/main.yml | awk '{print $2}' | sed 's/^\s*-\s*//' | tr '\n' ' ')

#Introducing one array called 'error_folders'
error_folders=()



# Iterating the build step for the entire jobFolderNames
for item in $jobFolderNames; do
    echo "Build step checking for $item"
    build_step=$(curl -k -H "Authorization: Bearer $token" -X POST -F "definitionsFile=@/controlmem/jac/$item" "https://$server_name/automation-api/build")

    echo "$build_step" | jq .

    if echo "$build_step" | jq -e .errors > /dev/null;
    then
      error_folders+=("$item")
    else
      curl -k -H "Authorization: Bearer $token" -X POST -F "definitionsFile=@/controlmem/jac/$item" "https://$server_name/automation-api/deploy"
    fi
done

# Printing the no. of failed jobFolders
echo "Total number of jobFolders with the error: ${#error_folders[@]}"


# When the length of the error_folders is greater than 'zero' the job should fail 
if [ ${#error_folders[@]} -ne 0 ]
then
  echo "Error:"

  #Iterating the jobFolderName one by one using for loop
  echo "jobFolders with errors:"
  for folder in "${error_folders[@]}"; do
      echo "$folder"
  done

  exit 1  
else
  echo "There is no errors in jobFolders so build and deployment done successfully."
fi





