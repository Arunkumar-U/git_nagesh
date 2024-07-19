import yaml
import sys
import re

def validate_yaml(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        data = yaml.safe_load(''.join(lines))
        
        if 'jobFolderNames' not in data or not isinstance(data['jobFolderNames'], list):
            print(f'Error: jobFolderNames key is missing or is not a list in {file_path}')
            sys.exit(1)
        
        # Regular expression for the correct line format
        line_pattern = re.compile(r'^\s+- [\w-]+\.json$')

        job_folder_names_found = False
        for i, line in enumerate(lines):
            line = line.strip()
            if line == 'jobFolderNames:':
                job_folder_names_found = True
                continue
            
            if job_folder_names_found:
                if not line:
                    break
                
                # Check if the line matches the expected format
                if not line_pattern.match(line):
                    print(f'Error: Improper format in line {i + 1}: "{line}" in {file_path}')
                    sys.exit(1)

        for item in data['jobFolderNames']:
            if not isinstance(item, str) or not item.endswith('.json'):
                print(f'Error: {item} in {file_path} is not a valid JSON file name')
                sys.exit(1)
        print(f'Success: {file_path} is valid')

if __name__ == "__main__":
    files_to_check = ['vars/acc/main.yml', 'vars/prd/main.yml', 'vars/tst/main.yml']
    for file in files_to_check:
        validate_yaml(file)





# import yaml
# import sys
# import re

# def validate_yaml(file_path):
#     with open(file_path, 'r') as file:
#         lines = file.readlines()
#         data = yaml.safe_load(''.join(lines))
        
#         if 'jobFolderNames' not in data or not isinstance(data['jobFolderNames'], list):
#             print(f'Error: jobFolderNames key is missing or is not a list in {file_path}')
#             sys.exit(1)
        
#         job_folder_names_found = False
#         for i, line in enumerate(lines):
#             if line.strip() == 'jobFolderNames:':
#                 job_folder_names_found = True
#                 continue
            
#             if job_folder_names_found:
#                 if not line.strip():
#                     break
                
#                 # Check if the line has proper indentation and spacing
#                 if not re.match(r'^\s+-\s\w+\.json$', line):
#                     print(f'Error: Improper format in line {i + 1}: "{line.strip()}" in {file_path}')
#                     sys.exit(1)

#         for item in data['jobFolderNames']:
#             if not isinstance(item, str) or not item.endswith('.json'):
#                 print(f'Error: {item} in {file_path} is not a valid JSON file name')
#                 sys.exit(1)
#         print(f'Success: {file_path} is valid')

# if __name__ == "__main__":
#     files_to_check = ['vars/acc/main.yml', 'vars/prd/main.yml', 'vars/tst/main.yml']
#     for file in files_to_check:
#         validate_yaml(file)




# import yaml
# import sys

# def validate_yaml(file_path):
#     with open(file_path, 'r') as file:
#         data = yaml.safe_load(file)
#         if 'jobFolderNames' not in data or not isinstance(data['jobFolderNames'], list):
#             print(f'Error: jobFolderNames key is missing or is not a list in {file_path}')
#             sys.exit(1)
#         for item in data['jobFolderNames']:
#             if not isinstance(item, str) or not item.endswith('.json'):
#                 print(f'Error: {item} in {file_path} is not a valid JSON file name')
#                 sys.exit(1)
#         print(f'Success: {file_path} is valid')

# if __name__ == "__main__":
#     files_to_check = ['vars/acc/main.yml', 'vars/prd/main.yml', 'vars/test/main.yml']
#     for file in files_to_check:
#         validate_yaml(file)
