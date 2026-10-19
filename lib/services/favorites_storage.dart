import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const _key = 'favorite_product_ids';

  Future<Set<int>> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_key) ?? [];
      return saved.map(int.tryParse).whereType<int>().toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> write(Set<int> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, ids.map((e) => e.toString()).toList());
    } catch (_) {}
  }
}
