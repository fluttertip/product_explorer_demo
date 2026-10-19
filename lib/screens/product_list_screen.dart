import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_shimmer.dart';
import '../widgets/state_message.dart';
import 'favorites_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch(ProductProvider provider) {
    _searchController.clear();
    provider.search('');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final favoriteCount = context.select<FavoritesProvider, int>((f) => f.count);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
            icon: Badge(
              isLabelVisible: favoriteCount > 0,
              label: Text('$favoriteCount'),
              child: const Icon(Icons.favorite_border_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: provider.search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search by name, brand or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: provider.query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _clearSearch(provider),
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    switch (provider.status) {
      case LoadStatus.loading:
        return const ProductListShimmer();

      case LoadStatus.error:
        return StateMessage(
          icon: Icons.wifi_off_rounded,
          title: "Couldn't load products",
          message: provider.error,
          actionLabel: 'Try again',
          onAction: provider.fetchProducts,
        );

      case LoadStatus.loaded:
        final items = provider.visibleProducts;

        if (items.isEmpty) {
          final searching = provider.query.trim().isNotEmpty;
          return StateMessage(
            icon: searching ? Icons.search_off_rounded : Icons.inventory_2_outlined,
            title: searching ? 'No matches found' : 'No products yet',
            message: searching
                ? 'Nothing matches "${provider.query.trim()}". Try a different keyword.'
                : 'There is nothing to show right now. Tap refresh to check again.',
            actionLabel: searching ? 'Clear search' : 'Refresh',
            onAction: searching ? () => _clearSearch(provider) : provider.fetchProducts,
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProducts(showLoader: false),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
          ),
        );
    }
  }
}
