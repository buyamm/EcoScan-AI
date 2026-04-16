import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImpactEmptyScreen extends StatelessWidget {
  /// When true, renders as an embedded widget (no Scaffold wrapper).
  final bool embedded;

  const ImpactEmptyScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📊', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            const Text(
              'Chưa đủ dữ liệu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'Quét thêm sản phẩm để xem thống kê và biểu đồ tác động cá nhân.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.go('/scan'),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Quét sản phẩm ngay'),
            ),
          ],
        ),
      ),
    );

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Tác động cá nhân')),
      body: body,
    );
  }
}
