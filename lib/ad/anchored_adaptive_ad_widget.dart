import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

///锚定自适应横幅廣告
class AnchoredAdaptiveAdWidget extends StatefulWidget {
  const AnchoredAdaptiveAdWidget({Key? key}) : super(key: key);

  @override
  State<AnchoredAdaptiveAdWidget> createState() =>
      _AnchoredAdaptiveAdWidgetState();
}

class _AnchoredAdaptiveAdWidgetState extends State<AnchoredAdaptiveAdWidget> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;

  // final String _AnchoredAdaptiveAdId = Platform.isAndroid
  //           ? 'ca-app-pub-3940256099942544/6300978111'
  //           : 'ca-app-pub-3940256099942544/2934735716',,
  final String _anchoredAdaptiveAdId = Platform.isAndroid
      ? 'ca-app-pub-6938652089612764/5057825333'
      : 'ca-app-pub-6938652089612764/9645767602';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    initAnchoredAd();
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return AdWidget(
            ad: _anchoredAdaptiveAd!,
          );
        }
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          initAnchoredAd();
        }
        return Container();
      },
    );
  }

  Future<void> initAnchoredAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      LogUtil.logE('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: _anchoredAdaptiveAdId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          LogUtil.logI('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          LogUtil.logE('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }
}
