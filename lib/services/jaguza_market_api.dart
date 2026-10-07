import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Client for the standalone JaguzaMarket Laravel API documented in
/// JaguzaMarket-API-Documentation.pdf. It is separate from the livestock API.
class JaguzaMarketApi {
  JaguzaMarketApi._();
  static final JaguzaMarketApi instance = JaguzaMarketApi._();

  static const String baseUrl = 'http://143.198.174.35:9061/api';
  static const String imageBaseUrl = 'http://143.198.174.35:9061/images';
  static const Duration _timeout = Duration(seconds: 30);

  Map<String, String> get _jsonHeaders => const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<dynamic> _decode(http.Response response) async {
    final body = response.body.trim();
    dynamic decoded;
    if (body.isNotEmpty) {
      try {
        decoded = jsonDecode(body);
      } on FormatException {
        throw HttpException('Marketplace returned an invalid response (${response.statusCode}).');
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map ? decoded['message'] : null;
      throw HttpException('${message ?? 'Marketplace request failed'} (${response.statusCode}).');
    }
    return decoded;
  }

  List<dynamic> _data(dynamic response) =>
      response is Map && response['data'] is List ? response['data'] as List : <dynamic>[];

  Future<List<dynamic>> getCategories() async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/categories'), headers: _jsonHeaders).timeout(_timeout)));

  Future<List<dynamic>> getProducts() async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/products'), headers: _jsonHeaders).timeout(_timeout)));

  Future<List<dynamic>> getCategoryProducts(String categoryId) async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/categoryProducts/${Uri.encodeComponent(categoryId)}'), headers: _jsonHeaders).timeout(_timeout)));

  Future<List<dynamic>> searchProducts(String name) async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/search/${Uri.encodeComponent(name)}'), headers: _jsonHeaders).timeout(_timeout)));

  Future<List<dynamic>> getUserProducts(int userId) async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/userProducts/$userId'), headers: _jsonHeaders).timeout(_timeout)));

  Future<Map<String, dynamic>> createProduct({
    required Map<String, String> fields,
    required File picture,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/products'))
      ..headers['Accept'] = 'application/json'
      ..fields.addAll(fields)
      ..files.add(await http.MultipartFile.fromPath('picture', picture.path));
    final response = await http.Response.fromStream(await request.send().timeout(_timeout));
    final decoded = await _decode(response);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  Future<void> deleteProduct(String id) async {
    await _decode(await http.delete(Uri.parse('$baseUrl/products/${Uri.encodeComponent(id)}'), headers: _jsonHeaders).timeout(_timeout));
  }

  Future<void> updateProduct(String id, Map<String, String> fields) async {
    await _decode(await http.put(
      Uri.parse('$baseUrl/products/${Uri.encodeComponent(id)}'),
      headers: _jsonHeaders,
      body: jsonEncode(fields),
    ).timeout(_timeout));
  }

  Future<List<dynamic>> getProductComments(String productId) async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/product/comments/${Uri.encodeComponent(productId)}'), headers: _jsonHeaders).timeout(_timeout)));

  Future<void> addProductComment({required String productId, required int userId, required String comment}) async {
    await _decode(await http.post(Uri.parse('$baseUrl/product/comments/${Uri.encodeComponent(productId)}'), headers: _jsonHeaders, body: jsonEncode({'user_id': userId, 'comment': comment})).timeout(_timeout));
  }

  Future<List<dynamic>> getCart(int userId) async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/userCartProducts/$userId'), headers: _jsonHeaders).timeout(_timeout)));

  Future<void> addToCart({required int userId, required String productId, required int quantity}) async {
    await _decode(await http.post(Uri.parse('$baseUrl/addToCart'), headers: _jsonHeaders, body: jsonEncode({'user_id': userId, 'product_id': productId, 'quantity': quantity})).timeout(_timeout));
  }

  Future<void> updateCart(String cartId, int quantity) async {
    await _decode(await http.post(Uri.parse('$baseUrl/updateCart/${Uri.encodeComponent(cartId)}'), headers: _jsonHeaders, body: jsonEncode({'quantity': quantity})).timeout(_timeout));
  }

  Future<void> deleteCart(String cartId) async {
    await _decode(await http.post(Uri.parse('$baseUrl/deleteCart/${Uri.encodeComponent(cartId)}'), headers: _jsonHeaders).timeout(_timeout));
  }

  Future<Map<String, dynamic>> checkout({
    required int userId,
    required String deliveryMode,
    required String deliveryLocation,
    required num totalCost,
    required num totalProfits,
  }) async {
    final decoded = await _decode(await http.post(Uri.parse('$baseUrl/orders'), headers: _jsonHeaders, body: jsonEncode({
      'user_id': userId,
      'delivery_mode': deliveryMode,
      if (deliveryMode == 'delivery') 'delivery_location': deliveryLocation,
      'total_order_cost': totalCost.toString(),
      'total_profits': totalProfits.toString(),
    })).timeout(_timeout));
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  Future<List<dynamic>> getOrders(int userId) async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/userOrders/$userId'), headers: _jsonHeaders).timeout(_timeout)));

  Future<void> cancelOrder(String orderId) async {
    await _decode(await http.put(Uri.parse('$baseUrl/orders/${Uri.encodeComponent(orderId)}'), headers: _jsonHeaders, body: jsonEncode({'order_status': 'cancelled'})).timeout(_timeout));
  }

  Future<List<dynamic>> getAdverts() async =>
      _data(await _decode(await http.get(Uri.parse('$baseUrl/adverts'), headers: _jsonHeaders).timeout(_timeout)));

  String productImageUrl(String filename) => '$imageBaseUrl/products/${Uri.encodeComponent(filename)}';
  String categoryIconUrl(String filename) => '$imageBaseUrl/icons/${Uri.encodeComponent(filename)}';
  String advertImageUrl(String filename) => '$imageBaseUrl/adverts/${Uri.encodeComponent(filename)}';
}
