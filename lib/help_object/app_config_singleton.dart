import 'package:flutter/material.dart';
import 'package:flutter_two_test/help_object/user_defaults_manager.dart';

class AppConfigSingleton {

  static final AppConfigSingleton instance = AppConfigSingleton._privateConstructor();
  AppConfigSingleton._privateConstructor();

  String appDisplayName = '';
  String appBundleId = '';
  String mUUID = '';
  String mIDFA = '';
  String mUserName = '';
  String mEmail = '';
  String mPassword = '';
  bool isLogin = false;

   void setInfo() async {
    mUserName = UserDefaultsManager.instance.userName;
    mEmail = UserDefaultsManager.instance.userEmail;
    mPassword = UserDefaultsManager.instance.userPassword;
    isLogin = UserDefaultsManager.instance.userIsLogin;
  }
}
