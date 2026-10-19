import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/models/product.dart';

void main() {
  test('parses a product and computes the discounted price', () {
    final product = Product.fromJson({
      'id': 1,
      'title': 'Test',
      'price': 100,
      'discountPercentage': 10,
      'thumbnail': 'https://example.com/a.webp',
      'images': [],
    });

    expect(product.title, 'Test');
    expect(product.discountedPrice, 90);
    expect(product.images, ['https://example.com/a.webp']);
  });

  test('falls back to safe defaults for missing fields', () {
    final product = Product.fromJson({});

    expect(product.title, 'Untitled');
    expect(product.reviews, isEmpty);
    expect(product.hasDiscount, false);
  });
}
