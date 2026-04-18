import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/scan/scan_bloc.dart';
import '../blocs/ai/ai_bloc.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class ScanLoadingScreen extends StatelessWidget {
  final String barcode;

  const ScanLoadingScreen({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanSuccess) {
              context.go('/product/found', extra: state.product);
            } else if (state is ScanError) {
              if (state.type == ScanErrorType.productNotFound) {
                context.go('/product/not-found', extra: state.barcode);
              } else {
                context.go('/error/network');
              }
            }
          },
        ),
        BlocListener<AIBloc, AIState>(
          listener: (context, state) {
            if (state is AISuccess) {
              final profile = context.read<ProfileCubit>().state.profile;
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
        ),
      ],
      child: PopScope(
        // Prevent accidental app exit while loading; user must tap "Hủy"
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {},
        child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const _PulseIcon(),
              ),
              const SizedBox(height: 28),
              Text(
                AppLocalizations.of(context).scanLoading,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                barcode,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => context.go('/scan'),
                child: Text(AppLocalizations.of(context).cancel),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _PulseIcon extends StatefulWidget {
  const _PulseIcon();

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.6, end: 1.0).animate(_ctrl);
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
      child: const Icon(Icons.inventory_2_outlined,
          color: AppColors.primary, size: 48),
    );
  }
}
