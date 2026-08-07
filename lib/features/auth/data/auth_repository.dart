import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../model/user_model.dart';

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
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final token = response.data['token'];

      await storage.saveToken(token);

      final user = await getUserByUsername(username);

      await storage.saveUserId(user.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserByUsername(
    String username,
  ) async {
    final response = await apiClient.dio.get(
      '/users',
    );

    final users = response.data as List;

    final user = users.firstWhere(
      (user) => user['username'] == username,
    );

    return UserModel.fromJson(user);
  }

  Future<UserModel> getUser(int id) async {
    final response = await apiClient.dio.get(
      '/users/$id',
    );

    return UserModel.fromJson(
      response.data,
    );
  }
}