# folder_structure_generator.py
# Generate Class Test
import os
import sys

if len(sys.argv) > 1:
    user_input = sys.argv[1]
else:
    user_input = input("Enter Feature name: ")
BASE_NAME=user_input
os.chdir('..')
BASE_DIR='lib/features/' + BASE_NAME
directory = BASE_DIR+'/data/services'
os.chdir(directory)


#_____________________________________________________







def generate_dart_file(file_name, class_name):
    template = f'''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part '{part}';

@RestApi()
@lazySingleton
abstract class {class_name}  {{

@factoryMethod
  factory {class_name}(@Named('Dio') Dio dio) => _{class_name}(dio);
}}
'''
    with open(file_name, 'w') as file:
        file.write(template) 

# Example usage
file_name = BASE_NAME + '_service.dart'
part = BASE_NAME +'_service.g.dart'
class_name = BASE_NAME.capitalize()+'Service'

generate_dart_file(file_name, class_name)
print(f"Dart file '{file_name}' generated successfully.")





# Run Script
# python3 PY_service_class_generator.py
