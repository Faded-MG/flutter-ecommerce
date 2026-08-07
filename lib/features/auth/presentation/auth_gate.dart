import 'package:flutter/material.dart';

import '../../../core/storage/local_storage.dart';
import '../../home/presentation/home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: LocalStorage().getToken(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If token exists -> Home
        if (snapshot.data != null) {
          return const HomeScreen();
        }

        // Otherwise -> Login
        return const LoginScreen();
      },
    );
  }
}