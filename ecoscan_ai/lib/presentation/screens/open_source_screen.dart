import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OpenSourceScreen extends StatelessWidget {
  const OpenSourceScreen({super.key});

  static const _packages = [
    _Package('flutter_bloc', '^8.1.3',
        'State management sử dụng BLoC pattern', 'MIT'),
    _Package('go_router', '^13.0.0',
        'Routing có type-safety cho Flutter', 'BSD-3-Clause'),
    _Package('hive_flutter', '^1.1.0',
        'Cơ sở dữ liệu NoSQL nhẹ chạy trên thiết bị', 'Apache-2.0'),
    _Package('shared_preferences', '^2.2.2',
        'Lưu trữ key-value đơn giản', 'BSD-3-Clause'),
    _Package('mobile_scanner', '^5.0.0',
        'Quét mã vạch nhanh qua camera', 'MIT'),
    _Package('google_mlkit_text_recognition', '^0.13.0',
        'Nhận dạng văn bản OCR offline', 'MIT'),
    _Package('http', '^1.2.0',
        'Gọi HTTP API: Open Food Facts, Groq', 'BSD-3-Clause'),
    _Package('cached_network_image', '^3.3.1',
        'Tải và cache ảnh từ mạng', 'MIT'),
    _Package('fl_chart', '^0.68.0',
        'Biểu đồ cho dashboard tác động cá nhân', 'MIT'),
    _Package('google_fonts', '^6.2.1',
        'Sử dụng font Inter từ Google Fonts', 'Apache-2.0'),
    _Package('lottie', '^3.1.0',
        'Animation loading và trạng thái', 'MIT'),
    _Package('share_plus', '^9.0.0',
        'Chia sẻ dữ liệu và xuất file', 'BSD-3-Clause'),
    _Package('image_picker', '^1.0.7',
        'Chọn ảnh từ thư viện để OCR', 'Apache-2.0'),
    _Package('intl', '^0.19.0',
        'Định dạng ngày giờ và số quốc tế hóa', 'BSD-3-Clause'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mã nguồn mở')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite_outline, color: AppColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'EcoScan AI được xây dựng với sự hỗ trợ của các thư viện mã nguồn mở sau.',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ..._packages.map((pkg) => _PackageTile(package: pkg)),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Cảm ơn tất cả các nhà phát triển mã nguồn mở! 💚',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  final _Package package;

  const _PackageTile({required this.package});

  Color _licenseColor(String license) {
    switch (license) {
      case 'MIT':
        return AppColors.primary;
      case 'Apache-2.0':
        return AppColors.warning;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.widgets_outlined,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _licenseColor(package.license)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          package.license,
                          style: TextStyle(
                              fontSize: 10,
                              color: _licenseColor(package.license),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    package.version,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package.description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600], height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Package {
  final String name;
  final String version;
  final String description;
  final String license;

  const _Package(this.name, this.version, this.description, this.license);
}
