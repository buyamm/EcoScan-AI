import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/ai/ai_bloc.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';

class ProductFoundScreen extends StatelessWidget {
  final ProductModel product;

  const ProductFoundScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm thấy sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: product.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: 160,
                            height: 160,
                            fit: BoxFit.contain,
                            errorWidget: (_, __, ___) =>
                                _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                  const SizedBox(height: 24),
                  // Product info card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name.isNotEmpty
                                ? product.name
                                : 'Tên chưa xác định',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          if (product.brand.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.business_outlined,
                                    size: 14,
                                    color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  product.brand,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                          if (product.countries.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    product.countries,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (product.ingredientsText.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            Text(
                              'Thành phần: ${product.ingredientsText}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  height: 1.4),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.go('/product/detail', extra: product),
                icon: const Icon(Icons.visibility),
                label: const Text('Xem chi tiết'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AIBloc>().add(AnalyzeProduct(product));
                  context.go('/ai/loading');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary),
                icon: const Icon(Icons.psychology),
                label: const Text('Phân tích AI ngay'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.go('/scan'),
              child: const Text('Quét sản phẩm khác'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.inventory_2_outlined,
          size: 64, color: Colors.grey),
    );
  }
}
