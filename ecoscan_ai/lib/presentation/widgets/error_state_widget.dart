import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Generic error state widget with icon, message, and retry button.
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.retryLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(retryLabel ?? 'Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
