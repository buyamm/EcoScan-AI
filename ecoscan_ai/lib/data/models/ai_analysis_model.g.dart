// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_analysis_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthAnalysisAdapter extends TypeAdapter<HealthAnalysis> {
  @override
  final int typeId = 5;

  @override
  HealthAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthAnalysis(
      score: fields[0] as int,
      concerns: (fields[1] as List).cast<String>(),
      positives: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HealthAnalysis obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.concerns)
      ..writeByte(2)
      ..write(obj.positives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnvironmentAnalysisAdapter extends TypeAdapter<EnvironmentAnalysis> {
  @override
  final int typeId = 6;

  @override
  EnvironmentAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnvironmentAnalysis(
      score: fields[0] as int,
      concerns: (fields[1] as List).cast<String>(),
      positives: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EnvironmentAnalysis obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.concerns)
      ..writeByte(2)
      ..write(obj.positives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvironmentAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EthicsAnalysisAdapter extends TypeAdapter<EthicsAnalysis> {
  @override
  final int typeId = 7;

  @override
  EthicsAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EthicsAnalysis(
      score: fields[0] as int,
      crueltyFree: fields[1] as bool?,
      vegan: fields[2] as bool?,
      concerns: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EthicsAnalysis obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.crueltyFree)
      ..writeByte(2)
      ..write(obj.vegan)
      ..writeByte(3)
      ..write(obj.concerns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthicsAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GreenwashingClaimAdapter extends TypeAdapter<GreenwashingClaim> {
  @override
  final int typeId = 8;

  @override
  GreenwashingClaim read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GreenwashingClaim(
      claim: fields[0] as String,
      reality: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GreenwashingClaim obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.claim)
      ..writeByte(1)
      ..write(obj.reality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreenwashingClaimAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GreenwashingResultAdapter extends TypeAdapter<GreenwashingResult> {
  @override
  final int typeId = 9;

  @override
  GreenwashingResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GreenwashingResult(
      level: fields[0] as GreenwashingLevel,
      claims: (fields[1] as List).cast<GreenwashingClaim>(),
    );
  }

  @override
  void write(BinaryWriter writer, GreenwashingResult obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.claims);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreenwashingResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IngredientAnalysisAdapter extends TypeAdapter<IngredientAnalysis> {
  @override
  final int typeId = 10;

  @override
  IngredientAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientAnalysis(
      name: fields[0] as String,
      explanation: fields[1] as String,
      safety: fields[2] as IngredientSafety,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientAnalysis obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.explanation)
      ..writeByte(2)
      ..write(obj.safety);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIAnalysisModelAdapter extends TypeAdapter<AIAnalysisModel> {
  @override
  final int typeId = 11;

  @override
  AIAnalysisModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIAnalysisModel(
      overallScore: fields[0] as int,
      level: fields[1] as EcoScoreLevel,
      health: fields[2] as HealthAnalysis,
      environment: fields[3] as EnvironmentAnalysis,
      ethics: fields[4] as EthicsAnalysis,
      greenwashing: fields[5] as GreenwashingResult,
      ingredients: (fields[6] as List).cast<IngredientAnalysis>(),
      suitableFor: (fields[7] as List).cast<String>(),
      notSuitableFor: (fields[8] as List).cast<String>(),
      summary: fields[9] as String,
      rawText: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AIAnalysisModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.overallScore)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.health)
      ..writeByte(3)
      ..write(obj.environment)
      ..writeByte(4)
      ..write(obj.ethics)
      ..writeByte(5)
      ..write(obj.greenwashing)
      ..writeByte(6)
      ..write(obj.ingredients)
      ..writeByte(7)
      ..write(obj.suitableFor)
      ..writeByte(8)
      ..write(obj.notSuitableFor)
      ..writeByte(9)
      ..write(obj.summary)
      ..writeByte(10)
      ..write(obj.rawText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIAnalysisModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EcoScoreLevelAdapter extends TypeAdapter<EcoScoreLevel> {
  @override
  final int typeId = 2;

  @override
  EcoScoreLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EcoScoreLevel.green;
      case 1:
        return EcoScoreLevel.yellow;
      case 2:
        return EcoScoreLevel.red;
      default:
        return EcoScoreLevel.green;
    }
  }

  @override
  void write(BinaryWriter writer, EcoScoreLevel obj) {
    switch (obj) {
      case EcoScoreLevel.green:
        writer.writeByte(0);
        break;
      case EcoScoreLevel.yellow:
        writer.writeByte(1);
        break;
      case EcoScoreLevel.red:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EcoScoreLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GreenwashingLevelAdapter extends TypeAdapter<GreenwashingLevel> {
  @override
  final int typeId = 3;

  @override
  GreenwashingLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GreenwashingLevel.none;
      case 1:
        return GreenwashingLevel.suspected;
      case 2:
        return GreenwashingLevel.confirmed;
      default:
        return GreenwashingLevel.none;
    }
  }

  @override
  void write(BinaryWriter writer, GreenwashingLevel obj) {
    switch (obj) {
      case GreenwashingLevel.none:
        writer.writeByte(0);
        break;
      case GreenwashingLevel.suspected:
        writer.writeByte(1);
        break;
      case GreenwashingLevel.confirmed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreenwashingLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IngredientSafetyAdapter extends TypeAdapter<IngredientSafety> {
  @override
  final int typeId = 4;

  @override
  IngredientSafety read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IngredientSafety.safe;
      case 1:
        return IngredientSafety.caution;
      case 2:
        return IngredientSafety.avoid;
      default:
        return IngredientSafety.safe;
    }
  }

  @override
  void write(BinaryWriter writer, IngredientSafety obj) {
    switch (obj) {
      case IngredientSafety.safe:
        writer.writeByte(0);
        break;
      case IngredientSafety.caution:
        writer.writeByte(1);
        break;
      case IngredientSafety.avoid:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientSafetyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
