import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductImageScreen extends StatefulWidget {
  final String imageUrl;

  const ProductImageScreen({super.key, required this.imageUrl});

  @override
  State<ProductImageScreen> createState() => _ProductImageScreenState();
}

class _ProductImageScreenState extends State<ProductImageScreen> {
  final TransformationController _transformController =
      TransformationController();
  bool _isZoomed = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
    setState(() => _isZoomed = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ảnh sản phẩm',
            style: TextStyle(color: Colors.white)),
        actions: [
          if (_isZoomed)
            IconButton(
              onPressed: _resetZoom,
              icon: const Icon(Icons.zoom_out_map, color: Colors.white),
              tooltip: 'Đặt lại zoom',
            ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTap: () {
          if (_isZoomed) {
            _resetZoom();
          } else {
            _transformController.value = Matrix4.identity()..scale(2.5);
            setState(() => _isZoomed = true);
          }
        },
        child: InteractiveViewer(
          transformationController: _transformController,
          minScale: 0.5,
          maxScale: 5.0,
          onInteractionEnd: (details) {
            final scale = _transformController.value.getMaxScaleOnAxis();
            setState(() => _isZoomed = scale > 1.01);
          },
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
              placeholder: (_, __) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (_, __, ___) => const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image_outlined,
                        color: Colors.white54, size: 64),
                    SizedBox(height: 12),
                    Text('Không tải được ảnh',
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pinch_outlined, color: Colors.white38, size: 16),
            SizedBox(width: 6),
            Text(
              'Chụm/giãn để phóng to • Nhấn đúp để zoom nhanh',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
