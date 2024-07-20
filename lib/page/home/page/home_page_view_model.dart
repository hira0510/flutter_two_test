import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_two_test/api/eat_store_api.dart';
import 'package:flutter_two_test/help_object/log_util.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum RequestState{
  LOAD_FAILED,
  LOAD_COMPLETE,
  LOAD_NO_MORE_DATA
}

class HomePageViewModel extends ChangeNotifier {

  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  bool showToTopBtn = false;

  List<AttractionsInfo> mData = [];


  set _mModel(AttractionsModel value) {
    if (value.head != null) {
      if (value.head!.infos != null) {
        mData = value.head!.infos!.info!;
        var j = 1;
        for (var i = 0; i < mData.length; i++) {
          if ((i + j) % 19 == 0) {
            mData.insert(i, AttractionsInfo()..name = 'googleAd');
          }
        }
        notifyListeners();
      }
    }
  }

  Future<RequestState> getData() async {
    late RequestState requestState;
    if (mData.isNotEmpty) { return RequestState.LOAD_NO_MORE_DATA; }
    _addScrollListener();

    LogUtil.logI("getData dataCount: ${mData.length}");

    String mUrl =
        'https://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json';
    var response = ApiService.getInstance().getHttp(mUrl);

    await response.then((value){
      final AttractionsModel model = AttractionsModel.fromJson(json.decode(value.data.toString()));
      _mModel = model;
      requestState = RequestState.LOAD_COMPLETE;
    }).onError((error, stackTrace) {
      LogUtil.logE(error.toString());
      requestState = RequestState.LOAD_FAILED;
    });
    return requestState;
  }

  void _addScrollListener() {
    scrollController.addListener(() {
      if ((scrollController.offset > 400 && !showToTopBtn) ||
          (scrollController.offset <= 400 && showToTopBtn)) {
        _displayToTopBtn();
      }
    });
  }

  void _displayToTopBtn() {
    showToTopBtn = !showToTopBtn;
    notifyListeners();
  }
}
