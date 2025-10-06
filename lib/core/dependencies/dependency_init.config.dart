// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/authentication/data/services/authentication_service.dart'
    as _i894;
import '../../features/authentication/logic/authentication_cubit.dart' as _i854;
import '../../features/product_analysis/data/repositories/product_analysis_repository.dart'
    as _i623;
import '../../features/product_analysis/data/services/product_analysis_service.dart'
    as _i800;
import '../../features/product_analysis/logic/product_analysis_cubit.dart'
    as _i795;
import '../../features/profile/data/services/profile_service.dart' as _i510;
import '../../features/profile/logic/profile_cubit.dart' as _i559;
import '../../features/search/data/repositories/search_repository.dart'
    as _i708;
import '../../features/search/data/services/search_service.dart' as _i372;
import '../../features/search/logic/search_cubit.dart' as _i729;
import '../utilities/app_data_storage.dart' as _i102;
import '../utilities/configs/themes/theme_cubit.dart' as _i691;
import 'Module/register_module.dart' as _i773;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i691.ThemeCubit>(() => _i691.ThemeCubit());
  gh.factory<_i102.DataStorage>(() => _i102.DataStorage());
  gh.factory<_i559.ProfileCubit>(() => _i559.ProfileCubit());
  gh.factory<_i800.ProductAnalysisService>(
      () => _i800.ProductAnalysisService());
  gh.factory<_i372.SearchService>(() => _i372.SearchService());
  gh.factory<_i729.SearchCubit>(() => _i729.SearchCubit());
  gh.lazySingleton<_i894.AuthenticationService>(
      () => _i894.AuthenticationService());
  gh.lazySingleton<_i623.ProductAnalysisRepository>(() =>
      _i623.ProductAnalysisRepository(gh<_i800.ProductAnalysisService>()));
  gh.factory<_i854.AuthenticationCubit>(() => _i854.AuthenticationCubit(
        gh<_i894.AuthenticationService>(),
        gh<_i102.DataStorage>(),
      ));
  gh.factory<String>(
    () => registerModule.baseUrl,
    instanceName: 'BaseUrl',
  );
  gh.lazySingleton<_i361.Dio>(
    () => registerModule.dio(gh<String>(instanceName: 'BaseUrl')),
    instanceName: 'Dio',
  );
  gh.lazySingleton<_i708.SearchRepository>(
      () => _i708.SearchRepository(gh<_i372.SearchService>()));
  gh.factory<_i795.ProductAnalysisCubit>(
      () => _i795.ProductAnalysisCubit(gh<_i623.ProductAnalysisRepository>()));
  gh.lazySingleton<_i510.ProfileService>(
      () => _i510.ProfileService(gh<_i361.Dio>(instanceName: 'Dio')));
  gh.lazySingleton<_i361.Dio>(
    () => registerModule.dioInterceptor(gh<String>(instanceName: 'BaseUrl')),
    instanceName: 'Interceptor',
  );
  return getIt;
}

class _$RegisterModule extends _i773.RegisterModule {}
