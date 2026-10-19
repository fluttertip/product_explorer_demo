import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/product_provider.dart';
import 'screens/product_list_screen.dart';
import 'services/favorites_storage.dart';
import 'services/product_api.dart';

void main() => runApp(const ProductExplorerApp());

class ProductExplorerApp extends StatelessWidget {
  const ProductExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductApi())..fetchProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(FavoritesStorage())..load(),
        ),
      ],
      child: MaterialApp(
        title: 'Product Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
          scaffoldBackgroundColor: const Color(0xFFF7F7FA),
          appBarTheme: const AppBarTheme(centerTitle: false),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
