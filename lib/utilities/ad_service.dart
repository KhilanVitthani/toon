import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static const interstitialAd = "interstitialAd";
  static const BzannerAd = "bannerAd";
  static const rewardsAd = "rewardsAd";

  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;
  NativeAd? nativeAd;
  RxBool nativeAdIsLoaded = false.obs;
  Future<bool> getAd({required String adType}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (adType == AdService.interstitialAd) {
        // Yodo1MAS.instance.showInterstitialAd();
      } else if (adType == AdService.BzannerAd) {
        // Yodo1MAS.instance.showBannerAd();
      } else {
        // Yodo1MAS.instance.showRewardAd();
      }
      return true;
    }
  }

  initBannerAds() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/2934735716",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isBannerLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: AdRequest())
      ..load();
  }

  NativeLoadAd() {
    nativeAd = NativeAd(
        adUnitId: "ca-app-pub-3940256099942544/3986624511",
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            nativeAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  void dispose() {
    bannerAd?.dispose().then((value) => isBannerLoaded.value = false);
    nativeAd?.dispose().then((value) => nativeAdIsLoaded.value = false);
  }
}
