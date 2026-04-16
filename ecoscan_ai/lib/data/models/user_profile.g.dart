// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 14;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      displayName: fields[0] as String,
      allergies: (fields[1] as List).cast<String>(),
      lifestyle: (fields[2] as List).cast<LifestyleOption>(),
      customAllergies: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.allergies)
      ..writeByte(2)
      ..write(obj.lifestyle)
      ..writeByte(3)
      ..write(obj.customAllergies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LifestyleOptionAdapter extends TypeAdapter<LifestyleOption> {
  @override
  final int typeId = 13;

  @override
  LifestyleOption read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LifestyleOption.vegetarian;
      case 1:
        return LifestyleOption.vegan;
      case 2:
        return LifestyleOption.ecoConscious;
      case 3:
        return LifestyleOption.crueltyFreeOnly;
      default:
        return LifestyleOption.vegetarian;
    }
  }

  @override
  void write(BinaryWriter writer, LifestyleOption obj) {
    switch (obj) {
      case LifestyleOption.vegetarian:
        writer.writeByte(0);
        break;
      case LifestyleOption.vegan:
        writer.writeByte(1);
        break;
      case LifestyleOption.ecoConscious:
        writer.writeByte(2);
        break;
      case LifestyleOption.crueltyFreeOnly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifestyleOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
