import 'package:hive_flutter/hive_flutter.dart';
import 'product_model.dart';
import 'ai_analysis_model.dart';

part 'scan_record.g.dart';

@HiveType(typeId: 12)
class ScanRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime scannedAt;

  @HiveField(2)
  final ProductModel product;

  @HiveField(3)
  final AIAnalysisModel analysis;

  @HiveField(4)
  final String scanMethod; // 'barcode' | 'ocr' | 'manual'

  ScanRecord({
    required this.id,
    required this.scannedAt,
    required this.product,
    required this.analysis,
    required this.scanMethod,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'scannedAt': scannedAt.toIso8601String(),
        'product': product.toJson(),
        'analysis': analysis.toJson(),
        'scanMethod': scanMethod,
      };
}
