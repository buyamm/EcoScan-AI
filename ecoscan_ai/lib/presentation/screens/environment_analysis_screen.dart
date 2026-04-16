import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class EnvironmentAnalysisScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const EnvironmentAnalysisScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final env = analysis.environment;

    return Scaffold(
      appBar: AppBar(title: const Text('Phân tích môi trường')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Score gauge
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ScoreGauge(score: env.score, label: 'Môi trường', size: 120),
                  const SizedBox(height: 8),
                  Text(
                    _scoreDesc(env.score),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Eco impact summary chips
          const SectionHeader(title: 'Tác động môi trường'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildImpactChips(),
            ),
          ),
          const SizedBox(height: 16),
          // Positives
          if (env.positives.isNotEmpty) ...[
            const SectionHeader(title: 'Điểm tích cực'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: env.positives
                      .map((p) => _ItemRow(
                          text: p,
                          color: AppColors.primary,
                          icon: Icons.eco_outlined))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Concerns
          if (env.concerns.isNotEmpty) ...[
            const SectionHeader(title: 'Điểm lo ngại'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: env.concerns
                      .map((c) => _ItemRow(
                          text: c,
                          color: AppColors.danger,
                          icon: Icons.warning_amber_outlined))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildImpactChips() {
    final chips = <Widget>[];
    final concernsLower = analysis.environment.concerns
        .map((c) => c.toLowerCase())
        .toList();

    final hasMicroplastics =
        concernsLower.any((c) => c.contains('micro') || c.contains('nhựa'));
    final hasBiodegradable =
        analysis.environment.positives.any((p) =>
            p.toLowerCase().contains('phân hủy') ||
            p.toLowerCase().contains('biodegradable'));

    if (hasMicroplastics) {
      chips.add(_ImpactChip(
          label: 'Vi nhựa', color: AppColors.danger, icon: Icons.dangerous_outlined));
    }
    if (hasBiodegradable) {
      chips.add(_ImpactChip(
          label: 'Phân hủy sinh học', color: AppColors.primary, icon: Icons.recycling));
    }
    if (chips.isEmpty) {
      chips.add(_ImpactChip(
          label: 'Đang đánh giá', color: Colors.grey, icon: Icons.hourglass_empty));
    }
    return chips;
  }

  String _scoreDesc(int score) {
    if (score >= 70) return 'Sản phẩm thân thiện với môi trường.';
    if (score >= 40) return 'Sản phẩm có một số tác động môi trường cần lưu ý.';
    return 'Sản phẩm có tác động đáng kể đến môi trường.';
  }
}

class _ImpactChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _ImpactChip({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
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
