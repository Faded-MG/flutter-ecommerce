import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/wishlist_provider.dart';
import '../../products/presentation/widgets/product_card.dart';
import '../../../shared/widgets/empty_state.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: wishlistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              message: 'Your wishlist is empty',
              subMessage: 'Tap the heart on any product to save it here',
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ProductCard(product: items[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Something went wrong: $error'),
        ),
      ),
    );
  }
}