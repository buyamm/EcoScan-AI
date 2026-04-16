// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutritionModelAdapter extends TypeAdapter<NutritionModel> {
  @override
  final int typeId = 0;

  @override
  NutritionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionModel(
      energyKcal: fields[0] as double?,
      fat: fields[1] as double?,
      saturatedFat: fields[2] as double?,
      carbohydrates: fields[3] as double?,
      sugars: fields[4] as double?,
      fiber: fields[5] as double?,
      proteins: fields[6] as double?,
      salt: fields[7] as double?,
      sodium: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, NutritionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.energyKcal)
      ..writeByte(1)
      ..write(obj.fat)
      ..writeByte(2)
      ..write(obj.saturatedFat)
      ..writeByte(3)
      ..write(obj.carbohydrates)
      ..writeByte(4)
      ..write(obj.sugars)
      ..writeByte(5)
      ..write(obj.fiber)
      ..writeByte(6)
      ..write(obj.proteins)
      ..writeByte(7)
      ..write(obj.salt)
      ..writeByte(8)
      ..write(obj.sodium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
