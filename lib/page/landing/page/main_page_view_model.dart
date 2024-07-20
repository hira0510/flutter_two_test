import 'dart:async';

import 'package:flutter/material.dart';

class MainPageListModel {
  final String pageName;
  final Icon pageIcon;
  final Icon pageSelectIcon;
  final int mIndex;

  MainPageListModel(this.pageName, this.pageIcon, this.pageSelectIcon, this.mIndex);
}

class MainPageViewModel extends ChangeNotifier {
  StreamController<bool> isDisplaySystemDialog = StreamController();
  int mCurrentIndex = 0;

  late List<MainPageListModel> mListType =
  [
    MainPageListModel('首页', const Icon(Icons.home_outlined), const Icon(Icons.home), 0),
    MainPageListModel('收藏', const Icon(Icons.favorite_border), const Icon(Icons.favorite), 1),
    MainPageListModel('会员', const Icon(Icons.account_circle_outlined), const Icon(Icons.account_circle), 2)
  ];
}