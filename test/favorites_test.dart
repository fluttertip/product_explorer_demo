import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/providers/favorites_provider.dart';
import 'package:product_explorer/services/favorites_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toggle adds and removes a favorite', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = FavoritesProvider(FavoritesStorage());

    await provider.toggle(3);
    expect(provider.isFavorite(3), true);

    await provider.toggle(3);
    expect(provider.isFavorite(3), false);
  });

  test('favorites survive a reload', () async {
    SharedPreferences.setMockInitialValues({});
    await FavoritesProvider(FavoritesStorage()).toggle(7);

    final fresh = FavoritesProvider(FavoritesStorage());
    await fresh.load();

    expect(fresh.isFavorite(7), true);
    expect(fresh.count, 1);
  });
}
