
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class UserDefaultsManager {
  static final UserDefaultsManager instance = UserDefaultsManager._privateConstructor();
  UserDefaultsManager._privateConstructor();

  late Box testBox;

  Future<void> initUserDefaults() async {
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    testBox = await Hive.openBox('testBox');
  }

  String get userEmail => testBox.get('userEmail', defaultValue: '');
  set userEmail(String email) => testBox.put('userEmail', email);

  String get userPassword => testBox.get('userPassword', defaultValue: '');
  set userPassword(String password) => testBox.put('userPassword', password);

  String get userName => testBox.get('userName', defaultValue: '');
  set userName(String name) => testBox.put('userName', name);

  bool get userIsLogin => testBox.get('userIsLogin', defaultValue: false);
  set userIsLogin(bool isLogin) => testBox.put('userIsLogin', isLogin);
}