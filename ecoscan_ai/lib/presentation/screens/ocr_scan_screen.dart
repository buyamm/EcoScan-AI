import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../blocs/ocr/ocr_bloc.dart';
import '../../core/theme/app_theme.dart';

class OCRScanScreen extends StatefulWidget {
  const OCRScanScreen({super.key});

  @override
  State<OCRScanScreen> createState() => _OCRScanScreenState();
}

class _OCRScanScreenState extends State<OCRScanScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _cameraController;
  bool _processing = false;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraController = MobileScannerController();
    context.read<OCRBloc>().add(StartOCR());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _cameraController?.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (!_capturing) _cameraController?.start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  /// Capture the current camera frame and send to OCRBloc for processing.
  Future<void> _captureFrame() async {
    if (_capturing || !mounted) return;
    setState(() => _capturing = true);

    // Stop the camera stream so we process a single still frame
    await _cameraController?.stop();

    // Take a photo using the camera via image_picker
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (!mounted) {
      setState(() => _capturing = false);
      return;
    }
    if (picked == null) {
      // User cancelled — resume camera
      await _cameraController?.start();
      setState(() => _capturing = false);
      return;
    }

    final inputImage = InputImage.fromFilePath(picked.path);
    if (mounted) {
      context.read<OCRBloc>().add(ProcessStaticImage(inputImage));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    final inputImage = InputImage.fromFilePath(picked.path);
    if (!mounted) return;
    context.read<OCRBloc>().add(ProcessStaticImage(inputImage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OCRBloc, OCRState>(
      listener: (context, state) {
        if (state is OCRIngredientsFound || state is OCRTextDetected) {
          final text = state is OCRIngredientsFound
              ? state.rawText
              : (state as OCRTextDetected).rawText;
          if (!_processing) {
            setState(() => _processing = true);
            context.go('/scan/ocr/result', extra: text);
          }
        } else if (state is OCRError) {
          setState(() => _capturing = false);
          _cameraController?.start();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text('Quét nhãn OCR'),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: () => _cameraController?.toggleTorch(),
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(controller: _cameraController!),

            // Guidance banner at top
            Positioned(
              top: 24,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Căn chỉnh vào phần THÀNH PHẦN trên nhãn sản phẩm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Target frame — landscape rectangle for ingredient label
            Center(
              child: Container(
                width: 300,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary, width: 2.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Corner accents
                    _CornerAccent(alignment: Alignment.topLeft),
                    _CornerAccent(alignment: Alignment.topRight),
                    _CornerAccent(alignment: Alignment.bottomLeft),
                    _CornerAccent(alignment: Alignment.bottomRight),
                  ],
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.75),
                padding: EdgeInsets.fromLTRB(24, 16, 24, 28 + MediaQuery.of(context).viewPadding.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Capture button (primary action)
                    GestureDetector(
                      onTap: _capturing ? null : _captureFrame,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          color: _capturing
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white.withOpacity(0.15),
                        ),
                        child: _capturing
                            ? const Padding(
                                padding: EdgeInsets.all(18),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(Icons.camera_alt,
                                color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Secondary actions row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SecondaryButton(
                          icon: Icons.photo_library_outlined,
                          label: 'Chọn từ thư viện',
                          onTap: _pickImage,
                        ),
                        _SecondaryButton(
                          icon: Icons.qr_code_scanner,
                          label: 'Mã vạch',
                          onTap: () => context.go('/scan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Corner accent decoration for the target frame.
class _CornerAccent extends StatelessWidget {
  final Alignment alignment;
  const _CornerAccent({required this.alignment});

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.topLeft ||
        alignment == Alignment.bottomLeft;
    final isTop = alignment == Alignment.topLeft ||
        alignment == Alignment.topRight;

    return Align(
      alignment: alignment,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.15),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
