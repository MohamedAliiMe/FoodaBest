
import 'package:fooda_best/core/utilities/environment/production_configurations.dart';

import '../../constants/app_string_constants.dart';
import 'base_configurations.dart';
import 'development_configurations.dart';

class EnvironmentsVariables {
  EnvironmentsVariables._internal();

  static final EnvironmentsVariables _singleton =
      EnvironmentsVariables._internal();

  static const String development = AppStringConstants.development;
  static const String production = AppStringConstants.production;

  late BaseConfigurations configurations;

  factory EnvironmentsVariables() {
    return _singleton;
  }

  void initConfig(String environment) {
    configurations = _getConfig(environment);
  }

  BaseConfigurations _getConfig(String environment) {
    switch (environment) {
      case EnvironmentsVariables.production:
        return ProductionConfigurations();
      default:
        return DevelopmentConfigurations();
    }
  }
}
