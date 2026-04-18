import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/ai/ai_bloc.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../core/theme/app_theme.dart';

class AILoadingScreen extends StatelessWidget {
  const AILoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AIBloc, AIState>(
      listener: (context, state) {
        if (state is AISuccess) {
          final profile = context.read<ProfileCubit>().state.profile;

          // Replace the loading screen in the stack with the result screen,
          // so the user can back to the previous screen (e.g. ProductFoundScreen).
          if (state.allergenConflicts.isNotEmpty) {
            context.pushReplacement('/product/allergen', extra: {
              'product': state.product,
              'analysis': state.analysis,
              'detectedAllergens': state.allergenConflicts,
            });
          } else if (state.lifestyleConflicts.isNotEmpty) {
            context.pushReplacement('/product/lifestyle', extra: {
              'product': state.product,
              'analysis': state.analysis,
              'userProfile': profile,
            });
          } else {
            context.pushReplacement('/product/score', extra: {
              'product': state.product,
              'analysis': state.analysis,
            });
          }
        } else if (state is AIError) {
          context.pushReplacement('/ai/error', extra: state.message);
        }
      },
      child: PopScope(
        // Prevent accidental app exit during AI analysis; user must tap "Hủy"
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {},
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PulsingBrainIcon(),
                const SizedBox(height: 28),
                const Text(
                  'Đang phân tích AI...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI đang đánh giá thành phần sản phẩm',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 24),
                const LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.backgroundLight,
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => context.go('/scan'),
                  child: const Text('Hủy'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsingBrainIcon extends StatefulWidget {
  const _PulsingBrainIcon();

  @override
  State<_PulsingBrainIcon> createState() => _PulsingBrainIconState();
}

class _PulsingBrainIconState extends State<_PulsingBrainIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.psychology, color: AppColors.primary, size: 52),
      ),
    );
  }
}
