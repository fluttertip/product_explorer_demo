import 'package:flutter/material.dart';

import '../core/format.dart';
import '../models/product.dart';
import '../widgets/favorite_button.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_badge.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _page = 0;

  Product get product => widget.product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [FavoriteButton(productId: product.id), const SizedBox(width: 4)],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _gallery(theme),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.2,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.title,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${product.brand}',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 16),
                _priceRow(theme),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RatingBadge(rating: product.rating),
                    const SizedBox(width: 6),
                    Text(
                      '(${product.reviews.length} reviews)',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                    ),
                    const Spacer(),
                    _stockChip(),
                  ],
                ),
                const SizedBox(height: 20),
                Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(product.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
                if (product.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.tags.map((t) => Chip(label: Text(t))).toList(),
                  ),
                ],
                const SizedBox(height: 24),
                _infoCard(theme),
                const SizedBox(height: 24),
                _reviews(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gallery(ThemeData theme) {
    final images = product.images;

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: images.isEmpty
              ? const ProductImage(url: '')
              : PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) {
                    final image = ProductImage(url: images[i], fit: BoxFit.contain);
                    return i == 0 ? Hero(tag: 'product-${product.id}', child: image) : image;
                  },
                ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _priceRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          money(product.discountedPrice),
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (product.hasDiscount) ...[
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              money(product.price),
              style: theme.textTheme.titleSmall?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '-${product.discountPercentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Color(0xFF166534),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _stockChip() {
    final inStock = product.stock > 0;
    final low = inStock && product.stock <= 10;
    final color = !inStock
        ? const Color(0xFFDC2626)
        : low
            ? const Color(0xFFD97706)
            : const Color(0xFF16A34A);
    final label = !inStock
        ? 'Out of stock'
        : low
            ? 'Only ${product.stock} left'
            : 'In stock';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _infoCard(ThemeData theme) {
    final rows = <MapEntry<String, String>>[
      MapEntry('SKU', product.sku),
      MapEntry('Warranty', product.warrantyInformation),
      MapEntry('Shipping', product.shippingInformation),
      MapEntry('Returns', product.returnPolicy),
      MapEntry('Min. order', '${product.minimumOrderQuantity}'),
    ].where((e) => e.value.isNotEmpty).toList();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 96,
                      child: Text(
                        rows[i].key,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rows[i].value,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              if (i != rows.length - 1) Divider(height: 1, color: theme.colorScheme.outlineVariant),
            ],
          ],
        ),
      ),
    );
  }

  Widget _reviews(ThemeData theme) {
    if (product.reviews.isEmpty) {
      return Text(
        'No reviews yet.',
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...product.reviews.map(
          (r) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(r.reviewerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < r.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 16,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(r.comment),
                const SizedBox(height: 6),
                Text(
                  shortDate(r.date),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
