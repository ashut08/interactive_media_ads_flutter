import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
import 'package:interactiveads/src/provider/show_content_provider.dart';
import 'package:interactiveads/src/provider/video_provider.dart';

final adsManagerProvider =
    StateNotifierProvider<AdsManagerNotifier, AdsManager?>((ref) {
  return AdsManagerNotifier(ref);
});

class AdsManagerNotifier extends StateNotifier<AdsManager?> {
  AdsManagerNotifier(this._ref) : super(null);
  final Ref _ref;
  late final AdsLoader _adsLoader;

  Future<void> requestAds(AdDisplayContainer container, String adTagUrl) async {
    _adsLoader = AdsLoader(
      container: container,
      onAdsLoaded: (OnAdsLoadedData data) {
        final manager = data.manager;
        state = manager;

        manager.setAdsManagerDelegate(AdsManagerDelegate(
          onAdEvent: (AdEvent event) {
            switch (event.type) {
              case AdEventType.loaded:
                manager.start();
                break;
              case AdEventType.contentPauseRequested:
                _ref.read(videoPlayerProvider.notifier).pauseContent();
                break;
              case AdEventType.contentResumeRequested:
                _ref.read(adShownProvider.notifier).state = true;
                _ref.read(videoPlayerProvider.notifier).resumeContent();
                break;
              case AdEventType.allAdsCompleted:
                manager.destroy();
                state = null;
                break;
              case AdEventType.clicked:
              case AdEventType.complete:
                _ref.read(videoPlayerProvider.notifier).resumeContent();
                _ref.read(adShownProvider.notifier).state = true;

                break;
            }
          },
          onAdErrorEvent: (AdErrorEvent event) {
            _ref.read(videoPlayerProvider.notifier).resumeContent();
          },
        ));

        manager.init();
      },
      onAdsLoadError: (AdsLoadErrorData data) {
        _ref.read(videoPlayerProvider.notifier).resumeContent();
      },
    );

    await _adsLoader.requestAds(AdsRequest(adTagUrl: adTagUrl));
  }

  void destroyAdsManager() {
    state?.destroy();
    state = null;
  }
}
