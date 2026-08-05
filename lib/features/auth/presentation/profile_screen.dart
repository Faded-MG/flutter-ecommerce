import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';

import '../../auth/presentation/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "User Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Logged in user",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () async {

                  await ref
                      .read(authStateProvider.notifier)
                      .logout();


                  if (context.mounted) {

                    Navigator.pushAndRemoveUntil(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),

                      (route) => false,
                    );

                  }

                },

                child: const Text(
                  "Logout",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}