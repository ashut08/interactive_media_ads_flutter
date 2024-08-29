
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
import '../provider/ads_provider.dart';
import '../provider/show_content_provider.dart';
import '../provider/video_provider.dart';
import '../widget/video_player_widget.dart';

class AdExampleScreen extends ConsumerStatefulWidget {
  static const String _adTagUrl =
      'https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=';

  const AdExampleScreen({super.key});

  @override
  _AdExampleScreenState createState() => _AdExampleScreenState();
}

class _AdExampleScreenState extends ConsumerState<AdExampleScreen> {
  late AdDisplayContainer _adDisplayContainer;

  @override
  void initState() {
    super.initState();
    ref.read(videoPlayerProvider.notifier).initializeVideo(
          'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
        );
    _initializeAds();
  }

  void _initializeAds() {
    // Check if the ad has been shown before
    final adShown = ref.read(adShownProvider.notifier).state;

    if (!adShown) {
      // If the ad has not been shown, show the ad
      _adDisplayContainer = AdDisplayContainer(
        onContainerAdded: (AdDisplayContainer container) {
          ref
              .read(adsManagerProvider.notifier)
              .requestAds(container, AdExampleScreen._adTagUrl);
        },
      );
    } else {
      // If the ad has been shown, directly show the content
      _resumeContent();
    }
  }

  void _pauseContent() {
    ref.read(videoPlayerProvider.notifier).pauseContent();
  }

  void _resumeContent() {
    // Set the ad as shown
    ref.read(adShownProvider.notifier).state = true;

    ref.read(videoPlayerProvider.notifier).resumeContent();
  }

  @override
  Widget build(BuildContext context) {
    final videoController = ref.watch(videoPlayerProvider);

    return Scaffold(
      body: videoController == null
          ? const Center(child: Text("Loading..."))
          : Stack(
              fit: StackFit.expand,
              children: [
                if (ref.watch(adShownProvider) &&
                    videoController.value.isInitialized)
                  VideoPlayerWidget(controller: videoController),
                if (!ref.watch(adShownProvider)) _adDisplayContainer,
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: videoController?.value.isInitialized ?? false
          ? FloatingActionButton(
              onPressed: () {
                videoController.value.isPlaying
                    ? _pauseContent()
                    : _resumeContent();
              },
              child: Icon(
                videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
