import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class EthicsAnalysisScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const EthicsAnalysisScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final ethics = analysis.ethics;

    return Scaffold(
      appBar: AppBar(title: const Text('Phân tích đạo đức')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Score gauge
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ScoreGauge(score: ethics.score, label: 'Đạo đức', size: 120),
                  const SizedBox(height: 8),
                  Text(
                    _scoreDesc(ethics.score),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Cruelty-free / Vegan status
          const SectionHeader(title: 'Tiêu chí đạo đức'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _EthicsStatusRow(
                    label: 'Không thử nghiệm động vật (Cruelty-free)',
                    icon: Icons.pets_outlined,
                    value: ethics.crueltyFree,
                  ),
                  const Divider(height: 20),
                  _EthicsStatusRow(
                    label: 'Thuần chay (Vegan)',
                    icon: Icons.grass_outlined,
                    value: ethics.vegan,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Concerns
          if (ethics.concerns.isNotEmpty) ...[
            const SectionHeader(title: 'Lo ngại đạo đức'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: ethics.concerns
                      .map((c) => _ItemRow(
                            text: c,
                            color: AppColors.danger,
                            icon: Icons.warning_amber_outlined,
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Lifestyle compatibility
          const SectionHeader(title: 'Phù hợp với'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (analysis.suitableFor.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: analysis.suitableFor
                          .map((s) => _LifestyleChip(label: s, suitable: true))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (analysis.notSuitableFor.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Không phù hợp:',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: analysis.notSuitableFor
                          .map((s) => _LifestyleChip(label: s, suitable: false))
                          .toList(),
                    ),
                  ],
                  if (analysis.suitableFor.isEmpty &&
                      analysis.notSuitableFor.isEmpty)
                    Text(
                      'Không có thông tin về đối tượng phù hợp.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _scoreDesc(int score) {
    if (score >= 70) return 'Sản phẩm đáp ứng tốt các tiêu chuẩn đạo đức.';
    if (score >= 40) return 'Sản phẩm có một số điểm cần cải thiện về đạo đức.';
    return 'Sản phẩm có nhiều lo ngại về tiêu chuẩn đạo đức.';
  }
}

class _EthicsStatusRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool? value;

  const _EthicsStatusRow({
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final color = value == null
        ? Colors.grey
        : value!
            ? AppColors.primary
            : AppColors.danger;
    final statusIcon = value == null
        ? Icons.help_outline
        : value!
            ? Icons.check_circle_outline
            : Icons.cancel_outlined;
    final statusText = value == null ? 'Không xác định' : value! ? 'Có' : 'Không';

    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Icon(statusIcon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(statusText,
            style: TextStyle(
                fontSize: 13, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _ItemRow({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey[700], height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _LifestyleChip extends StatelessWidget {
  final String label;
  final bool suitable;

  const _LifestyleChip({required this.label, required this.suitable});

  @override
  Widget build(BuildContext context) {
    final color = suitable ? AppColors.primary : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
