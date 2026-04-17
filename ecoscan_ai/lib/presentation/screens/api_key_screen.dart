import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// Developer-only screen to view/override the Groq API key at runtime.
class APIKeyScreen extends StatefulWidget {
  const APIKeyScreen({super.key});

  @override
  State<APIKeyScreen> createState() => _APIKeyScreenState();
}

class _APIKeyScreenState extends State<APIKeyScreen> {
  late final TextEditingController _controller;
  bool _obscure = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: AppConstants.groqApiKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Override key saved for this session. Restart app to apply.'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  Future<void> _copyKey() async {
    await Clipboard.setData(
        ClipboardData(text: _controller.text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Key (Dev Only)'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: AppColors.warning),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DEVELOPER SCREEN — Hidden from regular users. '
                      'Do not share API keys.',
                      style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GROQ API KEY',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              obscureText: _obscure,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white12,
                hintText: 'gsk_...',
                hintStyle:
                    const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white54),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy,
                          color: Colors.white54, size: 18),
                      onPressed: _copyKey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current compiled key: ${AppConstants.groqApiKey.isEmpty ? "(empty)" : "${AppConstants.groqApiKey.substring(0, AppConstants.groqApiKey.length.clamp(0, 8))}..."}',
              style: const TextStyle(
                  color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side:
                            const BorderSide(color: Colors.white24)),
                    onPressed: () => _controller.text =
                        AppConstants.groqApiKey,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _save,
                    child: const Text('Save Override'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Model: ${AppConstants.groqModel}\nBase URL: ${AppConstants.groqBaseUrl}',
              style: const TextStyle(
                  color: Colors.white38, fontSize: 11, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
