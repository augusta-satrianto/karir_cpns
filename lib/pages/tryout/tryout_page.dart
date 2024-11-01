import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TryoutPage extends StatelessWidget {
  const TryoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tryout Page'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go(
                  '/dashboard/user/tryout/prepare-exam/skd-cpns/silver/skd-cpns-1');
            },
            child: Text('Mulai Tryout SKD CPNS'),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
