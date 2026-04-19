import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ContributeProductScreen extends StatelessWidget {
  final String? barcode;

  const ContributeProductScreen({super.key, this.barcode});

  static const String _offContributeUrl =
      'https://world.openfoodfacts.org/cgi/product.pl';
  static const String _offAppAndroid =
      'https://play.google.com/store/apps/details?id=org.openfoodfacts.scanner';
  static const String _offAppIos =
      'https://apps.apple.com/app/open-food-facts/id588797948';

  void _launchUrl(BuildContext context, String url) {
    // Copy URL to clipboard as fallback when url_launcher is not available
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép liên kết: $url'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyBarcode(BuildContext context) {
    if (barcode == null) return;
    Clipboard.setData(ClipboardData(text: barcode!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép mã vạch: $barcode'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đóng góp sản phẩm')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Hero icon
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volunteer_activism,
                  size: 44, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Đóng góp cho cộng đồng',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Sản phẩm này chưa có trong Open Food Facts. '
            'Hãy giúp hàng triệu người bằng cách thêm thông tin sản phẩm.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 24),

          // Barcode display
          if (barcode != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mã vạch sản phẩm',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          Text(
                            barcode!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyBarcode(context),
                      icon: const Icon(Icons.copy_outlined,
                          color: AppColors.primary),
                      tooltip: 'Sao chép',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Steps
          const Text(
            'Cách đóng góp',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _StepCard(
            step: 1,
            icon: Icons.download_outlined,
            title: 'Tải ứng dụng Open Food Facts',
            description:
                'Ứng dụng chính thức giúp bạn thêm sản phẩm dễ dàng nhất.',
          ),
          _StepCard(
            step: 2,
            icon: Icons.camera_alt_outlined,
            title: 'Chụp ảnh sản phẩm',
            description:
                'Chụp ảnh mặt trước, mặt sau, thành phần và bảng dinh dưỡng.',
          ),
          _StepCard(
            step: 3,
            icon: Icons.upload_outlined,
            title: 'Tải lên và hoàn thành',
            description:
                'Điền thông tin cơ bản: tên sản phẩm, thương hiệu, thành phần.',
          ),
          const SizedBox(height: 24),

          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchUrl(context, _offAppAndroid),
              icon: const Icon(Icons.android),
              label: const Text('Tải app Android'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launchUrl(context, _offAppIos),
              icon: const Icon(Icons.apple),
              label: const Text('Tải app iOS'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _launchUrl(context, _offContributeUrl),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Thêm qua trình duyệt'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text('Quay lại'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final IconData icon;
  final String title;
  final String description;

  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(description,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
