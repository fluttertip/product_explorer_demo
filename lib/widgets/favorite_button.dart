import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.productId, this.size = 24});

  final int productId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>((f) => f.isFavorite(productId));

    return IconButton(
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () => context.read<FavoritesProvider>().toggle(productId),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFavorite),
          size: size,
          color: isFavorite ? const Color(0xFFEF4444) : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
