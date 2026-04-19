import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/models/nutrition_model.dart';
import '../../core/theme/app_theme.dart';

class NutritionDetailScreen extends StatelessWidget {
  final ProductModel product;

  const NutritionDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final n = product.nutrition;

    return Scaffold(
      appBar: AppBar(title: const Text('Bảng dinh dưỡng')),
      body: n == null
          ? const Center(child: Text('Không có thông tin dinh dưỡng'))
          : ListView(
              padding: EdgeInsets.only(
                left: 16, right: 16, top: 16,
                bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
              ),
              children: [
                // Product name header
                Text(
                  product.name.isNotEmpty ? product.name : 'Sản phẩm',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Thông tin dinh dưỡng trên 100g/100ml',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                _NutritionTable(nutrition: n),
                const SizedBox(height: 24),
                _NutritionBars(nutrition: n),
              ],
            ),
    );
  }
}

class _NutritionTable extends StatelessWidget {
  final NutritionModel nutrition;

  const _NutritionTable({required this.nutrition});

  @override
  Widget build(BuildContext context) {
    final rows = [
      _NutriRow('Năng lượng', nutrition.energyKcal, 'kcal'),
      _NutriRow('Chất béo', nutrition.fat, 'g'),
      _NutriRow('  - Chất béo bão hòa', nutrition.saturatedFat, 'g',
          isSubRow: true),
      _NutriRow('Carbohydrate', nutrition.carbohydrates, 'g'),
      _NutriRow('  - Đường', nutrition.sugars, 'g', isSubRow: true),
      _NutriRow('Chất xơ', nutrition.fiber, 'g'),
      _NutriRow('Protein', nutrition.proteins, 'g'),
      _NutriRow('Muối', nutrition.salt, 'g'),
      _NutriRow('Natri', nutrition.sodium, 'g'),
    ];

    return Card(
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Thành phần',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                Text('Trên 100g',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700])),
              ],
            ),
          ),
          // Table rows
          ...rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: i.isEven ? Colors.transparent : Colors.grey[50],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            row.isSubRow ? Colors.grey[600] : Colors.black87,
                        fontStyle: row.isSubRow ? FontStyle.italic : null,
                      ),
                    ),
                  ),
                  Text(
                    row.value != null
                        ? '${row.value!.toStringAsFixed(row.unit == 'kcal' ? 0 : 1)} ${row.unit}'
                        : '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: row.value != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NutriRow {
  final String label;
  final double? value;
  final String unit;
  final bool isSubRow;

  _NutriRow(this.label, this.value, this.unit, {this.isSubRow = false});
}

class _NutritionBars extends StatelessWidget {
  final NutritionModel nutrition;

  const _NutritionBars({required this.nutrition});

  @override
  Widget build(BuildContext context) {
    // Reference daily values (approximate)
    final bars = [
      _BarItem('Chất béo', nutrition.fat, 70, AppColors.warning),
      _BarItem('Carbohydrate', nutrition.carbohydrates, 260, AppColors.primary),
      _BarItem('Protein', nutrition.proteins, 50, AppColors.secondary),
      _BarItem('Đường', nutrition.sugars, 90, AppColors.danger),
      _BarItem('Muối', nutrition.salt, 6, Colors.purple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '% Giá trị hàng ngày (tham khảo)',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          'Dựa trên chế độ ăn 2000 kcal/ngày',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        ...bars
            .where((b) => b.value != null)
            .map((b) => _ProgressBar(item: b)),
      ],
    );
  }
}

class _BarItem {
  final String label;
  final double? value;
  final double dailyRef;
  final Color color;

  _BarItem(this.label, this.value, this.dailyRef, this.color);
}

class _ProgressBar extends StatelessWidget {
  final _BarItem item;

  const _ProgressBar({required this.item});

  @override
  Widget build(BuildContext context) {
    final pct = (item.value! / item.dailyRef).clamp(0.0, 1.0);
    final pctDisplay = (pct * 100).toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(
                '${item.value!.toStringAsFixed(1)}g  ($pctDisplay%)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.grey[200],
              color: item.color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
