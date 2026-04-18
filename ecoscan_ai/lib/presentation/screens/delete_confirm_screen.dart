import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_cubit.dart';
import '../blocs/history/history_cubit.dart';

class DeleteConfirmScreen extends StatefulWidget {
  const DeleteConfirmScreen({super.key});

  @override
  State<DeleteConfirmScreen> createState() => _DeleteConfirmScreenState();
}

class _DeleteConfirmScreenState extends State<DeleteConfirmScreen> {
  bool _deleting = false;

  Future<void> _deleteAll() async {
    setState(() => _deleting = true);
    try {
      // Clear scan history via cubit (which has access to repository)
      await context.read<HistoryCubit>().clearAll();
      // Clear settings via settings cubit
      await context.read<SettingsCubit>().clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa toàn bộ dữ liệu'),
            backgroundColor: AppColors.primary,
          ),
        );
        context.go('/home/dashboard');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _deleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xóa dữ liệu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận xóa'),
        backgroundColor: AppColors.danger,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever,
                color: AppColors.danger,
                size: 56,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Xóa toàn bộ dữ liệu?',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Lịch sử quét, hồ sơ cá nhân, cache sản phẩm và tất cả cài đặt sẽ bị xóa vĩnh viễn.\n\nHành động này không thể hoàn tác.',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.6),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _deleting ? null : _deleteAll,
                icon: _deleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.delete_forever),
                label: Text(_deleting ? 'Đang xóa...' : 'Xác nhận xóa tất cả'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _deleting ? null : () => context.pop(),
                child: const Text('Hủy, giữ lại dữ liệu'),
              ),
            ),
            SizedBox(height: 16 + MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}
