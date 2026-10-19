import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_shimmer.dart';
import '../widgets/state_message.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final items = products.products.where((p) => favorites.isFavorite(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: _buildBody(context, products, favorites, items),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProductProvider products,
    FavoritesProvider favorites,
    List items,
  ) {
    if (products.status == LoadStatus.loading) {
      return const ProductListShimmer(count: 3);
    }

    if (items.isEmpty && favorites.count > 0 && products.status == LoadStatus.error) {
      return StateMessage(
        icon: Icons.wifi_off_rounded,
        title: "Couldn't load your favorites",
        message: products.error,
        actionLabel: 'Try again',
        onAction: products.fetchProducts,
      );
    }

    if (items.isEmpty) {
      return const StateMessage(
        icon: Icons.favorite_border_rounded,
        title: 'No favorites yet',
        message: 'Tap the heart on any product to save it here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return ProductCard(
          product: product,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
          ),
        );
      },
    );
  }
}
