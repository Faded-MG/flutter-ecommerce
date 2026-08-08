import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/cart_provider.dart';
import 'package:ecommerce_app/shared/widgets/empty_state.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      body: cartState.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(child: Text(error.toString()));
        },

        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const EmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'Your cart is empty',
              subMessage: 'Add some products to get started',
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,

                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return Card(
                      margin: const EdgeInsets.all(10),

                      child: Padding(
                        padding: const EdgeInsets.all(12),

                        child: Row(
                          children: [
                            Image.network(
                              item.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text("\$${item.price}"),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cartNotifier.decreaseQuantity(
                                            item.id,
                                          );
                                        },

                                        icon: const Icon(Icons.remove),
                                      ),

                                      Text("${item.quantity}"),

                                      IconButton(
                                        onPressed: () {
                                          cartNotifier.increaseQuantity(
                                            item.id,
                                          );
                                        },

                                        icon: const Icon(Icons.add),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          cartNotifier.removeFromCart(item.id);
                                        },

                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "\$${cartNotifier.totalPrice.toStringAsFixed(2)}",

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
