import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class HistoryEmptyScreen extends StatelessWidget {
  /// When true, renders as an embedded widget (no Scaffold wrapper).
  final bool embedded;

  const HistoryEmptyScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📋', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            const Text(
              'Chưa có lịch sử quét',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'Bắt đầu quét sản phẩm để xây dựng lịch sử tiêu dùng của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.go('/scan'),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Quét sản phẩm đầu tiên'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.go('/home/dashboard'),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử quét')),
      body: body,
    );
  }
}
