// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_authentication_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppAuthenticationStateEnumAdapter
    extends TypeAdapter<AppAuthenticationStateEnum> {
  @override
  final int typeId = 2;

  @override
  AppAuthenticationStateEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppAuthenticationStateEnum.customerState;
      case 1:
        return AppAuthenticationStateEnum.unauthorizedState;
      default:
        return AppAuthenticationStateEnum.customerState;
    }
  }

  @override
  void write(BinaryWriter writer, AppAuthenticationStateEnum obj) {
    switch (obj) {
      case AppAuthenticationStateEnum.customerState:
        writer.writeByte(0);
        break;
      case AppAuthenticationStateEnum.unauthorizedState:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAuthenticationStateEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
