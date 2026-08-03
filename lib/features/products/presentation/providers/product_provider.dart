import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/product_api.dart';
import '../../data/product_repository.dart';
import '../../model/product.dart';

final productApiProvider = Provider<ProductApi>((ref) {
  return ProductApi(
    apiClient: ApiClient(),
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    productApi: ref.read(productApiProvider),
  );
});


final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  final category = ref.watch(selectedCategoryProvider);

  if (category == null) {
    return repository.getProducts();
  }

  return repository.getProductsByCategory(category);
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  return repository.getCategories();
});


final categoryProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final repository = ref.read(productRepositoryProvider);

  return repository.getProductsByCategory(category);
});

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void selectCategory(String? category) {
    state = category;
  }
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
  SelectedCategoryNotifier.new,
);