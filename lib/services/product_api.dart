import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ProductApi {
  ProductApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static final Uri _url = Uri.parse('https://dummyjson.com/products?limit=10');

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(_url).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw ApiException('Server responded with ${response.statusCode}. Please try again.');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final items = body['products'] as List<dynamic>? ?? [];
      return items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } on SocketException {
      throw const ApiException('No internet connection. Check your network and retry.');
    } on TimeoutException {
      throw const ApiException('The request took too long. Please try again.');
    } on http.ClientException {
      throw const ApiException('Could not reach the server. Please try again.');
    } on FormatException {
      throw const ApiException('Got an unexpected response from the server.');
    }
  }
}
