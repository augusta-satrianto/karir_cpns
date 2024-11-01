import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WebinarViewPage extends StatelessWidget {
  final String webinarId;
  WebinarViewPage({super.key, required this.webinarId});

  final FlickManager flickManager = FlickManager(
    videoPlayerController: VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ),
  );

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: 'iLnmTe5Q2Qw',
    autoPlay: false,
    params: const YoutubePlayerParams(showFullscreenButton: true),
  );
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05 < 20 ? 20 : screenWidth * 0.05),
        children: [
          Text('Materi Pembelajaran (Document)'),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFF2F4F9),
                ),
                borderRadius: BorderRadius.circular(4)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go('/dashboard/user/webinar');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFBBC06),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 4),
                          Text('Back'),
                        ],
                      ),
                    ),
                  ],
                ),
                YoutubePlayerScaffold(
                    // autoFullScreen: true,
                    builder: ((context, player) {
                      return Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.black,
                        child: Center(
                          child: player,
                        ),
                      );
                    }),
                    controller: _controller),
                webinarId == 'video-webinar-1'
                    ? YoutubePlayer(
                        controller: _controller,
                        aspectRatio: 16 / 9,
                        keepAlive: true,
                        enableFullScreenOnVerticalDrag: true,
                        gestureRecognizers: <Factory<
                            OneSequenceGestureRecognizer>>{},
                      )
                    : Center(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: FlickVideoPlayer(flickManager: flickManager),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
