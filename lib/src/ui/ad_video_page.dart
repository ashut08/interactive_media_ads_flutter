// import 'package:flutter/material.dart';
// import 'package:interactive_media_ads/interactive_media_ads.dart';
// import 'package:video_player/video_player.dart';

// class AdExampleWidget extends StatefulWidget {
//   /// Constructs an [AdExampleWidget].
//   const AdExampleWidget({super.key});

//   @override
//   State<AdExampleWidget> createState() => _AdExampleWidgetState();
// }

// class _AdExampleWidgetState extends State<AdExampleWidget> {
//   // IMA sample tag for a single skippable inline video ad. See more IMA sample
//   // tags at https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/tags
//   static const String _adTagUrl =
//       'https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_ad_samples&sz=640x480&cust_params=sample_ct%3Dredirectlinear&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=';

//   // The AdsLoader instance exposes the request ads method.
//   late final AdsLoader _adsLoader;

//   // AdsManager exposes methods to control ad playback and listen to ad events.
//   AdsManager? _adsManager;

//   bool _shouldShowContentVideo = true;

//   late final VideoPlayerController _contentVideoController;

//   late final AdDisplayContainer _adDisplayContainer = AdDisplayContainer(
//     onContainerAdded: (AdDisplayContainer container) {
//       _requestAds(container);
//     },
//   );

//   @override
//   void initState() {
//     super.initState();
//     _contentVideoController = VideoPlayerController.networkUrl(
//       Uri.parse(
//         'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
//       ),
//     )
//       ..addListener(() {
//         if (_contentVideoController.value.isCompleted) {
//           _adsLoader.contentComplete();
//           setState(() {});
//         }
//       })
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   Future<void> _requestAds(AdDisplayContainer container) {
//     _adsLoader = AdsLoader(
//       container: container,
//       onAdsLoaded: (OnAdsLoadedData data) {
//         final AdsManager manager = data.manager;
//         _adsManager = data.manager;

//         manager.setAdsManagerDelegate(AdsManagerDelegate(
//           onAdEvent: (AdEvent event) {
//             debugPrint('OnAdEvent: ${event.type}');
//             switch (event.type) {
//               case AdEventType.loaded:
//                 manager.start();
//               case AdEventType.contentPauseRequested:
//                 _pauseContent();
//               case AdEventType.contentResumeRequested:
//                 _resumeContent();
//               case AdEventType.allAdsCompleted:
//                 manager.destroy();
//                 _adsManager = null;
//               case AdEventType.clicked:
//               case AdEventType.complete:
//             }
//           },
//           onAdErrorEvent: (AdErrorEvent event) {
//             debugPrint('AdErrorEvent: ${event.error.message}');
//             _resumeContent();
//           },
//         ));

//         manager.init();
//       },
//       onAdsLoadError: (AdsLoadErrorData data) {
//         debugPrint('OnAdsLoadError: ${data.error.message}');
//         _resumeContent();
//       },
//     );

//     return _adsLoader.requestAds(AdsRequest(adTagUrl: _adTagUrl));
//   }

//   Future<void> _resumeContent() {
//     setState(() {
//       _shouldShowContentVideo = true;
//     });
//     return _contentVideoController.play();
//   }

//   Future<void> _pauseContent() {
//     setState(() {
//       _shouldShowContentVideo = false;
//     });
//     return _contentVideoController.pause();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _contentVideoController.dispose();
//     _adsManager?.destroy();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: 300,
//           child: !_contentVideoController.value.isInitialized
//               ? Container()
//               : AspectRatio(
//                   aspectRatio: _contentVideoController.value.aspectRatio,
//                   child: Stack(
//                     children: <Widget>[
//                       _adDisplayContainer,
//                       if (_shouldShowContentVideo)
//                         VideoPlayer(_contentVideoController)
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//       floatingActionButton:
//           _contentVideoController.value.isInitialized && _shouldShowContentVideo
//               ? FloatingActionButton(
//                   onPressed: () {
//                     setState(() {
//                       _contentVideoController.value.isPlaying
//                           ? _contentVideoController.pause()
//                           : _contentVideoController.play();
//                     });
//                   },
//                   child: Icon(
//                     _contentVideoController.value.isPlaying
//                         ? Icons.pause
//                         : Icons.play_arrow,
//                   ),
//                 )
//               : null,
//     );
//   }
// }
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

  void _pauseContent() {
    ref.read(contentVisibilityProvider.notifier).state = false;
    ref.read(videoPlayerProvider.notifier).pauseContent();
  }

  void _resumeContent() {
    ref.read(contentVisibilityProvider.notifier).state = true;
    ref.read(videoPlayerProvider.notifier).resumeContent();
  }

  @override
  Widget build(BuildContext context) {
    final videoController = ref.watch(videoPlayerProvider);

    return Scaffold(
      body: videoController == null
          ? const Center(child: Text("Loading..."))
          : Stack(
              children: [
                VideoPlayerWidget(controller: videoController),
                if (ref.watch(contentVisibilityProvider) == false)
                  _adDisplayContainer,
              ],
            ),
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

  void _initializeAds() {
    _adDisplayContainer = AdDisplayContainer(
      onContainerAdded: (AdDisplayContainer container) {
        ref
            .read(adsManagerProvider.notifier)
            .requestAds(container, AdExampleScreen._adTagUrl);
      },
    );
  }
}
