import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class ScoreBreakdownScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;
  final bool fromCache;

  const ScoreBreakdownScreen({
    super.key,
    this.product,
    required this.analysis,
    this.fromCache = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích điểm số'),
        actions: [
          if (fromCache)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Chip(
                label: const Text('Từ cache',
                    style: TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: AppColors.primary.withOpacity(0.7),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.push('/product/score/explain'),
            tooltip: 'Cách tính điểm',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall score
          _OverallScoreCard(analysis: analysis),
          const SizedBox(height: 20),
          // Three sub-score gauges
          const SectionHeader(title: 'Điểm chi tiết'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SubScoreItem(
                score: analysis.health.score,
                label: 'Sức khỏe',
                icon: Icons.favorite_outline,
                onTap: () => context.push('/product/health', extra: {
                  'product': product,
                  'analysis': analysis,
                }),
              ),
              _SubScoreItem(
                score: analysis.environment.score,
                label: 'Môi trường',
                icon: Icons.eco_outlined,
                onTap: () => context.push('/product/environment', extra: {
                  'product': product,
                  'analysis': analysis,
                }),
              ),
              _SubScoreItem(
                score: analysis.ethics.score,
                label: 'Đạo đức',
                icon: Icons.balance_outlined,
                onTap: () => context.push('/product/ethics', extra: {
                  'product': product,
                  'analysis': analysis,
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Score formula note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tổng điểm = Sức khỏe×40% + Môi trường×40% + Đạo đức×20%',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Summary
          const SectionHeader(title: 'Tóm tắt đánh giá'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                analysis.summary,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/product/ingredients', extra: {
                'product': product,
                'analysis': analysis,
              }),
              icon: const Icon(Icons.list_alt),
              label: const Text('Xem thành phần'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push('/product/ai', extra: {
                'product': product,
                'analysis': analysis,
              }),
              icon: const Icon(Icons.psychology),
              label: const Text('Phân tích AI đầy đủ'),
            ),
          ),
          // Show alternatives button when score is below 70
          if (analysis.overallScore < 70 && product != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/product/alternatives', extra: {
                  'product': product,
                  'analysis': analysis,
                }),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Xem sản phẩm thay thế tốt hơn'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  side: const BorderSide(color: AppColors.warning),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OverallScoreCard extends StatelessWidget {
  final AIAnalysisModel analysis;

  const _OverallScoreCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Điểm tổng thể',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ScoreGauge(score: analysis.overallScore, label: 'Eco Score', size: 130),
            const SizedBox(height: 12),
            EcoScoreChip(
              level: analysis.level,
              score: analysis.overallScore,
              showScore: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubScoreItem extends StatelessWidget {
  final int score;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SubScoreItem({
    required this.score,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ScoreGauge(score: score, label: label, size: 90),
          const SizedBox(height: 6),
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(height: 2),
          Text(
            'Chi tiết →',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
