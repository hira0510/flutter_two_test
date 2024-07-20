import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_two_test/page/info/custom_player/player_list_model.dart';
import 'package:provider/provider.dart';

import 'fijkplayer_skin.dart';

class CustomVideoPlayer extends StatefulWidget {
  CustomVideoPlayer(this.playerModel, this.videoListener, {Key? key}) : super(key: key);
  final PlayerListModel playerModel;
  final FijkPlayer player = FijkPlayer();
  final Function(FijkValue value)? videoListener;
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late String _dataSource;

  @override
  void initState() {
    super.initState();
    speed = 1.0;
    widget.player.addListener(() {
      if(widget.videoListener!=null){
        widget.videoListener!(widget.player.value);
      }
    });
    _dataSource = widget.playerModel.playVideo;
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
    widget.player.release();
    widget.player.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(
        value: widget.playerModel,
      )
    ], child: _buildFullScreenModel());
  }

  Widget _buildFullScreenModel() {
    var screenW = MediaQuery.of(context).size.width;
    return RotatedBox(
      quarterTurns: 0,
      child: Container(
        width: screenW,
        height: 202 * screenW / 340,
        color: Colors.black,
        child: _buildSourceModel(),
      ),
    );
  }

  Widget _buildSourceModel() {
    return Consumer<PlayerListModel>(
        builder: (BuildContext _context, PlayerListModel model, Widget? child) {
          if (model.playVideo != _dataSource) {
            _dataSource = model.playVideo;
            widget.player.setDataSource(_dataSource, autoPlay: true);
          }
          if (model.playVideo.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                  const Text(
                    "No Sourse",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            );
          }
          return Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: _buildVideoPlayer());
        });
  }

  Widget _buildVideoPlayer() {
    return Consumer<PlayerListModel>(
        builder: (BuildContext _context, PlayerListModel model, Widget? child) {
          return Stack(
            children: [
              FijkView(
                player: widget.player,
                color: Colors.black,
                panelBuilder: (FijkPlayer player, FijkData data,
                    BuildContext context, Size viewSize, Rect texturePos) {
                  //設定軟體加速音頻 不然調整倍速時會因音頻無法加速而調整失敗
                  player.setOption(FijkOption.playerCategory, "soundtouch", 1);
                  /// 使用自定义的布局
                  return CustomFijkPanel(
                    player: player,
                    pageContent: context,
                    viewSize: viewSize,
                    // 标题
                    playerTitle: "",
                    //m3u8Model
                    playerModel: model,
                  );
                },
              ),
              _buildTopBackBtn(),
            ],
          );
        });
  }

  /// 返回按钮
  Widget _buildTopBackBtn() {
    var screenW = MediaQuery.of(context).size.width / 375;
    var safeLeft = MediaQuery.of(context).padding.left;
    return Positioned(
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
          widget.player.stop();
          Navigator.pop(context);
        },
      ),
    );
  }
}
