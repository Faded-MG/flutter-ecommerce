import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/product_card.dart';
import 'providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: products.when(
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductCard(product: product);
            },
          );
        },

        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
      ),
    );
  }
}