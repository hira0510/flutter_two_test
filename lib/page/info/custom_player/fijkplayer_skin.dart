import 'dart:async';
import 'dart:ui';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_two_test/page/info/custom_player/player_list_model.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'fijkplayer_gesture.dart';

double speed = 1.0;
bool lockStuff = false;
bool hideLockStuff = false;
const double barHeight = 50.0;
final double barFillingHeight =
    MediaQueryData.fromWindow(window).padding.top + barHeight;
final double barGap = barFillingHeight - barHeight;

class CustomFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final Size viewSize;
  final BuildContext? pageContent;
  final String playerTitle;
  final Function? onChangeVideo;

  /// m3u8Model
  final PlayerListModel playerModel;

  const CustomFijkPanel({
    Key? key,
    required this.player,
    required this.viewSize,
    this.pageContent,
    this.playerTitle = "",
    this.onChangeVideo,
    required this.playerModel,
  }) : super(key: key);

  @override
  _CustomFijkPanelState createState() => _CustomFijkPanelState();
}

class _CustomFijkPanelState extends State<CustomFijkPanel>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  FijkPlayer get player => widget.player;

  PlayerListModel get playerModel => widget.playerModel;

  bool _lockStuff = lockStuff;
  bool _hideLockStuff = hideLockStuff;
  bool _drawerState = false;
  Timer? _hideLockTimer;

  FijkState? _playerState;
  bool _isPlaying = false;

  StreamSubscription? _currentPosSubs;

  AnimationController? _animationController;
  Animation<Offset>? _animation;
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initEvent();
  }

  @override
  void dispose() {
    _currentPosSubs?.cancel();
    _hideLockTimer?.cancel();
    player.removeListener(_playerValueChanged);
    _tabController.dispose();
    _animationController!.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.playerModel,
      child: setupUI(),
    );
  }

  Widget setupUI() {
    Rect rect =
        Rect.fromLTWH(0, 0, widget.viewSize.width, widget.viewSize.height);

    List<Widget> ws = [];

    if (_playerState == FijkState.error) {
      ws.add(
        _buildPublicFrameWidget(
          slot: _buildErrorStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else if ((_playerState == FijkState.asyncPreparing ||
            _playerState == FijkState.initialized) &&
        !_isPlaying) {
      ws.add(
        _buildPublicFrameWidget(
          slot: _buildLoadingStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else if (_playerState == FijkState.idle && !_isPlaying) {
      ws.add(
        _buildPublicFrameWidget(
          slot: _buildIdleStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else {
      if (_lockStuff == true && player.value.fullScreen) {
        ws.add(
          _buildLockStateDetector(),
        );
      } else if (_drawerState == true && player.value.fullScreen) {
        ws.add(
          _buildPlayerListDrawer(),
        );
      } else {
        ws.add(
          buildGestureDetector(
            onChangeVideo: widget.onChangeVideo,
            player: player,
            pageContent: widget.pageContent,
            playerTitle: widget.playerTitle,
            viewSize: widget.viewSize,
            playerModel: playerModel,
            changeDrawerState: changeDrawerState,
            changeLockState: changeLockState,
          ),
        );
      }
    }

    return WillPopScope(
      child: Positioned.fromRect(
        rect: rect,
        child: Stack(
          children: ws,
        ),
      ),
      onWillPop: () async {
        if (_lockStuff == true) {
          changeLockState(false);
        }
        if (!player.value.fullScreen) player.stop();
        return true;
      },
    );
  }

  void initEvent() {
    _tabController = TabController(
      length: playerModel.allPlayerList.length,
      vsync: this,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    // init animation
    _animation = Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(_animationController!);
    // is not null
    if (playerModel.playerList.videoList.isEmpty) return;
    // init plater state
    setState(() {
      _playerState = player.value.state;
    });
    if (player.value.duration.inMilliseconds > 0 && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    }
    // is not null
    if (playerModel.playerList.videoList.isEmpty) return;
    // autoplay and existurl
    if (!_isPlaying) {
      changeCurPlayVideo();
    }
    player.addListener(_playerValueChanged);
    Wakelock.enable();
  }

  /// 获得播放器状态
  void _playerValueChanged() {
    if (player.value.duration.inMilliseconds > 0 && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    }
    setState(() {
      _playerState = player.value.state;
    });
  }

  /// 切换UI 播放列表显示状态
  void changeDrawerState(bool state) {
    if (state) {
      setState(() {
        _drawerState = state;
      });
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController!.forward();
    });
  }

  /// 切换UI lock显示状态
  void changeLockState(bool state) {
    setState(() {
      _lockStuff = state;
      if (state == true) {
        _hideLockStuff = true;
        _cancelAndRestartLockTimer();
      }
    });
  }

  /// 切换播放源
  Future<void> changeCurPlayVideo() async {
    await player.reset().then((_) {
      player.setDataSource(
        playerModel.playVideo,
        autoPlay: true,
      );
      // 回调
      widget.onChangeVideo!();
    });
  }

  void _cancelAndRestartLockTimer() {
    if (_hideLockStuff == true) {
      _startHideLockTimer();
    }
    setState(() {
      _hideLockStuff = !_hideLockStuff;
    });
  }

  void _startHideLockTimer() {
    _hideLockTimer?.cancel();
    _hideLockTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _hideLockStuff = true;
      });
    });
  }

  /// 锁 组件
  Widget _buildLockStateDetector() {
    var safeLeft = MediaQuery.of(context).padding.left;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _cancelAndRestartLockTimer,
      child: AnimatedOpacity(
        opacity: _hideLockStuff ? 0 : 1,
        duration: const Duration(milliseconds: 400),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 48 + safeLeft,
              top: !player.value.fullScreen ? barGap : 0,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 32,
              onPressed: () {
                setState(() {
                  _lockStuff = false;
                  _hideLockStuff = true;
                });
              },
              icon: Image.asset(
                'assets/image/icon_player_lock_on.png',
                height: 32,
                width: 32,
              ),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 抽屉组件 - 播放列表
  Widget _buildPlayerListDrawer() {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _animationController!.reverse();
                setState(() {
                  _drawerState = false;
                });
              },
            ),
          ),
          SlideTransition(
            position: _animation!,
            child: SizedBox(
              height: window.physicalSize.height,
              width: 320,
              child: _buildPlayDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  /// build 剧集
  Widget _buildPlayDrawer() {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.4),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
        automaticallyImplyLeading: false,
        elevation: 0.1,
        title: TabBar(
          labelColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          unselectedLabelColor: Colors.white,
          unselectedLabelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          indicator: BoxDecoration(
            color: Colors.green.shade200,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          tabs: playerModel.allPlayerList
              .map((e) => Tab(text: e.listName))
              .toList(),
          isScrollable: true,
          controller: _tabController,
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.5),
        child: TabBarView(
          controller: _tabController,
          children: _createTabConList(),
        ),
      ),
    );
  }

  /// 剧集 tabCon
  List<Widget> _createTabConList() {
    List<Widget> list = [];
    playerModel.allPlayerList.asMap().keys.forEach((int tabIdx) {
      final playerList = playerModel.allPlayerList[tabIdx];
      List<Widget> playListBtn =
          playerList.videoList.asMap().keys.map((int activeIdx) {
        final listName = '${playerList.listName}${activeIdx + 1}';
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  (playerModel.selectListName == listName)
                      ? Colors.tealAccent.shade400
                      : Colors.teal),
            ),
            onPressed: () async {
              await _animationController!.reverse();
              setState(() {
                _drawerState = false;
              });
              playerModel.changeOtherVideo(
                  listIndex: tabIdx, videoIndex: activeIdx);
              changeCurPlayVideo();
            },
            child: Text(
              listName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList();

      list.add(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Wrap(
              direction: Axis.horizontal,
              children: playListBtn,
            ),
          ),
        ),
      );
    });
    return list;
  }

  /// 返回按钮
  Widget _buildTopBackBtn() {
    var screenW = MediaQuery.of(context).size.height / 375;
    var safeLeft = MediaQuery.of(context).padding.left;
    final _isFullScreen = player.value.fullScreen;
    return _isFullScreen ?
    Positioned(
      top: safeLeft,
      left: 0,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 56 * screenW,
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24 * screenW,
        ),
        color: Colors.white,
        onPressed: () {
          if (_isFullScreen) {
            _setPlayerFullScreen(false);
          } else {
            changeDrawerState(false);
            if (widget.pageContent == null) return;
            player.stop();
            Navigator.pop(widget.pageContent!);
          }
        },
      ),
    ): Container();
  }

  void _setPlayerFullScreen(bool isFullScreen) {
    if (isFullScreen) {
      player.enterFullScreen();
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        FijkPlugin.setOrientationLandscape();
      }
    } else {
      player.exitFullScreen();
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        FijkPlugin.setOrientationPortrait();
      }
    }
  }

  /// 可以共用的架子
  Widget _buildPublicFrameWidget({required Widget slot, Color? bgColor}) {
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Center(
              child: slot,
            ),
          ),
        ],
      ),
    );
  }

  /// 错误slot
  Widget _buildErrorStateSlotWidget() {
    return Stack(
      children: [
        _buildTopBackBtn(),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: !player.value.fullScreen ? barGap : 0,
              ),
              // 失败图标
              const Icon(
                Icons.error,
                size: 50,
                color: Colors.white,
              ),
              // 错误信息
              const Text(
                "การเล่นล้มเหลว คุณสามารถคลิกเพื่อลองอีกครั้ง",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              // 重试
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  changeCurPlayVideo();
                },
                child: const Text(
                  "คลิกเพื่อลองอีกครั้ง",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 加载中slot
  Widget _buildLoadingStateSlotWidget() {
    return SizedBox(
      width: widget.viewSize.width,
      height: widget.viewSize.height,
      // 不知為何點擊播放器會pop, 所以加一個GestureDetector
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          width: 42.r,
          height: 42.r,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }

  /// 未开始slot
  Widget _buildIdleStateSlotWidget() {
    return IconButton(
      iconSize: barHeight * 1.2,
      icon: const Icon(Icons.play_arrow, color: Colors.white),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      onPressed: () async {
        await changeCurPlayVideo();
      },
    );
  }
}
