import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependency_init.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  usesNullSafety: true,
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
GetIt configureDependencies() => $initGetIt(getIt);
