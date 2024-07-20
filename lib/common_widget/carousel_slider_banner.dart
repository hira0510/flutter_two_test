import 'dart:async';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/page/info/custom_player/player_list_model.dart';
import 'package:flutter_two_test/page/info/info_player_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CarouselSliderBanner extends StatefulWidget {
  const CarouselSliderBanner(this.modelIsNull, {Key? key}) : super(key: key);
  final bool modelIsNull;

  @override
  State<CarouselSliderBanner> createState() => CarouselSliderBannerState();
}

class CarouselSliderBannerState extends State<CarouselSliderBanner> {
  late final IndexChangeNotifier _indexChangeNotifier = IndexChangeNotifier();
  final _playerModel = PlayerListModel();

  @override
  Widget build(BuildContext context) {
    List<String> data = _playerModel.randomVideoList();
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<IndexChangeNotifier>.value(
        value: _indexChangeNotifier,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: CarouselSlider(
                  items: data
                      .asMap()
                      .entries
                      .map((e) => _buildSliderBannerWidget(data[e.key], e.key))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 375 / 200,
                    onPageChanged: (index, _) {
                      _indexChangeNotifier.current = index;
                    },
                  ),
                ),
              ),
            ),
            Positioned.fill(
              bottom: 20.r,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildIndicator(data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderBannerWidget(String videoUrl, int index) {
    if (widget.modelIsNull) {
      return Shimmer.fromColors(
        period: const Duration(milliseconds: 800),
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
      );
    } else {
      return _buildCarouselSliderItem(videoUrl, index);
    }
  }

  Widget _buildCarouselSliderItem(String videoUrl, int index) {
    return FutureBuilder<Uint8List?>(
      future: getVideoImage(videoUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            color: Colors.white70,
            child: GestureDetector(
              child: (snapshot.data == null)
                  ? Image.asset(
                      'assets/image/700049拷貝.png',
                      fit: BoxFit.fill,
                    )
                  : Image.memory(
                      snapshot.data,
                      fit: BoxFit.fill,
                    ),
              onTap: () =>
                  InfoPlayerPage.start(context, index, videoUrl, snapshot.data),
            ));
      },
    );
  }

  Widget _buildIndicator(List<String> data) {
    return Consumer<IndexChangeNotifier>(
      builder: (_, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: data.asMap().entries.map(
            (e) {
              return Container(
                height: 3.r,
                width: 20.r,
                margin: const EdgeInsets.only(left: 10, right: 10),
                color: (e.key == model.current) ? Colors.white : Colors.grey,
              );
            },
          ).toList(),
        );
      },
    );
  }

  Future<Uint8List?> getVideoImage(String videoUrl) async {
    return await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.PNG,
      maxHeight: 200,
      quality: 100,
    );
  }
}

class IndexChangeNotifier extends ChangeNotifier {
  IndexChangeNotifier();

  int _current = 0;

  int get current => _current;

  set current(int value) {
    _current = value;
    notifyListeners();
  }
}
