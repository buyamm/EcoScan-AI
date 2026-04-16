import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../../core/theme/app_theme.dart';

class ShareImpactScreen extends StatefulWidget {
  final int total;
  final int green;
  final int yellow;
  final int red;
  final int avgScore;

  const ShareImpactScreen({
    super.key,
    required this.total,
    required this.green,
    required this.yellow,
    required this.red,
    required this.avgScore,
  });

  @override
  State<ShareImpactScreen> createState() => _ShareImpactScreenState();
}

class _ShareImpactScreenState extends State<ShareImpactScreen> {
  final _repaintKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final boundary = _repaintKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: 'image/png', name: 'ecoscan_impact.png')],
        text: 'Tác động tiêu dùng của tôi với EcoScan AI 🌿',
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chia sẻ tác động')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Xem trước ảnh chia sẻ',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Preview card (repaintable)
          RepaintBoundary(
            key: _repaintKey,
            child: _ImpactCard(
              total: widget.total,
              green: widget.green,
              yellow: widget.yellow,
              red: widget.red,
              avgScore: widget.avgScore,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sharing ? null : _share,
              icon: _sharing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.share),
              label:
                  Text(_sharing ? 'Đang chia sẻ...' : 'Chia sẻ ngay'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final int total;
  final int green;
  final int yellow;
  final int red;
  final int avgScore;

  const _ImpactCard({
    required this.total,
    required this.green,
    required this.yellow,
    required this.red,
    required this.avgScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌿', style: TextStyle(fontSize: 28)),
              SizedBox(width: 10),
              Text(
                'EcoScan AI',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CardStat(value: '$total', label: 'Lần quét'),
              _CardStat(value: '$avgScore', label: 'Điểm TB'),
              _CardStat(
                  value: '${(green / total * 100).round()}%',
                  label: 'Sản phẩm xanh'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _PillStat(
                  emoji: '🟢', value: '$green', color: Colors.green[300]!),
              const SizedBox(width: 8),
              _PillStat(
                  emoji: '🟡',
                  value: '$yellow',
                  color: Colors.yellow[600]!),
              const SizedBox(width: 8),
              _PillStat(
                  emoji: '🔴', value: '$red', color: Colors.red[400]!),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tiêu dùng có trách nhiệm cho tương lai xanh 🌍',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  final String value;
  final String label;

  const _CardStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800)),
        Text(label,
            style:
                const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _PillStat extends StatelessWidget {
  final String emoji;
  final String value;
  final Color color;

  const _PillStat(
      {required this.emoji, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
