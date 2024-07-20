import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InlineAdaptiveAdWidget extends StatefulWidget {
  const InlineAdaptiveAdWidget({Key? key}) : super(key: key);

  @override
  State<InlineAdaptiveAdWidget> createState() =>
      _InlineAdaptiveAdWidgetState();
}

class _InlineAdaptiveAdWidgetState extends State<InlineAdaptiveAdWidget> {
  static const _insets = 16.0;
  BannerAd? _inlineAd;
  AdSize? _adSize;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  // final String _testInlineAdId = Platform.isAndroid
  //           ? 'ca-app-pub-3940256099942544/6300978111'
  //           : 'ca-app-pub-3940256099942544/2934735716',;
  final String _inlineAdId = Platform.isAndroid
      ? 'ca-app-pub-6938652089612764/5057825333'
      : 'ca-app-pub-6938652089612764/9645767602';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    initInlineAd();
  }

  @override
  void dispose() {
    super.dispose();
    _inlineAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _inlineAd != null &&
            _isLoaded &&
            _adSize != null) {
          return Align(
              child: SizedBox(
                width: _adWidth,
                height: _adSize!.height.toDouble(),
                child: AdWidget(
                  ad: _inlineAd!,
                ),
              ));
        }
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          initInlineAd();
        }
        return Container();
      },
    );

  }

  Future<void> initInlineAd() async {
    await _inlineAd?.dispose();
    setState(() {
      _inlineAd = null;
      _isLoaded = false;
    });

    AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        _adWidth.truncate());

    _inlineAd = BannerAd(
      adUnitId: _inlineAdId,
      size: size,
      request: const AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) async {
          LogUtil.logI('Inline adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            LogUtil.logE('Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _inlineAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          LogUtil.logE('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _inlineAd!.load();
  }
}
