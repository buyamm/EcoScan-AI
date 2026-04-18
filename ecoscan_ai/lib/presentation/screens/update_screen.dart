import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool _checking = false;
  _UpdateStatus _status = _UpdateStatus.idle;

  static const _currentVersion = '1.0.0';

  Future<void> _checkUpdate() async {
    setState(() {
      _checking = true;
      _status = _UpdateStatus.idle;
    });
    // Simulate check (no real update API)
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _checking = false;
        _status = _UpdateStatus.upToDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiểm tra cập nhật')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: _checking
                  ? const CircularProgressIndicator(
                      color: AppColors.primary, strokeWidth: 3)
                  : Icon(
                      _status == _UpdateStatus.upToDate
                          ? Icons.check_circle_outline
                          : Icons.system_update_outlined,
                      color: AppColors.primary,
                      size: 52,
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              _checking
                  ? 'Đang kiểm tra...'
                  : _status == _UpdateStatus.upToDate
                      ? 'Bạn đang dùng phiên bản mới nhất!'
                      : 'Kiểm tra cập nhật',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Phiên bản hiện tại: $_currentVersion',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (_status == _UpdateStatus.upToDate) ...[
              const SizedBox(height: 8),
              Text(
                'Kiểm tra lần cuối: vừa xong',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
            const Spacer(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Changelog v1.0.0',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _ChangeItem('Phiên bản đầu tiên của EcoScan AI'),
                    _ChangeItem('Quét mã vạch và OCR nhãn sản phẩm'),
                    _ChangeItem('Phân tích AI với Groq Llama 3.3 70B'),
                    _ChangeItem('Dashboard lịch sử quét và tác động cá nhân'),
                    _ChangeItem('Hỗ trợ tiếng Việt và tiếng Anh'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _checking ? null : _checkUpdate,
                icon: const Icon(Icons.refresh),
                label: const Text('Kiểm tra cập nhật'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}

class _ChangeItem extends StatelessWidget {
  final String text;

  const _ChangeItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary)),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}

enum _UpdateStatus { idle, upToDate, updateAvailable }
