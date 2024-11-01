import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WebinarPage extends StatelessWidget {
  const WebinarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text('List Webinar'),
          ElevatedButton(
              onPressed: () {
                context.go('/dashboard/user/webinar/video-webinar-1');
              },
              child: Text('Go to view webinar youtube')),
          ElevatedButton(
              onPressed: () {
                context.go('/dashboard/user/webinar/video-webinar-2');
              },
              child: Text('Go to view webinar url'))
        ],
      ),
    );
  }
}
