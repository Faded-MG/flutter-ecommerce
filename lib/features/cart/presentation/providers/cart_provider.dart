import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart_item.dart';
import '../../../products/model/product.dart';

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  
  static const String cartKey = 'cart_items';

  @override
  Future<List<CartItem>> build() async {
    final prefs = await SharedPreferences.getInstance();

    final savedCart = prefs.getString(cartKey);
   

    if (savedCart == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(savedCart);

    return decoded
        .map((item) => CartItem.fromJson(item))
        .toList();
  }


  Future<void> _saveCart(List<CartItem> cart) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      cart.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(
      cartKey,
      encoded,
    );
   
  }


  Future<void> addToCart(Product product) async {
    final current = state.value ?? [];

    final index = current.indexWhere(
      (item) => item.id == product.id,
    );

    List<CartItem> updated;

    if (index >= 0) {
      updated = [...current];

      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );
    } else {
      updated = [
        ...current,
        CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          quantity: 1,
        ),
      ];
    }

    state = AsyncData(updated);

    await _saveCart(updated);
  }


  Future<void> removeFromCart(int id) async {
    final updated = (state.value ?? [])
        .where((item) => item.id != id)
        .toList();

    state = AsyncData(updated);

    await _saveCart(updated);
  }


  Future<void> increaseQuantity(int id) async {
    final updated = (state.value ?? [])
        .map((item) {
          if (item.id == id) {
            return item.copyWith(
              quantity: item.quantity + 1,
            );
          }
          return item;
        })
        .toList();

    state = AsyncData(updated);

    await _saveCart(updated);
  }


  Future<void> decreaseQuantity(int id) async {
    final updated = (state.value ?? [])
        .map((item) {
          if (item.id == id) {
            return item.copyWith(
              quantity: item.quantity - 1,
            );
          }
          return item;
        })
        .where((item) => item.quantity > 0)
        .toList();

    state = AsyncData(updated);

    await _saveCart(updated);
  }


  double get totalPrice {
    return (state.value ?? []).fold(
      0,
      (total, item) =>
          total + item.price * item.quantity,
    );
  }


  int get totalItems {
    return (state.value ?? []).fold(
      0,
      (total, item) => total + item.quantity,
    );
  }


  Future<void> clearCart() async {
    state = const AsyncData([]);

    await _saveCart([]);
  }
}


final cartProvider =
    AsyncNotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);