import '../model/product.dart';
import 'product_api.dart';

class ProductRepository {
  final ProductApi productApi;

  ProductRepository({
    required this.productApi,
  });

  Future<List<Product>> getProducts() async {
    return productApi.getProducts();
  }

  Future<List<String>> getCategories() async {
    return productApi.getCategories();
  }

  Future<List<Product>> getProductsByCategory(
    String category,
  ) async {
    return productApi.getProductsByCategory(category);
  }
}