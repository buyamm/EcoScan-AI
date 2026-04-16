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
      _cameraController?.start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
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
            // OCR overlay hint
            Positioned(
              top: 24,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Hướng camera vào danh sách thành phần trên nhãn sản phẩm',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Target frame
            Center(
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.secondary, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Bottom buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Chọn ảnh'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/scan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Mã vạch'),
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
