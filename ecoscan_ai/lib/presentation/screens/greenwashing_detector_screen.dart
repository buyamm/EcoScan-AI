import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class GreenwashingDetectorScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const GreenwashingDetectorScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final gw = analysis.greenwashing;

    return Scaffold(
      appBar: AppBar(title: const Text('Phát hiện Greenwashing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall badge
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco_outlined, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'Kết quả kiểm tra',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GreenwashingBadge(level: gw.level),
                  const SizedBox(height: 12),
                  Text(
                    _levelDescription(gw.level),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (gw.claims.isEmpty) ...[
            const SectionHeader(title: 'Tuyên bố marketing'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Không có tuyên bố đặc biệt nào được phát hiện trên sản phẩm này.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SectionHeader(title: 'Tuyên bố cần kiểm chứng'),
            ...gw.claims.map((claim) {
              return _ClaimCard(
                claim: claim,
                level: gw.level,
                onTap: () => context.go(
                  '/product/greenwashing/detail',
                  extra: {'claim': claim, 'level': gw.level},
                ),
              );
            }),
          ],

          // What is greenwashing info
          const SizedBox(height: 16),
          const SectionHeader(title: 'Greenwashing là gì?'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Greenwashing là khi doanh nghiệp tuyên bố sản phẩm thân thiện môi trường nhưng thực tế không đúng như vậy.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  ..._greenwashingExamples.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, size: 6, color: AppColors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(e, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _levelDescription(GreenwashingLevel level) {
    switch (level) {
      case GreenwashingLevel.none:
        return 'Chúng tôi không phát hiện mâu thuẫn giữa tuyên bố marketing và thành phần thực tế của sản phẩm này.';
      case GreenwashingLevel.suspected:
        return 'Có một số tuyên bố marketing cần xem xét kỹ hơn. Thành phần thực tế có thể không hoàn toàn tương ứng với các tuyên bố này.';
      case GreenwashingLevel.confirmed:
        return 'Phát hiện mâu thuẫn rõ ràng giữa tuyên bố marketing và thành phần thực tế. Sản phẩm này có dấu hiệu greenwashing.';
    }
  }

  static const _greenwashingExamples = [
    'Tuyên bố "100% tự nhiên" nhưng chứa hóa chất tổng hợp',
    'Nhãn "eco-friendly" nhưng không có chứng nhận cụ thể',
    'Quảng cáo "xanh" nhưng thành phần có hại cho môi trường',
  ];
}

class _ClaimCard extends StatelessWidget {
  final GreenwashingClaim claim;
  final GreenwashingLevel level;
  final VoidCallback onTap;

  const _ClaimCard({
    required this.claim,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = level == GreenwashingLevel.confirmed
        ? AppColors.danger
        : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Tuyên bố',
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '"${claim.claim}"',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                claim.reality,
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
