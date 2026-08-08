import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import '../../home/presentation/home_screen.dart';
import 'package:dio/dio.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      ref.read(authLoadingProvider.notifier).startLoading();

                      try {
                        await ref
                            .read(authRepositoryProvider)
                            .login(
                              usernameController.text.trim(),
                              passwordController.text,
                            );

                        if (!context.mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      } on DioException catch (e) {
                        if (!context.mounted) return;

                        String message;

                        if (e.response?.statusCode == 401) {
                          message = "Invalid username or password.";
                        } else if (e.type == DioExceptionType.connectionTimeout) {
                          message = "Connection timed out. Please try again.";
                        } else if (e.type == DioExceptionType.receiveTimeout) {
                          message = "Server took too long to respond. Please try again.";
                        } else if (e.type == DioExceptionType.connectionError) {
                          message = "Unable to connect to the server.";
                        } else {
                          message = "Login failed. Please try again.";
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Something went wrong. Please try again."),
                          ),
                        );
                      } finally {
                        if (context.mounted) {
                          ref.read(authLoadingProvider.notifier).stopLoading();
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}