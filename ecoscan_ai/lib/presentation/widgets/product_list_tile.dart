import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/scan_record.dart';
import 'eco_score_chip.dart';

/// Reusable list tile for scan history entries and alternative product suggestions.
class ProductListTile extends StatelessWidget {
  final String name;
  final String brand;
  final String imageUrl;
  final EcoScoreLevel? ecoLevel;
  final int? ecoScore;
  final String? subtitle;
  final VoidCallback? onTap;

  const ProductListTile({
    super.key,
    required this.name,
    required this.brand,
    this.imageUrl = '',
    this.ecoLevel,
    this.ecoScore,
    this.subtitle,
    this.onTap,
  });

  /// Convenience constructor from a ScanRecord (history).
  factory ProductListTile.fromScanRecord(
    ScanRecord record, {
    VoidCallback? onTap,
  }) {
    return ProductListTile(
      name: record.product.name,
      brand: record.product.brand,
      imageUrl: record.product.imageUrl,
      ecoLevel: record.analysis.level,
      ecoScore: record.analysis.overallScore,
      subtitle: _formatDate(record.scannedAt),
      onTap: onTap,
    );
  }

  /// Convenience constructor from a ProductModel (alternatives).
  factory ProductListTile.fromProduct(
    ProductModel product, {
    EcoScoreLevel? level,
    int? score,
    VoidCallback? onTap,
  }) {
    return ProductListTile(
      name: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      ecoLevel: level,
      ecoScore: score,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
      title: Text(
        name.isNotEmpty ? name : 'Sản phẩm không tên',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (brand.isNotEmpty)
            Text(
              brand,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
        ],
      ),
      trailing: (ecoLevel != null || ecoScore != null)
          ? EcoScoreChip(level: ecoLevel, score: ecoScore)
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _placeholder() {
    return Container(
      width: 52,
      height: 52,
      color: Colors.grey[200],
      child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
    );
  }

  static String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
