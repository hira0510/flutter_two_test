import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProviderManager {
  static final AdProviderManager instance =
      AdProviderManager._privateConstructor();

  AdProviderManager._privateConstructor();

  // final String _testRewardedAdId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/5224354917'
  //     : 'ca-app-pub-3940256099942544/1712485313';
  final String _rewardedAdId = Platform.isAndroid
      ? 'ca-app-pub-6938652089612764/4681903899'
      : 'ca-app-pub-6938652089612764/1000990821';

  // final String _testInterstitialAdId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/1033173712'
  //     : 'ca-app-pub-3940256099942544/4411468910';
  final String _interstitialAdId = Platform.isAndroid
      ? 'ca-app-pub-6938652089612764/2939762608'
      : 'ca-app-pub-6938652089612764/1136205278';

  // final String _testRewardedInterstitialAdId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/5354046379'
  //     : 'ca-app-pub-3940256099942544/6978759866';
  // final String _rewardedInterstitialAdId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/5354046379'
  //     : 'ca-app-pub-3940256099942544/6978759866';

  RewardedAd? _rewardedAd;

  InterstitialAd? _interstitialAd;

  // RewardedInterstitialAd? _rewardedInterstitialAd;

  int showAdTimes = 0;
  int _numRewardedLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  /// 創建廣告
  void loadAd() {
    _createRewardedAd();
    _createInterstitialAd();
    // _createRewardedInterstitialAd();
  }

  /// 自定義播放器影音廣告出現邏輯
  /// bool: 回傳是否要播廣告
  bool showRewardedPlayerAd() {
    if (showAdTimes >= 2 && _rewardedAd != null) {
      showAdTimes = 0;
      return true;
    } else {
      showAdTimes += 1;
      loadAd();
      return false;
    }
  }

  /// 創建影音廣告
  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          LogUtil.logI('$ad loaded');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          LogUtil.logE('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < _maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        },
      ),
    );
  }

  /// 顯示影音廣告
  void showRewardedAd(VoidCallback failAndDismiss) {
    if (_rewardedAd == null) {
      LogUtil.logE('Warning: attempt to show rewarded before loaded.');
      failAndDismiss();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        LogUtil.logI('ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        LogUtil.logI('$ad onAdDismissedFullScreenContent.');
        failAndDismiss();
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        LogUtil.logW('$ad onAdFailedToShowFullScreenContent: $error');
        failAndDismiss();
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        LogUtil.logI(
            '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
    _rewardedAd = null;
  }

  /// 創建插頁式廣告
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          LogUtil.logI('$ad loaded');
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          LogUtil.logE('InterstitialAd failed to load: $error.');
          _interstitialAd = null;
          _createInterstitialAd();
        },
      ),
    );
  }

  /// 顯示插頁式廣告
  void showInterstitialAd(VoidCallback failAndDismiss) {
    if (_interstitialAd == null) {
      failAndDismiss();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          LogUtil.logI('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        LogUtil.logI('$ad onAdDismissedFullScreenContent.');
        failAndDismiss();
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        LogUtil.logW('$ad onAdFailedToShowFullScreenContent: $error');
        failAndDismiss();
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}

extension BehaviorSubjectExtensions<T> on StreamController<T> {
  set safeValue(T newValue) => isClosed == false ? add(newValue) : () {};
}

// /// 創建影音廣告2
// void _createRewardedInterstitialAd() {
//   RewardedInterstitialAd.load(
//     adUnitId: _rewardedInterstitialAdId,
//     request: request,
//     rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//       onAdLoaded: (RewardedInterstitialAd ad) {
//         LogUtil.logI('$ad loaded');
//         _rewardedInterstitialAd = ad;
//       },
//       onAdFailedToLoad: (LoadAdError error) {
//         LogUtil.logE('RewardedInterstitialAd failed to load: $error');
//         _rewardedInterstitialAd = null;
//         _createRewardedInterstitialAd();
//       },
//     ),
//   );
// }
//
// /// 顯示影音廣告2
// void _showRewardedInterstitialAd() {
//   if (_rewardedInterstitialAd == null) {
//     LogUtil.logE(
//         'Warning: attempt to show rewarded interstitial before loaded.');
//     return;
//   }
//   _rewardedInterstitialAd!.fullScreenContentCallback =
//       FullScreenContentCallback(
//     onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
//         LogUtil.logI('$ad onAdShowedFullScreenContent.'),
//     onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
//       LogUtil.logI('$ad onAdDismissedFullScreenContent.');
//       ad.dispose();
//       _createRewardedInterstitialAd();
//     },
//     onAdFailedToShowFullScreenContent:
//         (RewardedInterstitialAd ad, AdError error) {
//       LogUtil.logW('$ad onAdFailedToShowFullScreenContent: $error');
//       ad.dispose();
//       _createRewardedInterstitialAd();
//     },
//   );
//
//   _rewardedInterstitialAd!.setImmersiveMode(true);
//   _rewardedInterstitialAd!.show(
//     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       LogUtil.logI(
//           '$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     },
//   );
//   _rewardedInterstitialAd = null;
// }
