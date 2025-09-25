import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_service.g.dart';

@RestApi()
@lazySingleton
abstract class ProfileService {
  @factoryMethod
  factory ProfileService(@Named('Dio') Dio dio) => _ProfileService(dio);
}
