import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
  }

  String? getToken() {
    return _prefs?.getString('token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
  }
}