import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_two_test/api/eat_store_api.dart';
import 'package:flutter_two_test/database/entity/attractions_db_entity.dart';
import 'package:flutter_two_test/database/manager/attractions_manager.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';

class FavorPageViewModel extends ChangeNotifier {
  bool stateDone = false;

  List<AttractionsInfo> _data = [];

  List<AttractionsInfo> get mData => _data;

  set _mModel(List<AttractionsDbEntity> sqlData) {
    List<AttractionsInfo> tempModel = [];
    for (var data in sqlData) {
      AttractionsInfo tempData = AttractionsInfo()
        ..id = data.sid
        ..name = data.name
        ..tel = data.tel
        ..add = data.add
        ..description = data.description
        ..image1 = data.image1
        ..image2 = data.image2
        ..image3 = data.image3
        ..openTime = data.openTime
        ..parkingInfo = data.parkingInfo
        ..website = data.website
        ..px = data.px
        ..py = data.py;
      tempModel.add(tempData);
    }
    _data = tempModel;
    notifyListeners();
  }

  Future getData() async {

    List<AttractionsDbEntity> sqlFavData =
        await AttractionsManager.instance.getAllData();

    if (mData.length != sqlFavData.length) {
      LogUtil.logI("setFavData dataCount: ${mData.length}, sqlFavData: ${sqlFavData.length}");
      _mModel = sqlFavData;
    }
  }
}
