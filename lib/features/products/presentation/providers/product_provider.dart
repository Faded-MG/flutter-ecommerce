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


// Selected category state
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


// Search state
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void search(String query) {
    state = query;
  }
}


final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);


// Products with category + search filtering
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider);


  List<Product> products;


  if (category == null) {
    products = await repository.getProducts();
  } else {
    products = await repository.getProductsByCategory(category);
  }


  if (query.isEmpty) {
    return products;
  }


  return products.where((product) {
    return product.title
        .toLowerCase()
        .contains(query.toLowerCase());
  }).toList();
});


// Categories
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  return repository.getCategories();
});


// Products by category (kept for future use)
final categoryProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final repository = ref.read(productRepositoryProvider);

  return repository.getProductsByCategory(category);
});