import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Beranda Page'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/dashboard/user/tryout/list');
              },
              child: Text('Masuk ke Halaman Tryout'),
            ),
          ],
        ));
  }
}
