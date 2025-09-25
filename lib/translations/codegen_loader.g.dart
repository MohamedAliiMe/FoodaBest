// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'package:easy_localization/easy_localization.dart' show AssetLoader;
import 'package:flutter/material.dart';
import 'package:fooda_best/translations/translation_maps/ar.dart';
import 'package:fooda_best/translations/translation_maps/en.dart';

class CodeGenLoader extends AssetLoader {
  const CodeGenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": ar,
    "en": en,
  };
}
