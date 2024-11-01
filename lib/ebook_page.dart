import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EbookPage extends StatelessWidget {
  const EbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text('List Ebook'),
          ElevatedButton(
              onPressed: () {
                context.go('/dashboard/user/learning-material/document/show');
              },
              child: Text('Go to list ebook'))
        ],
      ),
    );
  }
}
