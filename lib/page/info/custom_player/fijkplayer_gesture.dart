import 'dart:async';
import 'dart:math';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_two_test/page/info/custom_player/player_list_model.dart';
import 'package:flutter_two_test/page/info/custom_player/slider.dart';
import 'package:provider/provider.dart';

import 'fijkplayer_skin.dart';

// ignore: camel_case_types
class buildGestureDetector extends StatefulWidget {
  final FijkPlayer player;
  final Size viewSize;
  final BuildContext? pageContent;
  final String playerTitle;
  final Function? onChangeVideo;
  final Function changeDrawerState;
  final Function changeLockState;

  //m3u8Model
  final PlayerListModel playerModel;

  const buildGestureDetector({
    Key? key,
    required this.player,
    required this.viewSize,
    this.pageContent,
    this.playerTitle = "",
    this.onChangeVideo,
    required this.changeDrawerState,
    required this.changeLockState,
    required this.playerModel,
  }) : super(key: key);

  @override
  _buildGestureDetectorState createState() => _buildGestureDetectorState();
}

// ignore: camel_case_types
class _buildGestureDetectorState extends State<buildGestureDetector> {
  FijkPlayer get player => widget.player;

  PlayerListModel get playerModel => widget.playerModel;

  /// 總時長
  Duration _duration = const Duration();

  /// 是否是全屏
  bool _isFullScreen = false;

  /// 現在播放到哪
  Duration _currentPos = const Duration();

  ///換標高清要跳轉的位子
  Duration _changeSourcePos = const Duration();

  Duration _bufferPos = const Duration();

  /// 快進/快退 毫秒
  int nextOrBackTime = 30000;

  /// 快進快退的seek time
  int doubleTapSeekTime = 0;

  /// 滑动后值
  Duration _dragPos = const Duration();

  ///各種確認是否已經打flurry
  ///拖曳進度條
  bool shouldSendProgressFlurry = true;

  /// 條音量
  bool shouldSendVolumeFlurry = true;

  /// 條亮度
  bool shouldSendLightnessFlurry = true;

  bool _isTouch = false;

  bool _playing = false;
  bool _prepared = false;
  bool _isStopped = false;
  String? _exception;

  double? updatePrevDx;
  double? updatePrevDy;
  int? updatePosX;

  bool? isDragVerLeft;

  double? updateDragVarVal;

  bool varTouchInitSuc = false;

  bool _buffering = false;

  double _seekPos = -1.0;

  StreamSubscription? _currentPosSubs;
  StreamSubscription? _bufferPosSubs;
  StreamSubscription? _bufferingSubs;

  Timer? _hideTimer;
  bool _hideStuff = true;

  bool _hideSpeedStu = true;
  double _speed = speed;

  bool _isHorizontalMove = false;

  double screenW = 1;

  Map<String, double> speedList = {
    "2.0": 2.0,
    "1.5": 1.5,
    "1.25": 1.25,
    "1.0": 1.0,
    "0.5": 0.5,
  };

  // 初始化构造函数
  _buildGestureDetectorState();

  void initEvent() {
    // 设置初始化的值，全屏与半屏切换后，重设
    setState(() {
      // 每次重绘的时候，判断是否已经开始播放
      _hideStuff = !_playing ? false : true;
    });
    // 延时隐藏
    _startHideTimer();
  }

