import 'package:fooda_best/core/constants/hive_ids.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'app_authentication_state.g.dart';

@HiveType(typeId: HiveIds.appAuthenticationStateId)
enum AppAuthenticationStateEnum {
  @HiveField(0)
  customerState,
  @HiveField(1)
  unauthorizedState,
}
