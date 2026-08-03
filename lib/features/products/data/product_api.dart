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
}