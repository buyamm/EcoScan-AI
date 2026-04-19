import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/scan_record.dart';
import '../../data/models/ai_analysis_model.dart';
import '../widgets/eco_score_chip.dart';
import '../widgets/score_gauge.dart';

class HistoryDetailScreen extends StatelessWidget {
  final ScanRecord record;

  const HistoryDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final analysis = record.analysis;
    final product = record.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name.isNotEmpty ? product.name : 'Chi tiết lịch sử',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (product.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      ),
                    )
                  else
                    _imagePlaceholder(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name.isNotEmpty ? product.name : 'Không có tên',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        if (product.brand.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(product.brand,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600])),
                        ],
                        const SizedBox(height: 6),
                        EcoScoreChip(
                            level: analysis.level,
                            score: analysis.overallScore,
                            showScore: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Scan metadata
          _MetaRow(
            icon: Icons.calendar_today_outlined,
            label: 'Thời gian quét',
            value: _formatDateTime(record.scannedAt),
          ),
          _MetaRow(
            icon: Icons.qr_code_scanner,
            label: 'Phương thức',
            value: _scanMethodLabel(record.scanMethod),
          ),
          const SizedBox(height: 16),
          // Score breakdown
          const Text('Điểm chi tiết',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MiniScore(
                  score: analysis.health.score,
                  label: 'Sức khỏe',
                  icon: Icons.favorite_outline),
              _MiniScore(
                  score: analysis.environment.score,
                  label: 'Môi trường',
                  icon: Icons.eco_outlined),
              _MiniScore(
                  score: analysis.ethics.score,
                  label: 'Đạo đức',
                  icon: Icons.balance_outlined),
            ],
          ),
          const SizedBox(height: 16),
          // Summary
          const Text('Tóm tắt AI',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                analysis.summary.isNotEmpty
                    ? analysis.summary
                    : 'Không có tóm tắt.',
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Xem phân tích đầy đủ'),
              onPressed: () => context.push('/product/score', extra: {
                'product': product,
                'analysis': analysis,
              }),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('Xem thành phần'),
              onPressed: () => context.push('/product/ingredients', extra: {
                'product': product,
                'analysis': analysis,
              }),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 32),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _scanMethodLabel(String method) {
    switch (method) {
      case 'barcode':
        return '📷 Mã vạch';
      case 'ocr':
        return '🔍 OCR';
      case 'manual':
        return '✏️ Nhập tay';
      default:
        return method;
    }
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text('$label: ',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _MiniScore extends StatelessWidget {
  final int score;
  final String label;
  final IconData icon;

  const _MiniScore(
      {required this.score, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScoreGauge(score: score, label: label, size: 80),
        const SizedBox(height: 4),
        Icon(icon, size: 16, color: Colors.grey[500]),
      ],
    );
  }
}
