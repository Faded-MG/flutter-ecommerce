import '../model/product.dart';
import 'product_api.dart';

class ProductRepository {
  final ProductApi productApi;

  ProductRepository({
    required this.productApi,
  });

  Future<List<Product>> getProducts() async {
    return await productApi.getProducts();
  }
}
