# folder_structure_generator.py
# Generate Class Test
import os
import sys

if len(sys.argv) > 1:
    user_input = sys.argv[1]
else:
    user_input = input("Enter Feature name: ")

BASE_NAME = user_input
cubit_input = input("Enter Cubit name: ")
Cubit_NAME = cubit_input

if os.getcwd().find("generator") != -1:
    os.chdir('..')

BASE_DIR = 'lib/features/' + BASE_NAME
directory = BASE_DIR + '/data/repository/'
os.makedirs(directory, exist_ok=True)
os.chdir(directory)

def generate_dart_file(file_name, class_name, attributes=None):
    if attributes is None:
        attributes = []
    template = f'''

abstract class {class_name} {{
}}
'''
    with open(file_name, 'w') as file:
        file.write(template)

def generate_dart_file_impl(file_name_impl, class_name_impl, base_class_name, attributes):
    template = f'''

import 'package:injectable/injectable.dart';
import '../services/{BASE_NAME}_service.dart';
import '{BASE_NAME}_repository.dart';

@Injectable(as: {base_class_name})
class {class_name_impl} extends {base_class_name} {{
{"".join([f"final {attribute['type']} {attribute['name']};\n" for attribute in attributes])}

  {class_name_impl}({", ".join([f"this.{attribute['name']}" for attribute in attributes])});


}}
'''

    with open(file_name_impl, 'w') as file:
        file.write(template)

# Generate Repository
file_name = BASE_NAME + '_repository.dart'
class_name = BASE_NAME.capitalize() + 'Repository'
generate_dart_file(file_name, class_name)
print(f"Dart file '{file_name}' generated successfully.")

# Generate Repository Implementation
file_name_impl = BASE_NAME + '_repository_impl.dart'
class_name_impl = BASE_NAME.capitalize() + 'RepositoryImpl'
attributes = [
    {'type': BASE_NAME.capitalize() + 'Service', 'name': '_service'},
]
generate_dart_file_impl(file_name_impl, class_name_impl, class_name, attributes)
print(f"Dart file '{file_name_impl}' generated successfully.")



# Run Script
# python3 PY_repository_class_generator.py
