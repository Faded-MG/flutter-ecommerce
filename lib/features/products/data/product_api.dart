import '../../../core/network/api_client.dart';
import '../model/product.dart';

class ProductApi {
  final ApiClient apiClient;

  ProductApi({
    required this.apiClient,
  });

  Future<List<Product>> getProducts() async {
    final response = await apiClient.dio.get('/products');

    final List<dynamic> data = response.data;

    return data
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final response = await apiClient.dio.get('/products/categories');

    return List<String>.from(response.data);
  }

  Future<List<Product>> getProductsByCategory(
    String category,
  ) async {
    final response = await apiClient.dio.get(
      '/products/category/$category',
    );

    final List<dynamic> data = response.data;

    return data
        .map((json) => Product.fromJson(json))
        .toList();
  }
}