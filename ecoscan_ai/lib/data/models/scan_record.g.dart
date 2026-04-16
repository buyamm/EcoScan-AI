// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanRecordAdapter extends TypeAdapter<ScanRecord> {
  @override
  final int typeId = 12;

  @override
  ScanRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanRecord(
      id: fields[0] as String,
      scannedAt: fields[1] as DateTime,
      product: fields[2] as ProductModel,
      analysis: fields[3] as AIAnalysisModel,
      scanMethod: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ScanRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.scannedAt)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.analysis)
      ..writeByte(4)
      ..write(obj.scanMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
