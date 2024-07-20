import 'dart:io';
import 'dart:typed_data';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_two_test/ad/ad_provider_manager.dart';
import 'package:flutter_two_test/help_object/route_observer_util.dart';
import 'package:flutter_two_test/page/info/custom_player/player_list_model.dart';
import 'package:flutter_two_test/page/info/custom_player/custom_player_widget.dart';
import 'package:provider/provider.dart';

class InfoPlayerPage extends StatefulWidget {
  const InfoPlayerPage(
      {Key? key,
      required this.listIndex,
      required this.videoUrl,
      required this.videoImg})
      : super(key: key);
  final Uint8List? videoImg;
  final int listIndex;
  final String videoUrl;

  static void start(
      BuildContext context, int listIndex, String videoUrl, Uint8List? image) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoPlayerPage(
                listIndex: listIndex, videoUrl: videoUrl, videoImg: image)));
  }

  @override
  State<InfoPlayerPage> createState() => InfoPlayerPageState();
}

class InfoPlayerPageState extends State<InfoPlayerPage>
    with RouteAware, WidgetsBindingObserver {
  late final _playerModel = PlayerListModel();
  final _routeObserver = RouteObserverUtil().routeObserver;
  CustomVideoPlayer? _playerWidget;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _playerWidget?.player.stop();
    _playerWidget?.player.release();
    _routeObserver.unsubscribe(this);
    _playerModel.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_playerWidget?.player.state == FijkState.asyncPreparing) {
        _playerWidget?.player.stop();
      } else {
        _playerWidget?.player.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _playerModel),
      ],
      builder: (_, snapshot) {
        if (_playerModel.prepareShowAd) {
          AdProviderManager.instance.showRewardedAd(() {
            setupPlayer();
          });
        } else {
          setupPlayer();
        }
        return _build();
      },
    );
  }

  Widget _build() {
    return Consumer<PlayerListModel>(builder: (context, viewModel, child) {
      return Scaffold(
        body: GestureDetector(
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Opacity(
                    child: Image.asset(
                      'assets/image/bg.png',
                      fit: BoxFit.cover,
                    ),
                    opacity: 0.5,
                  ),
                ),
                Center(
                  child: viewModel.prepareShowAd
                      ? _buildVideoImageWidget()
                      : _playerWidget,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildVideoImageWidget() {
    var screenW = MediaQuery.of(context).size.width;
    return Container(
      width: screenW,
      height: 202 * screenW / 340,
      color: Colors.black,
      child: (widget.videoImg == null)
          ? Image.asset(
              'assets/image/700049拷貝.png',
              fit: BoxFit.fill,
            )
          : Image.memory(
              widget.videoImg!,
              fit: BoxFit.fill,
            ),
    );
  }

  /// 初始化播放器
  void setupPlayer() {
    _playerModel.setPlayerList(widget.listIndex, widget.videoUrl);
    final videoPlayer = CustomVideoPlayer(_playerModel, (value) {
      _videoListener(value);
    });
    _playerWidget ??= videoPlayer;
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

  /// 播放器狀態監聽
  void _videoListener(FijkValue value) {
    switch (value.state) {
      case FijkState.idle:
        break;
      case FijkState.initialized:
        break;
      case FijkState.asyncPreparing:
        break;
      case FijkState.prepared:
        break;
      case FijkState.started:
        break;
      case FijkState.paused:
        break;
      case FijkState.completed:
        break;
      case FijkState.stopped:
        break;
      case FijkState.error:
        break;
      case FijkState.end:
        break;
    }
  }
}