  @override
  void initState() {
    super.initState();

    initEvent();
    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _isStopped = player.state == FijkState.stopped;
    _exception = player.value.exception.message;
    _buffering = player.isBuffering;
    _isFullScreen = player.value.fullScreen;

    //因為轉成全屏時會暫停 所以這邊加一個播放
    player.start();
    player.addListener(_playerValueChanged);

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      setState(() {
        doubleTapSeekTime = _currentPos.inMilliseconds;
        _currentPos = v;
        // 后加入，处理fijkplay reset后状态对不上的bug，
        _playing = true;
        _prepared = true;
        _isStopped = false;
      });
    });

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      setState(() {
        _bufferPos = v;
      });
    });

    _bufferingSubs = player.onBufferStateUpdate.listen((v) {
      setState(() {
        _buffering = v;
      });
    });
    playerModel.addListener(() {
      // _changeSourcePos = _currentPos;
      changeCurPlayVideo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _hideTimer?.cancel();

    playerModel.removeListener(() {});
    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
    _bufferingSubs?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    screenW = _isFullScreen
        ? MediaQuery.of(context).size.height / 375
        : MediaQuery.of(context).size.width / 375;

    return Consumer<PlayerListModel>(
      builder: (BuildContext _context, PlayerListModel model, Widget? child) {
        return WillPopScope(
            child: SafeArea(
              bottom: false,
              child: _buildGestureDetector(model),
            ),
            onWillPop: () async {
              if (_isFullScreen) {
                _setPlayerFullScreen(false);
                return false;
              } else {
                return true;
              }
            });
      },
    );
  }

  /// 播放器控制器 ui
  Widget _buildGestureDetector(PlayerListModel model) {
    return GestureDetector(
      onTap: _cancelAndRestartTimer,
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: AbsorbPointer(
        absorbing: _hideStuff,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                // 播放器顶部控制器
                _buildTopBar(model),
                // 中间按钮
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      // 中间按钮(播放/暫停)
                      _buildCenterPlayBtn(),
                      // 中间按钮(快退30s)
                      _buildCenterSeekTimeBtn(false),
                      // 中间按钮(快進30s)
                      _buildCenterSeekTimeBtn(true),
                      // 锁按钮
                      _buildCenterLockBtn(),
                    ],
                  ),
                ),
                // 播放器底部控制器
                _buildBottomBar(),
              ],
            ),
            // 返回按鈕
            _buildTopBackBtn(),
            // 倍数选择視窗
            _buildSpeedListWidget(),
            // 顶部显示音量
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 显示左右滑动快进时间的块
                  _buildDargProgressTime(),
                  // 显示上下滑动音量亮度
                  _buildDargVolumeAndBrightness()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 手勢 播放進度開始
  _onHorizontalDragStart(detills) {
    setState(() {
      updatePrevDx = detills.globalPosition.dx;
      updatePosX = _currentPos.inMilliseconds;
    });
  }

  /// 手勢 播放進度更新
  _onHorizontalDragUpdate(detills) {
    double curDragDx = detills.globalPosition.dx;
    // 确定当前是前进或者后退
    int cdx = curDragDx.toInt();
    int pdx = updatePrevDx!.toInt();
    bool isBefore = cdx > pdx;

    // 计算手指滑动的比例
    int newInterval = pdx - cdx;
    double playerW = MediaQuery.of(context).size.width;
    int curIntervalAbs = newInterval.abs();
    double movePropCheck = (curIntervalAbs / playerW) * 100;

    // 计算进度条的比例
    double durProgCheck = _duration.inMilliseconds.toDouble() / 100;
    int checkTransfrom = (movePropCheck * durProgCheck).toInt();
    int dragRange =
        isBefore ? updatePosX! + checkTransfrom : updatePosX! - checkTransfrom;

    // 是否溢出 最大
    int lastSecond = _duration.inMilliseconds;
    if (dragRange >= _duration.inMilliseconds) {
      dragRange = lastSecond;
    }
    // 是否溢出 最小
    if (dragRange <= 0) {
      dragRange = 0;
    }
    //
    setState(() {
      _isHorizontalMove = true;
      _hideStuff = false;
      _isTouch = true;
      // 更新下上一次存的滑动位置
      updatePrevDx = curDragDx;
      // 更新时间
      updatePosX = dragRange.toInt();
      _dragPos = Duration(milliseconds: updatePosX!.toInt());
    });
  }

  /// 手勢 播放進度結束
  _onHorizontalDragEnd(detills) {
    player.seekTo(_dragPos.inMilliseconds);

    if (!_playing) {
      player.start();
    }
    setState(() {
      _isHorizontalMove = false;
      _isTouch = false;
      _hideStuff = true;
      _currentPos = _dragPos;
    });
  }

  /// 手勢 亮度/音量開始
  _onVerticalDragStart(detills) async {
    double clientW = widget.viewSize.width;
    double curTouchPosX = detills.globalPosition.dx;

    setState(() {
      // 更新位置
      updatePrevDy = detills.globalPosition.dy;
      // 是否左边 大于 右边 音量 ， 小于 左边 亮度
      isDragVerLeft = (curTouchPosX > (clientW / 2)) ? false : true;
    });
    if (!isDragVerLeft!) {
      if (shouldSendVolumeFlurry) {
        shouldSendVolumeFlurry = false;
      }
      // 音量
      await FijkVolume.getVol().then((double v) {
        varTouchInitSuc = true;
        setState(() {
          updateDragVarVal = v;
        });
      });
    } else {
      // 亮度
      if (shouldSendLightnessFlurry) {
        shouldSendLightnessFlurry = false;
      }
      await FijkPlugin.screenBrightness().then((double v) {
        varTouchInitSuc = true;
        setState(() {
          updateDragVarVal = v;
        });
      });
    }
  }

  /// 手勢 亮度/音量更新
  _onVerticalDragUpdate(detills) {
    if (!varTouchInitSuc) return null;
    double curDragDy = detills.globalPosition.dy;
    // 确定当前是前进或者后退
    int cdy = curDragDy.toInt();
    int pdy = updatePrevDy!.toInt();
    bool isBefore = cdy < pdy;
    // + -, 不满足, 上下滑动合法滑动值，> 3
    if (isBefore && pdy - cdy < 3 || !isBefore && cdy - pdy < 3) return null;
    // 区间
    double dragRange =
        isBefore ? updateDragVarVal! + 0.03 : updateDragVarVal! - 0.03;
    // 是否溢出
    if (dragRange > 1) {
      dragRange = 1.0;
    }
    if (dragRange < 0) {
      dragRange = 0.0;
    }
    setState(() {
      updatePrevDy = curDragDy;
      varTouchInitSuc = true;
      updateDragVarVal = dragRange;
      // 音量
      if (!isDragVerLeft!) {
        FijkVolume.setVol(dragRange);
      } else {
        FijkPlugin.setScreenBrightness(dragRange);
      }
    });
  }

  /// 手勢 亮度/音量結束
  _onVerticalDragEnd(detills) {
    setState(() {
      varTouchInitSuc = false;
    });
  }

  /// 播放器顶部 UI欄
  Widget _buildTopBar(PlayerListModel model) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0 : 1,
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: _isFullScreen ? 100 * screenW : 74 * screenW,
        alignment: Alignment.bottomLeft,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xda000000),
              Color(0x00000000),
            ],
          ),
        ),
        child: SizedBox(
          height: _isFullScreen ? 100 * screenW : 74 * screenW,
          child: Stack(
            children: <Widget>[
              _isFullScreen ? _buildSourceIcon(model) : Container(),
              _isFullScreen ? _buildDrawerBtn() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  /// 播放器頂部 返回按钮
  Widget _buildTopBackBtn() {
    return Positioned(
      top: 0,
      left: 0,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: _isFullScreen ? 56 * screenW : 0,
        icon: Icon(
          Icons.arrow_back_ios,
          size: _isFullScreen ? 24 * screenW : 0,
        ),
        color: Colors.white,
        onPressed: () {
          // 判断当前是否全屏，如果全屏，退出
          if (_isFullScreen) {
            _setPlayerFullScreen(false);
          } else {
            widget.changeDrawerState(false);
            if (widget.pageContent == null) return;
            player.stop();
            Navigator.pop(widget.pageContent!);
          }
        },
      ),
    );
  }

  /// 播放器顶部 畫質按鈕
  Widget _buildSourceIcon(PlayerListModel model) {
    final isLastVideo = model.playVideo == model.playerList.videoList.last;
    IconData icon =
        isLastVideo ? Icons.stop_screen_share : Icons.queue_play_next;
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        color: Colors.white,
        padding: EdgeInsets.zero,
        iconSize: 30 * screenW,
        icon: Icon(icon),
        onPressed: () {
          if (isLastVideo) {
            return;
          }
          setState(() {
            model.changeNextVideo();
            changeCurPlayVideo();
          });
        },
      ),
    );
  }

  Widget _buildDrawerBtn() {
    return Positioned(
      top: 0,
      right: 30 * screenW + 15,
      child: TextButton(
        onPressed: () {
          // 调用父组件的回调
          widget.changeDrawerState(true);
        },
        child: Container(
          alignment: Alignment.center,
          width: 40,
          height: 30,
          child: const Text(
            "選集",
            style: TextStyle(color: Colors.white),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// 播放器中間地帶 播放按钮
  Widget _buildCenterPlayBtn() {
    String img = _playing
        ? 'assets/image/icon_player_pause.png'
        : 'assets/image/icon_player_play.png';
    double itemSize = _isFullScreen ? 64 : 42 * screenW;
    return Align(
      alignment: _isFullScreen ? Alignment.center : const Alignment(0, -1),
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: (_prepared && !_buffering)
            ? AnimatedOpacity(
                opacity: _hideStuff ? 0 : 1,
                duration: const Duration(milliseconds: 400),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    img,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  onPressed: _playOrPause,
                ),
              )
            : SizedBox(
                width: itemSize,
                height: itemSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
      ),
    );
  }

  /// 播放器中間地帶 快進快退按鈕
  Widget _buildCenterSeekTimeBtn(bool isNext) {
    double align = isNext ? 99 / 180 : -99 / 180;
    double fullAlign = isNext ? 152 / 320 : -152 / 320;
    double itemSize = _isFullScreen ? 64 : 42 * screenW;
    String img = isNext
        ? 'assets/image/icon_player_next30s.png'
        : 'assets/image/icon_player_back30s.png';
    return Align(
      alignment: _isFullScreen ? Alignment(fullAlign, 0) : Alignment(align, -1),
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: AnimatedOpacity(
          opacity: _hideStuff ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Image.asset(
              img,
              height: double.infinity,
              width: double.infinity,
            ),
            onPressed: isNext ? didClickNext30Btn : didClickBack30Btn,
          ),
        ),
      ),
    );
  }

  /// 播放器中間地帶 锁按钮
  Widget _buildCenterLockBtn() {
    return _isFullScreen
        ? Align(
            alignment: Alignment.centerLeft,
            child: AnimatedOpacity(
              opacity: _hideStuff ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(left: 48),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 32,
                  onPressed: () {
                    // 更改 ui显示状态
                    _setLockScreen(true);
                  },
                  icon: Image.asset(
                    'assets/image/icon_player_lock_off.png',
                    height: 32,
                    width: 32,
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container();
  }

  /// 播放器中間地帶 滑动进度时间
  Widget _buildDargProgressTime() {
    if (_isTouch) {
      if (shouldSendProgressFlurry) {
        shouldSendProgressFlurry = false;
      }
      return Container(
        height: 32 * screenW,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            '${_duration2String(_dragPos)} / ${_duration2String(_duration)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  /// 播放器中間地帶 垂直亮度/音量
  Widget _buildDargVolumeAndBrightness() {
    // 不显示
    if (!varTouchInitSuc) return Container();

    String iconStr;
    iconStr = !isDragVerLeft!
        ? 'assets/image/icon_player_volume.png'
        : 'assets/image/icon_player_sun.png';
    // IconData iconData;
    // 判断当前值范围，显示的图标
    // if (updateDargVarVal! <= 0) {
    //   iconData = !isDargVerLeft! ? Icons.volume_mute : Icons.brightness_low;
    // } else if (updateDargVarVal! < 0.5) {
    //   iconData = !isDargVerLeft! ? Icons.volume_down : Icons.brightness_medium;
    // } else {
    //   iconData = !isDargVerLeft! ? Icons.volume_up : Icons.brightness_high;
    // }

    /// 显示，亮度 || 音量
    return Card(
      color: const Color(0x73ffffff),
      child: Container(
        width: 84 * screenW,
        height: 32 * screenW,
        padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              iconStr,
              width: 20 * screenW,
              height: 20 * screenW,
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: Text(
                '${((updateDragVarVal ?? 0) * 100.0).toInt()}%',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 播放器中間地帶 倍数列表
  Widget _buildSpeedListWidget() {
    return Positioned(
      right: 30 * screenW,
      bottom: 56 * screenW,
      child: !_hideSpeedStu
          ? Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: Column(
                  children: _buildSpeedListItemWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: const Color(0x91000000),
                borderRadius: BorderRadius.circular(9),
              ),
            )
          : Container(),
    );
  }

  /// 播放器中間地帶 倍数item
  List<Widget> _buildSpeedListItemWidget() {
    List<Widget> columnChild = [];
    speedList.forEach((String mapKey, double speedVals) {
      columnChild.add(
        Ink(
          child: InkWell(
            onTap: () {
              if (_speed == speedVals) return;
              setState(() {
                _speed = speed = speedVals;
                _hideSpeedStu = true;
                player.setSpeed(speedVals);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 64,
              height: 46,
              child: Text(
                mapKey + " X",
                style: TextStyle(
                  color: _speed == speedVals
                      ? Colors.white
                      : const Color(0x80ffffff),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      );
      columnChild.add(
        Container(
          width: 64,
          height: 1,
          color: Colors.white10,
        ),
      );
    });
    columnChild.removeAt(columnChild.length - 1);
    return columnChild;
  }

  /// 播放器底部 (不知道為啥少了這widget就不能控制高度了)
  Widget _buildBottomBar() {
    return _isFullScreen
        ? _buildBottomToolUI(100 * screenW)
        : _buildBottomToolUI(85 * screenW);
  }

  /// 播放器底部 UI欄
  Widget _buildBottomToolUI(double barHeight) {
    return SizedBox(
      height: barHeight,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0 : 1,
        duration: const Duration(milliseconds: 400),
        child: Container(
          height: barHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Color(0x00000000),
                Color(0xda000000),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 35 * screenW,
                child: SizedBox(
                    height: 12 * screenW, child: _buildBtnTimeProgress()),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 35 * screenW,
                  child: Stack(
                    children: [
                      // 按钮 - 播放/暂停
                      _buildBtmPlayBtn(),
                      // 已播放时间
                      _buildPlayTimeText(),
                      // 倍数按钮
                      _buildBtmSpeedBtn(),
                      // 按钮 - 全屏/退出全屏
                      _buildBtmFullScreenBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBtnTimeProgress() {
    // 计算进度时间
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue = _seekPos > 0
        ? _seekPos
        : (_isHorizontalMove
            ? _dragPos.inMilliseconds.toDouble()
            : _currentPos.inMilliseconds.toDouble());
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);

    // 播放进度 if 没有开始播放 占满，空ui， else fijkSlider widget
    return _duration.inMilliseconds == 0
        ? Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: NewFijkSlider(
              colors: const NewFijkSliderColors(
                cursorColor: Colors.tealAccent,
                playedColor: Colors.teal,
              ),
              onChangeEnd: (double value) {},
              value: 0,
              onChanged: (double value) {},
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: NewFijkSlider(
              colors: const NewFijkSliderColors(
                cursorColor: Colors.tealAccent,
                playedColor: Colors.teal,
              ),
              value: currentValue,
              cacheValue: _bufferPos.inMilliseconds.toDouble(),
              min: 0.0,
              max: duration,
              onChanged: (v) {
                _startHideTimer();
                setState(() {
                  _seekPos = v;
                });
              },
              onChangeEnd: (v) {
                setState(() {
                  player.seekTo(v.toInt());
                  if (!_playing) {
                    player.start();
                  }
                  // ignore: avoid_print
                  print("seek to $v");
                  _currentPos = Duration(milliseconds: _seekPos.toInt());
                  _seekPos = -1;
                });
              },
            ),
          );
  }

  /// 播放器底部 播放按鈕
  Widget _buildBtmPlayBtn() {
    String img = _playing
        ? 'assets/image/icon_player_pause.png'
        : 'assets/image/icon_player_play.png';
    return Positioned(
      left: 0,
      bottom: 0,
      child: SizedBox(
        width: 56 * screenW,
        height: 36 * screenW,
        child: IconButton(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
          icon: Image.asset(
            img,
            height: double.infinity,
            width: double.infinity,
          ),
          onPressed: _playOrPause,
        ),
      ),
    );
  }

  /// 播放器底部 播放進度時間
  Widget _buildPlayTimeText() {
    return Positioned(
      left: 56 * screenW,
      bottom: 0,
      child: SizedBox(
        height: 35 * screenW,
        child: Row(
          children: [
            // 已播放时间
            Text(
              _duration2String(_currentPos),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13 * screenW,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              ' / ',
              style: TextStyle(
                  color: const Color(0xffd9d9d9),
                  fontSize: 10 * screenW,
                  fontWeight: FontWeight.w300),
            ),
            // 总播放时间
            _duration.inMilliseconds == 0
                ? Text(
                    "00:00",
                    style: TextStyle(
                      color: const Color(0xffd9d9d9),
                      fontSize: 13 * screenW,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : Text(
                    _duration2String(_duration),
                    style: TextStyle(
                      color: const Color(0xffd9d9d9),
                      fontSize: 13 * screenW,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// 播放器底部 倍數按鈕
  Widget _buildBtmSpeedBtn() {
    return Positioned(
      right: 56 * screenW,
      bottom: 0,
      child: SizedBox(
        width: 56 * screenW,
        height: 36 * screenW,
        child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerRight),
          child: Text(
            _speed.toString() + " X",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14 * screenW,
            ),
          ),
          onPressed: () {
            setState(() {
              if (_isFullScreen) {
                _hideSpeedStu = !_hideSpeedStu;
              } else {
                for (var speedVals in speedList.values.toList().reversed) {
                  if (speedVals > _speed || _speed == 2.0) {
                    player.setSpeed(speedVals);
                    _speed = speed = speedVals;
                    break;
                  }
                }
              }
            });
          },
        ),
      ),
    );
  }

  /// 播放器底部 全屏按钮
  Widget _buildBtmFullScreenBtn() {
    String img = _isFullScreen
        ? 'assets/image/icon_player_fullscreen_exit.png'
        : 'assets/image/icon_player_fullscreen_fill.png';
    return Positioned(
      right: 0,
      bottom: 0,
      child: SizedBox(
        width: 56 * screenW,
        height: 36 * screenW,
        child: IconButton(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
          icon: Image.asset(
            img,
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ),
          onPressed: () {
            if (_isFullScreen) {
              _setPlayerFullScreen(false);
            } else {
              _setPlayerFullScreen(true);
              // 掉父组件回调
              widget.changeDrawerState(false);
            }
          },
        ),
      ),
    );
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

  void _setLockScreen(bool isLock) {
    widget.changeLockState(isLock);
  }

  /// 播放狀態改變
  void _playerValueChanged() async {
    FijkValue value = player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }
    // ignore: avoid_print
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    // ignore: avoid_print
    print('++++++++ 是否开始播放 => ${value.state == FijkState.started} ++++++++');
    // ignore: avoid_print
    print('+++++++++++++++++++ 播放器状态 => ${value.state} ++++++++++++++++++++');
    // ignore: avoid_print
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    // /// 如果是切換高標清或是播放源要跳回原本的進度
    await player.setOption(FijkOption.playerCategory, 'seek-at-start',
        _changeSourcePos.inMilliseconds);
    // if (value.state == FijkState.prepared && _currentPos != widget.sourceModel.position) {
    //   widget.player.seekTo(widget.sourceModel.position.inMilliseconds);
    // }

    // 新状态
    bool playing = value.state == FijkState.started;
    bool stopped = value.state == FijkState.stopped;
    bool prepared = value.prepared;
    String? exception = value.exception.message;
    // 状态不一致，修改
    if (playing != _playing ||
        prepared != _prepared ||
        exception != _exception) {
      setState(() {
        _playing = playing;
        _isStopped = stopped;
        _prepared = prepared;
        _exception = exception;
      });
    }
  }

  /// 切换播放源
  Future<void> changeCurPlayVideo() async {
    setState(() {
      _buffering = false;
    });
    player.reset().then((_) async {
      _speed = speed = 1.0;
      player.setSpeed(_speed);
      player.setDataSource(
        playerModel.playVideo,
        autoPlay: true,
      );
      // 回调
      widget.onChangeVideo!();
    });
  }

  /// 播放/暫停
  void _playOrPause() {
    if (_isStopped) {
      _changeSourcePos = _currentPos;
      changeCurPlayVideo();
    } else if (_playing) {
      player.pause();
    } else {
      player.start();
    }
  }

  /// bottom重新計時
  void _cancelAndRestartTimer() {
    if (_hideStuff) {
      _startHideTimer();
    }

    setState(() {
      _hideStuff = !_hideStuff;
      if (_hideStuff) {
        _hideSpeedStu = true;
      }
    });
  }

  /// bottom隱藏計時
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _hideStuff = true;
        _hideSpeedStu = true;
      });
    });
  }

  /// 快進30s
  void didClickNext30Btn() {
    player.pause();
    _startHideTimer();
    doubleTapSeekTime += nextOrBackTime;
    final toTime = doubleTapSeekTime > _duration.inMilliseconds
        ? _duration.inMilliseconds
        : doubleTapSeekTime;
    player.seekTo(toTime);

    player.start();
  }

  /// 快退30s
  void didClickBack30Btn() {
    player.pause();
    _startHideTimer();
    doubleTapSeekTime -= nextOrBackTime;
    final toTime = doubleTapSeekTime < 0 ? 0 : doubleTapSeekTime;
    player.seekTo(toTime);

    player.start();
  }

  /// 播放時長
  String _duration2String(Duration duration) {
    if (duration.inMilliseconds < 0) return "-: negtive";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    int inHours = duration.inHours;
    return inHours > 0
        ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }
}
