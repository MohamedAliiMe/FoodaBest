# folder_structure_generator.py
# Generate Class Test
import os
import sys
if len(sys.argv) > 1:
    user_input = sys.argv[1]
else:
    user_input = input("Enter Feature name: ")
BASE_NAME=user_input
cubit_input = input("Enter Cubit name: ")
Cubit_NAME=cubit_input
if os.getcwd().find("generator") != -1:
   os.chdir('..')
BASE_DIR='lib/features/' + BASE_NAME
directory = BASE_DIR+'/logic/'
os.makedirs(directory, exist_ok=True)
os.chdir(directory)

def generate_dart_file(file_name, class_name):
    template = f'''

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';


part '{part_state}';
part '{part_freezed}';

@Injectable()
class {class_name} extends Cubit<{class_state}> {{

{class_name}() : super({class_state}()); 

}}
'''
    with open(file_name, 'w') as file:
        file.write(template) 

# Example usage
file_name = Cubit_NAME + '_cubit.dart'
class_name = Cubit_NAME.capitalize()+'Cubit'
class_state = Cubit_NAME.capitalize()+'State'

part_cubit= Cubit_NAME +'_cubit.dart'

part_state = Cubit_NAME +'_state.dart'
part_freezed = Cubit_NAME +'_cubit.freezed.dart'


generate_dart_file(file_name, class_name)
print(f"Dart file '{file_name}' generated successfully.")
#_____________________________________________________
#State

def generate_dart_file(file_name_state, class_state):
    template = f'''

part of '{part_cubit}';

@freezed
class {class_state} with _${class_state} {{
 factory {class_state}({
    '{    @Default(false) bool isLoading, String? errorMessage, @Default(false) bool failedState,}'
  }) = _{class_state};
}}
'''
    with open(file_name_state, 'w') as file:
        file.write(template) 

# Example usage
file_name_state = Cubit_NAME + '_state.dart'

generate_dart_file(file_name_state, class_state)
print(f"Dart file '{file_name_state}' generated successfully.")


# Run Script
# python3 PY_cubit_class_generator.py
