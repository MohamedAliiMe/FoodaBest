import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

import '../constants/app_string_constants.dart';

@Injectable()
class DataStorage {
  Future<dynamic> getData(String key) async {
    final box = await Hive.openBox(AppStringConstants.appName);
    final data = await box.get(key);
    return data;
  }

  Future<bool> contains(String key) async {
    final box = await Hive.openBox(AppStringConstants.appName);
    bool found = box.containsKey(key);
    return found;
  }

  Future<void> saveData(String key, dynamic data) async {
    final box = await Hive.openBox(AppStringConstants.appName);
    return box.put(key, data);
  }

  Future<void> removeData(String key) async {
    final box = await Hive.openBox(AppStringConstants.appName);
    return box.delete(key);
  }

  Future<void> clearData() async {
    final box = await Hive.openBox(AppStringConstants.appName);
    box.clear();
  }
}
