import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karir_cpns_app/login_api.dart';
import 'package:karir_cpns_app/services/auth_service.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.goNamed('login');
            },
            child: const Text('Login'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed('register');
            },
            child: const Text('Register'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final user = await GoogleSignInService.login();
                await user?.authentication;
                if (user != null) {
                  await CredentialService.storeCredential(user);
                  print('Credential stored: ${user.email}');
                  context.goNamed('login');
                }
              } catch (exception) {
                // Handle error
              }
            },
            child: Text('Login'),
          )
        ],
      ),
    );
  }
}
