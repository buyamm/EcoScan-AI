import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class IngredientBreakdownScreen extends StatefulWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const IngredientBreakdownScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  State<IngredientBreakdownScreen> createState() =>
      _IngredientBreakdownScreenState();
}

class _IngredientBreakdownScreenState extends State<IngredientBreakdownScreen> {
  IngredientSafety? _filter;

  List<IngredientAnalysis> get _filtered {
    final all = widget.analysis.ingredients;
    if (_filter == null) return all;
    return all.where((i) => i.safety == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final all = widget.analysis.ingredients;
    final safeCount = all.where((i) => i.safety == IngredientSafety.safe).length;
    final cautionCount = all.where((i) => i.safety == IngredientSafety.caution).length;
    final avoidCount = all.where((i) => i.safety == IngredientSafety.avoid).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành phần'),
        actions: [
          if (_filter != null)
            TextButton(
              onPressed: () => setState(() => _filter = null),
              child: const Text('Xóa lọc', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Summary chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _FilterChip(
                  label: 'An toàn ($safeCount)',
                  color: AppColors.primary,
                  selected: _filter == IngredientSafety.safe,
                  onTap: () => setState(() {
                    _filter = _filter == IngredientSafety.safe
                        ? null
                        : IngredientSafety.safe;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Cẩn thận ($cautionCount)',
                  color: AppColors.warning,
                  selected: _filter == IngredientSafety.caution,
                  onTap: () => setState(() {
                    _filter = _filter == IngredientSafety.caution
                        ? null
                        : IngredientSafety.caution;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Tránh ($avoidCount)',
                  color: AppColors.danger,
                  selected: _filter == IngredientSafety.avoid,
                  onTap: () => setState(() {
                    _filter = _filter == IngredientSafety.avoid
                        ? null
                        : IngredientSafety.avoid;
                  }),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'Không có thành phần nào',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final ingredient = _filtered[index];
                      return IngredientCard(
                        ingredient: ingredient,
                        onTap: () => context.go(
                          '/ingredient/detail',
                          extra: ingredient,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
