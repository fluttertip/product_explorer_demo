import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_api.dart';

enum LoadStatus { loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  ProductProvider(this._api);

  final ProductApi _api;

  LoadStatus _status = LoadStatus.loading;
  List<Product> _products = [];
  String _query = '';
  String _error = '';

  LoadStatus get status => _status;
  String get error => _error;
  String get query => _query;
  bool get hasProducts => _products.isNotEmpty;
  List<Product> get products => _products;

  List<Product> get visibleProducts {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _products;
    return _products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> fetchProducts({bool showLoader = true}) async {
    if (showLoader) {
      _status = LoadStatus.loading;
      notifyListeners();
    }

    try {
      _products = await _api.fetchProducts();
      _status = LoadStatus.loaded;
    } on ApiException catch (e) {
      _error = e.message;
      _status = LoadStatus.error;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }
}
