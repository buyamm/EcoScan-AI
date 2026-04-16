import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NetworkErrorScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  const NetworkErrorScreen({
    super.key,
    this.message,
    this.onRetry,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lỗi kết nối')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_outlined,
                  size: 48,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Không có kết nối mạng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message ??
                    'Vui lòng kiểm tra kết nối Wi-Fi hoặc dữ liệu di động và thử lại.',
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[600], height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ),
              if (onRetry != null && onGoHome != null) const SizedBox(height: 12),
              if (onGoHome != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onGoHome,
                    child: const Text('Về trang chủ'),
                  ),
                ),
              const SizedBox(height: 24),
              // Tips
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: _tips
                      .map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.circle,
                                    size: 6,
                                    color: Colors.grey[500]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _tips = [
    'Kiểm tra Wi-Fi hoặc dữ liệu di động đang bật',
    'Di chuyển đến vùng phủ sóng tốt hơn',
    'Tắt và bật lại chế độ máy bay',
  ];
}
