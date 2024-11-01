import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text('List Video'),
          ElevatedButton(
              onPressed: () {
                // context.go('/dashboard/user/learning-material/video/show');
              },
              child: Text('Go to list video'))
        ],
      ),
    );
  }
}
