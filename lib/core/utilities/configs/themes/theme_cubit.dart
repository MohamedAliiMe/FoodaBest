import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooda_best/core/constants/app_string_constants.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/utilities/app_data_storage.dart';
import 'package:injectable/injectable.dart';


@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final DataStorage dataStorage = getIt<DataStorage>();

  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark =
        await dataStorage.getData(AppStringConstants.themeKey) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
    emit(newTheme);
    await dataStorage.saveData(
        AppStringConstants.themeKey, newTheme == ThemeMode.dark);
  }
}
