// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      barcode: fields[0] as String,
      name: fields[1] as String,
      brand: fields[2] as String,
      imageUrl: fields[3] as String,
      countries: fields[4] as String,
      ingredients: (fields[5] as List).cast<String>(),
      ingredientsText: fields[6] as String,
      nutrition: fields[7] as NutritionModel?,
      labels: (fields[8] as List).cast<String>(),
      allergens: (fields[9] as List).cast<String>(),
      ecoScore: fields[10] as String?,
      nutriScore: fields[11] as String?,
      category: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.countries)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.ingredientsText)
      ..writeByte(7)
      ..write(obj.nutrition)
      ..writeByte(8)
      ..write(obj.labels)
      ..writeByte(9)
      ..write(obj.allergens)
      ..writeByte(10)
      ..write(obj.ecoScore)
      ..writeByte(11)
      ..write(obj.nutriScore)
      ..writeByte(12)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
