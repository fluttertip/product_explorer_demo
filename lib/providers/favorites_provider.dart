import 'package:flutter/foundation.dart';

import '../services/favorites_storage.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._storage);

  final FavoritesStorage _storage;
  final Set<int> _ids = {};

  int get count => _ids.length;

  bool isFavorite(int id) => _ids.contains(id);

  Future<void> load() async {
    _ids
      ..clear()
      ..addAll(await _storage.read());
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (!_ids.remove(id)) _ids.add(id);
    notifyListeners();
    await _storage.write(_ids);
  }
}
