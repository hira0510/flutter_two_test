import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/database/manager/attractions_manager.dart';
import 'package:flutter_two_test/common_widget/cached_network_image_widget.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';
import 'package:flutter_two_test/page/info/info_page.dart';
import 'package:provider/provider.dart';

class HomePageInfoCell extends StatefulWidget {
  const HomePageInfoCell({Key? key, this.infoModel}) : super(key: key);
  final AttractionsInfo? infoModel;

  @override
  State<StatefulWidget> createState() => HomePageInfoCellState();
}

class HomePageInfoCellState extends State<HomePageInfoCell> {
  bool isFavor = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.white,
        width: 100.r,
        height: 140.r,
        child: GestureDetector(
          child: Column(
            children: [
              _imageContainViewUI(),
              _textUI(),
            ],
          ),
          onTap: () => {
            if (widget.infoModel != null)
              {InfoPage.start(context, widget.infoModel!)}
          },
        ),
      ),
    );
  }

  /// 圖片底下的view
  Widget _imageContainViewUI() {
    return Stack(
      children: [_imageUI(), _favorBtnUI()],
    );
  }

  /// 圖片
  Widget _imageUI() {
    return AspectRatio(
      aspectRatio: 0.88,
      child: CachedNetworkImageWidget(
          (widget.infoModel == null) ? '' : widget.infoModel!.image1, fit: BoxFit.cover,),
    );
  }

  Widget _favorBtnUI() {
    if (widget.infoModel == null) {
      return Container();
    }
    return Consumer<AttractionsManager>(
        builder: (context, attractionsManager, child) {
      return FutureBuilder<bool>(
        future: attractionsManager.isDataExist(widget.infoModel!.id),
        builder: (context, snapshot) {
          isFavor = snapshot.data ?? false;
          return Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              child: CircleAvatar(
                backgroundColor: const Color(0x80ffffff),
                radius: 15,
                child: Icon(isFavor ? Icons.favorite : Icons.favorite_border),
              ),
              onTap: () => {
                attractionsManager.addOrDelete(widget.infoModel!),
              },
            ),
          );
        },
      );
    });
  }

  /// 文字
  Widget _textUI() {
    if (widget.infoModel == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.infoModel!.name,
        style: const TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
