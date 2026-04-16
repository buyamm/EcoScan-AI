import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../core/theme/app_theme.dart';

class CustomAllergyScreen extends StatefulWidget {
  const CustomAllergyScreen({super.key});

  @override
  State<CustomAllergyScreen> createState() => _CustomAllergyScreenState();
}

class _CustomAllergyScreenState extends State<CustomAllergyScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Vui lòng nhập tên dị ứng');
      return;
    }
    await context.read<ProfileCubit>().addCustomAllergen(text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm dị ứng "$text"'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm dị ứng tùy chỉnh')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 16),
            const Text('Dị ứng tùy chỉnh',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Nhập tên chất bạn bị dị ứng mà không có trong danh sách tiêu chuẩn',
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Tên dị ứng',
                hintText: 'Ví dụ: Cà phê, Tôm hùm,...',
                errorText: _error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                prefixIcon:
                    const Icon(Icons.warning_amber_outlined, color: AppColors.danger),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _add(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _add,
                child: const Text('Thêm dị ứng'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Hủy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
