import 'dart:async';

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_two_test/help_object/app_config_singleton.dart';
import 'package:package_info/package_info.dart';

class LandingPageViewModel extends ChangeNotifier {

  late String myAppName = '';
  Timer? timer;

  Future setupAppConfig() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppConfigSingleton.instance.appBundleId = packageInfo.packageName;
    AppConfigSingleton.instance.mUUID = await getUUID();
    AppConfigSingleton.instance.mIDFA = await getIDFA();
    AppConfigSingleton.instance.setInfo();

    switch (packageInfo.packageName) {
      case 'com.9n3.app2':
        AppConfigSingleton.instance.appDisplayName = 'app1';
        notifyListeners();
        break;
      case 'com.9n3.app3':
        AppConfigSingleton.instance.appDisplayName = 'app2';
        notifyListeners();
        break;
      default:
        AppConfigSingleton.instance.appDisplayName = 'app3';
        notifyListeners();
        break;
    }
  }

  /// 請求裝置IDFA, 記得ios info.plist 新增 Privacy - Tracking Usage Description / msg
  Future<String> getIDFA() async {
    String? idfa = '';
    try {
      idfa = await AdvertisingId.id(true);
    } on PlatformException {
      idfa = '';
    }
    return idfa!;
  }

  /// 請求裝置識別碼UUID,並存至ios鑰匙圈
  Future<String> getUUID() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String UUID = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      IosDeviceInfo ios = await deviceInfo.iosInfo;
      UUID = ios.identifierForVendor??"";
    } catch (e){
      print('$e');
    }
    final keyChainUUID = await storage.read(key: "deviceID");
    await storage.write(key: "deviceID", value: keyChainUUID ?? UUID);

    return keyChainUUID ?? UUID;
  }
}
