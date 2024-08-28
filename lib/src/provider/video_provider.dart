// ignore_for_file: deprecated_member_use

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactiveads/src/provider/ads_provider.dart';
import 'package:video_player/video_player.dart';

final videoPlayerProvider =
    StateNotifierProvider<VideoPlayerNotifier, VideoPlayerController?>((ref) {
  return VideoPlayerNotifier(ref);
});

class VideoPlayerNotifier extends StateNotifier<VideoPlayerController?> {
  VideoPlayerNotifier(this.ref) : super(null);
  Ref ref;

  Future<void> initializeVideo(String url) async {
    final controller = VideoPlayerController.network(url);

    await controller.initialize();

    state = controller;
  }

  Future<void> playContent() async {
    await state?.play();
  }

  Future<void> pauseContent() async {
    await state?.pause();
  }

  Future<void> resumeContent() async {
    await playContent();
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}
