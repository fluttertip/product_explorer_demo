import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'product_shimmer.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    if (url.isEmpty) {
      return Container(color: color, child: const Icon(Icons.image_not_supported_outlined));
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, __) => const ShimmerBox(radius: 0),
      errorWidget: (_, __, ___) => Container(
        color: color,
        child: const Icon(Icons.broken_image_outlined),
      ),
    );
  }
}
