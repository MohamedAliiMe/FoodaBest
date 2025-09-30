import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/app_authentication_state/app_authentication_state.dart';
import 'package:fooda_best/core/bloc_observer/bloc_observer.dart';
import 'package:fooda_best/core/constants/app_string_constants.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/utilities/appKeys.dart';
import 'package:fooda_best/core/utilities/configs/themes/core_theme.dart';
import 'package:fooda_best/core/utilities/environment/environment_configurations.dart';
import 'package:fooda_best/core/utilities/routes_navigator/route_generator.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/product_analysis/logic/product_analysis_cubit.dart';
import 'package:fooda_best/translations/codegen_loader.g.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize ensureInitialized
  await EasyLocalization.ensureInitialized();

  // init environment
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: EnvironmentsVariables.production,
  );

  // init Environments Variables
  EnvironmentsVariables().initConfig(environment);

  // init Hive ( data storage )
  await Hive.initFlutter();
  Hive.registerAdapter(AppAuthenticationStateEnumAdapter());

  // init get observer for all Bloc's
  Bloc.observer = MyBlocObserver();

  // init get it for all Dependencies
  getIt.registerSingleton(Dio());
  configureDependencies();
  await getIt.allReady();

  runApp(
    EasyLocalization(
      path: 'assets/translation',
      supportedLocales: const [Locale('ar'), Locale('en')],
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      assetLoader: const CodeGenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (context) => getIt<AuthenticationCubit>(),
        ),
        BlocProvider<ProductAnalysisCubit>(
          create: (context) => getIt<ProductAnalysisCubit>(),
        ),
      ],
      child: MaterialChild(),
    );
  }
}

class MaterialChild extends StatefulWidget {
  const MaterialChild({super.key});

  @override
  State<MaterialChild> createState() => _MaterialChildState();
}

class _MaterialChildState extends State<MaterialChild> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppStringConstants.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: AppKeys.materialKey,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: ThemeMode.light,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
