import 'package:flutter/material.dart';
import 'package:flutter_two_test/help_object/app_config_singleton.dart';

class MemberPageListModel {
  final String pageName;
  final IconData pageIcon;
  final int mIndex;

  MemberPageListModel(this.pageName, this.pageIcon, this.mIndex);
}

class MemberPageViewModel extends ChangeNotifier {

  String userName = '';

  List<MemberPageListModel> mListType = [
    MemberPageListModel('会员资料', Icons.account_box, 0),
    MemberPageListModel('会员登入/注册', Icons.login, 1),
    MemberPageListModel('收藏', Icons.favorite, 2)
  ];

  void setupIsLoginUI() {
    userName = AppConfigSingleton.instance.mUserName;
    if (AppConfigSingleton.instance.isLogin) {
      if (mListType.length >= 3) {
        mListType.removeAt(1);
      } else if (mListType.length == 2) {
        mListType.removeAt(0);
        mListType.insert(
          0,
          MemberPageListModel('会员资料', Icons.account_box, 0)
        );
      }
    } else if (!AppConfigSingleton.instance.isLogin && mListType.length >= 3) {
      mListType.removeAt(0);
    }

    notifyListeners();
  }
}
