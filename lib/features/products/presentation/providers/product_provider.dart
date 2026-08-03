import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/product_api.dart';
import '../../data/product_repository.dart';
import '../../model/product.dart';
import '../../../../core/network/api_client.dart';

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

  return repository.getProducts();
});