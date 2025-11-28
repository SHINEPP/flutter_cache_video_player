import 'package:flutter/material.dart';
import 'package:flutter_cache_video_player/flutter_cache_video_player.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CacheVideoPlayer _player;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() async {
    _player = CacheVideoPlayer.networkUrl(
      Uri.parse("https://app-wallpaper-4k.s3.amazonaws.com/res/Live/live/20.mp4"),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    await _player.initialize();
  }

  @override
  void dispose() {
    _player.disposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
