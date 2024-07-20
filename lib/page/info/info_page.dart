import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/ad/anchored_adaptive_ad_widget.dart';
import 'package:flutter_two_test/common_widget/cached_network_image_widget.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key, required this.infoModel}) : super(key: key);
  final AttractionsInfo infoModel;

  static void start(BuildContext context, AttractionsInfo infoModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoPage(infoModel: infoModel)));
  }

  @override
  State<InfoPage> createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  AttractionsInfo get infoModel => widget.infoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _setupAppBarUI(),
      body: GestureDetector(
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: SafeArea(
          child: Stack(
            children: [
              _buildBgImg(),
              _buildInfoScroll(),
              _buildAnchoredAdaptive(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBgImg() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Opacity(
        child: Image.asset(
          'assets/image/bg.png',
          fit: BoxFit.cover,
        ),
        opacity: 0.5,
      ),
    );
  }

  Widget _buildInfoScroll() {
    return CustomScrollView(
      slivers: [
        _buildInfoImage(),
        _buildInfoText(),
      ],
    );
  }

  Widget _buildInfoImage() {
    List<String> imageList = [
      infoModel.image1 == '' ? 'noData' : infoModel.image1,
      infoModel.image2,
      infoModel.image3,
    ];
    imageList = imageList.takeWhile((value) => value != "").toList();
    return SliverToBoxAdapter(
      child: Column(
        children: imageList.map((url) {
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 15),
            width: 345.r,
            height: 300.r,
            child: CachedNetworkImageWidget(url),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoText() {
    List<String> titleList = ['名稱', '地址', '電話', '營業時間', '停車資訊', '網站', '介紹'];
    List<String> textList = [
      infoModel.name,
      infoModel.add,
      infoModel.tel,
      infoModel.openTime,
      infoModel.parkingInfo,
      infoModel.website,
      infoModel.description,
    ];

    return SliverToBoxAdapter(
      child: Column(
        children: textList.asMap().entries.map((e) {
          return Container(
            width: 345.r,
            margin: (e.key == titleList.length - 1)
                ? const EdgeInsets.fromLTRB(15, 10, 15, 60)
                : const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${titleList[e.key]}： ",
                    style: TextStyle(
                      backgroundColor: Colors.white.withAlpha(200),
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  TextSpan(
                    text: textList[e.key],
                    style: TextStyle(
                      backgroundColor: Colors.white.withAlpha(200),
                      color:
                          (e.key == 5) ? Colors.blue : const Color(0xDD000030),
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                    onEnter: _onRecognizer(
                      textList[e.key],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  ///锚定自适应横幅廣告
  Widget _buildAnchoredAdaptive() {
    return Positioned(
      left: 15,
      right: 15,
      bottom: 5,
      child: SizedBox(
        width: 345.r,
        height: 50.r,
        child: const AnchoredAdaptiveAdWidget(),
      ),
    );
  }

  /// Navigation
  PreferredSizeWidget? _setupAppBarUI() {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      title: Text(infoModel.name),
      backgroundColor: Colors.teal,
    );
  }

  /// 點擊
  _onRecognizer(String str) {
    // LinkFactory.launchUrl(str);
  }

  /// 手勢pop
  _onHorizontalDragEnd(detills) {
    if (detills.primaryVelocity == null) return;
    if (detills.primaryVelocity! >= 1) {
      if (Platform.isIOS) {
        Navigator.pop(context);
      }
    }
  }
}
