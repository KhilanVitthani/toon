import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsController extends GetxController with WidgetsBindingObserver {
  AppOpenAd? appOpenAd;
  bool isPaused = false;
  static bool pausedByInterstitial = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed &&
        !pausedByInterstitial &&
        isPaused) {
      // loadAppOpenAd();
      isPaused = false;
    }
  }

  loadAppOpenAd() {
    AppOpenAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5662855259",
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              appOpenAd = ad;
              appOpenAd!.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }

  @override
  void onInit() async {
    await loadAppOpenAd();
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
