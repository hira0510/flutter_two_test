import 'package:flutter/cupertino.dart';
import 'package:flutter_two_test/database/dao/attractions_dao.dart';
import 'package:flutter_two_test/database/database.dart';
import 'package:flutter_two_test/database/entity/attractions_db_entity.dart';
import 'package:flutter_two_test/dialog/favor_smart_dialog.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';

///使用Floor函式庫 詳情參考 https://pub.dev/packages/floor

class AttractionsManager extends ChangeNotifier {
  static final AttractionsManager instance =
      AttractionsManager._privateConstructor();

  AttractionsManager._privateConstructor();

  Future<AttractionsDao> _getDao() async {
    final db =
        await $FloorDBManager.databaseBuilder('test_attractions.db').build();
    return db.getAttractionsDao;
  }

  void deleteAllVideos() {
    _getDao().then((value) => value.deleteAllData());
  }

  Future<bool> isVideoExist(String sid) async {
    final dao = await _getDao();
    if (await dao.findDataBySid(sid) != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<AttractionsDbEntity?> getDataBySid(String sid) async {
    final dao = await _getDao();
    return await dao.findDataBySid(sid);
  }

  Future<bool> isDataExist(String sid) async {
    return (await getDataBySid(sid) != null);
  }

  void addOrDelete(AttractionsInfo data) async {
    final dao = await _getDao();
    var dataInfo = await dao.findDataBySid(data.id);
    if (dataInfo != null) {
      FavorSmartDialog.show('已刪除收藏!');
      LogUtil.logV("DEBUG_DB", " ${data.id} Is Exist Update Data");
      deleteVideo(data.id);
      notifyListeners();
    } else {
      FavorSmartDialog.show('已收藏!');
      LogUtil.logV("DEBUG_DB", "${data.id} Is Not Exist Insert Data");
      final model = dataToModel(data);
      dao.insertData(model);
      notifyListeners();
    }
    LogUtil.logV("DEBUG_DB", "addOrUpdate${data.toString()}");
  }

  void deleteVideo(String sid) async {
    final dao = await _getDao();
    var prevVideoData = await dao.findDataBySid(sid);
    if (prevVideoData != null) {
      dao.deleteData(prevVideoData);
      LogUtil.logI("Delete Video \"$sid\" Success ");
    } else {
      LogUtil.logE("Delete Video \"$sid\" Failed, No Such Video In DB");
    }
  }

  Future<List<AttractionsDbEntity>> getAllData() async {
    final dao = await _getDao();
    return dao.findAllData();
  }

  AttractionsDbEntity dataToModel(AttractionsInfo data) {
    AttractionsDbEntity tempData = AttractionsDbEntity(
      sid: data.id,
      name: data.name,
      tel: data.tel,
      add: data.add,
      description: data.description,
      image1: data.image1,
      image2: data.image2,
      image3: data.image3,
      openTime: data.openTime,
      parkingInfo: data.parkingInfo,
      website: data.website,
      px: data.px,
      py: data.py,
    );
    return tempData;
  }
}
