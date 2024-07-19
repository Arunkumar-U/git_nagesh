import yaml
import sys

def validate_yaml(file_path):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
        if 'jobFolderNames' not in data or not isinstance(data['jobFolderNames'], list):
            print(f'Error: jobFolderNames key is missing or is not a list in {file_path}')
            sys.exit(1)
        for item in data['jobFolderNames']:
            if not isinstance(item, str) or not item.endswith('.json'):
                print(f'Error: {item} in {file_path} is not a valid JSON file name')
                sys.exit(1)
        print(f'Success: {file_path} is valid')

if __name__ == "__main__":
    files_to_check = ['vars/acc/main.yml', 'vars/prd/main.yml', 'vars/test/main.yml']
    for file in files_to_check:
        validate_yaml(file)
