import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/dashboard');
            },
            child: Text('Dashboard'),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
