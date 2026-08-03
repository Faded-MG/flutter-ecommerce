import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';

class AuthRepository {
  final ApiClient apiClient;
  final LocalStorage storage;

  AuthRepository({
    required this.apiClient,
    required this.storage,
  });

  Future<void> login(
    String username,
    String password,
  ) async {
    final response = await apiClient.dio.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    final token = response.data['token'];

    await storage.saveToken(token);
  }
}