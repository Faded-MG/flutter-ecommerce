import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/auth_repository.dart';


final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});


final localStorageProvider = Provider<LocalStorage>((ref) {
  final storage = LocalStorage();

  return storage;
});


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(localStorageProvider),
  );
});


class AuthLoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void startLoading() {
    state = true;
  }

  void stopLoading() {
    state = false;
  }
}

final authLoadingProvider =
    NotifierProvider<AuthLoadingNotifier, bool>(
  AuthLoadingNotifier.new,
);