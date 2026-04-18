import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_cubit.dart';

class FontSizeScreen extends StatelessWidget {
  const FontSizeScreen({super.key});

  String _label(double scale) {
    if (scale <= 0.85) return 'Nhỏ';
    if (scale <= 1.0) return 'Mặc định';
    if (scale <= 1.15) return 'Vừa';
    return 'Lớn';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final scale = state.fontSize;
        return Scaffold(
          appBar: AppBar(title: const Text('Cỡ chữ')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Xem trước',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.primary)),
                      const SizedBox(height: 8),
                      Text(
                        'Sản phẩm EcoScan AI',
                        style: TextStyle(
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phân tích thành phần và đánh giá mức độ bền vững',
                        style: TextStyle(
                            fontSize: 14 * scale, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Điểm Eco: 🟢 Tốt',
                        style: TextStyle(fontSize: 13 * scale),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cỡ chữ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _label(scale),
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('A', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        min: 0.75,
                        max: 1.3,
                        divisions: 11,
                        value: scale,
                        activeColor: AppColors.primary,
                        onChanged: (v) =>
                            context.read<SettingsCubit>().setFontSize(v),
                      ),
                    ),
                    const Text('A', style: TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('75%',
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[500])),
                    Text('130%',
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.read<SettingsCubit>().setFontSize(1.0),
                    child: const Text('Đặt lại mặc định'),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
