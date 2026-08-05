import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/product_card.dart';
import 'providers/product_provider.dart';
import '../../cart/presentation/cart_screen.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
     appBar: AppBar(
  title: const Text("Products"),

  actions: [
    IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CartScreen(),
          ),
        );
      },
    ),
  ],
),
      body: Column(
        
  children: [
    TextField(
  decoration: InputDecoration(
    hintText: "Search products...",
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onChanged: (value) {
    ref
        .read(searchQueryProvider.notifier)
        .search(value);
  },
),

const SizedBox(height: 12),
    SizedBox(
      height: 60,
      child: ref.watch(categoriesProvider).when(
        data: (categories) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
  onPressed: () {
    ref
        .read(selectedCategoryProvider.notifier)
        .selectCategory(null);
  },
  child: const Text("All"),
)
                );
              }

              final category = categories[index - 1];

              return Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
  onPressed: () {
    ref
        .read(selectedCategoryProvider.notifier)
        .selectCategory(category);
  },
  child: Text(category),
)
              );
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
      ),
    ),

    Expanded(
      child: products.when(
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
              );
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
            child: Text(error.toString()),
          );
        },
      ),
    ),
  ],
),
    );
  }
}