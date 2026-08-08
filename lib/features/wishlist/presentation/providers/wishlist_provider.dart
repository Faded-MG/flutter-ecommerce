import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../products/model/product.dart';

class WishlistNotifier extends AsyncNotifier<List<Product>> {
  static const _storageKey = 'wishlist_items';

  @override
  Future<List<Product>> build() async {
    return _loadWishlist();
  }

  Future<List<Product>> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => Product.fromJson(item)).toList();
  }

  Future<void> _saveWishlist(List<Product> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      items.map((product) => product.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> toggleWishlist(Product product) async {
    final currentItems = state.value ?? [];
    final exists = currentItems.any((item) => item.id == product.id);

    List<Product> updatedItems;

    if (exists) {
      updatedItems =
          currentItems.where((item) => item.id != product.id).toList();
    } else {
      updatedItems = [...currentItems, product];
    }

    state = AsyncData(updatedItems);
    await _saveWishlist(updatedItems);
  }

  bool isInWishlist(int productId) {
    final currentItems = state.value ?? [];
    return currentItems.any((item) => item.id == productId);
  }
}

final wishlistProvider =
    AsyncNotifierProvider<WishlistNotifier, List<Product>>(
  WishlistNotifier.new,
);