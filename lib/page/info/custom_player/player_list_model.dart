import 'package:flutter/widgets.dart';
import 'package:flutter_two_test/ad/ad_provider_manager.dart';
import 'package:json_annotation/json_annotation.dart';

enum areaType {
  @JsonValue('東部')
  east,
  @JsonValue('南部')
  south,
  @JsonValue('中部')
  west,
  @JsonValue('北部')
  north,
}

class PlayerInfoModel {
  final List<String> videoList;
  final String listName;

  PlayerInfoModel(this.videoList, this.listName);
}

class PlayerListModel with ChangeNotifier {

  List<PlayerInfoModel> allPlayerList = [];
  PlayerInfoModel playerList = PlayerInfoModel([], '');
  List<String> randomList = [];
  String playVideo = '';
  int playIndex = 0;
  bool prepareShowAd = AdProviderManager.instance.showRewardedPlayerAd();

  get selectListName => '${playerList.listName}${playIndex + 1}';

  void setPlayerList(int index, String playUrl) {
    prepareShowAd = false;
    allPlayerList = [northVideo, westVideo, southVideo, eastVideo];
    playerList = allPlayerList[index];

    for (var i = 0; i < playerList.videoList.length; i++) {
      if (playerList.videoList[i] == playUrl) {
        playIndex = i;
        break;
      }
    }

    playVideo = playUrl;
    notifyListeners();
  }

  void changeNextVideo({int? index}) {
    playIndex = index ?? playIndex + 1;
    playVideo = playerList.videoList[playIndex];
    notifyListeners();
  }

  void changeOtherVideo({int? listIndex, int? videoIndex}) {
    if (listIndex != null) {
      playerList = allPlayerList[listIndex];
    }
    playIndex = videoIndex ?? playIndex + 1;
    playVideo = playerList.videoList[playIndex];
    notifyListeners();
  }

  List<String> randomVideoList() {
    if (randomList.isNotEmpty) { return randomList; }
    allPlayerList = [northVideo, westVideo, southVideo, eastVideo];
    final tempList = allPlayerList.map((e) {
      e.videoList.shuffle();
      return e.videoList.first;
    }).toList();
    randomList = tempList;
    return randomList;
  }

  PlayerInfoModel northVideo = PlayerInfoModel([
    'https://player.vimeo.com/external/582839714.sd.mp4?s=03e9ba94fdcf85b80d8cac90e6f3cc0a502b8b2b&profile_id=164&oauth2_token_id=57447761',
    'https://player.vimeo.com/external/646926076.sd.mp4?s=c690a848af0478e64bbf39cab249669443651c8d&profile_id=164&oauth_token_id=57447761',
    'https://media.istockphoto.com/videos/aerial-landscape-of-tea-plantations-landscape-in-taipei-taiwan-video-id947128374',
    'https://media.istockphoto.com/videos/3d-terrain-map-night-taiwan-video-id1348327825',
    'https://media.istockphoto.com/videos/tourist-and-restaurant-at-jiufen-old-street-taiwan-video-id1318633576',
  ], '北部');

  PlayerInfoModel westVideo = PlayerInfoModel([
    'https://player.vimeo.com/external/573356708.sd.mp4?s=950c020c35cc8505248c662e657884435cd98c16&profile_id=164&oauth2_token_id=57447761',
    'https://player.vimeo.com/external/548281954.sd.mp4?s=d71af7f21bfac7857ae0623228a85e3b05eabc64&profile_id=164&oauth2_token_id=57447761',
    'https://player.vimeo.com/progressive_redirect/playback/683677968/rendition/360p?loc=external&oauth2_token_id=57447761&signature=9e62c20fc443c9008f464aae95396c1dac5106f2c1e4071edb972a3165bf9cef',
    'https://media.istockphoto.com/videos/coastline-of-central-taiwan-video-id1207181903',
    'https://media.istockphoto.com/videos/taichung-taiwan-video-id845873640',
  ], '中部');

  PlayerInfoModel southVideo = PlayerInfoModel([
    'https://player.vimeo.com/external/594283447.sd.mp4?s=5908be7d0b6310a81562d0744c96ce72d9ea41df&profile_id=164&oauth2_token_id=57447761',
    'https://player.vimeo.com/external/548227127.sd.mp4?s=84e92e93767c54121516bcd71bdcb5ea89b8b8ce&profile_id=164&oauth2_token_id=57447761',
    'https://media.istockphoto.com/videos/aerial-view-of-beautiful-terraced-rice-field-and-road-taitung-taiwan-video-id1328774374',
    'https://media.istockphoto.com/videos/the-tea-farmers-are-wearing-hats-harvesting-tea-leaves-video-id1299087145',
    'https://media.istockphoto.com/videos/aerial-view-of-daylily-in-mountain-video-id614577772',
    'https://media.istockphoto.com/videos/hddragon-dance-video-id186784043',
  ], '南部');

  PlayerInfoModel eastVideo = PlayerInfoModel([
    'https://player.vimeo.com/external/548227127.sd.mp4?s=84e92e93767c54121516bcd71bdcb5ea89b8b8ce&profile_id=164&oauth2_token_id=57447761',
    'https://player.vimeo.com/external/555107906.sd.mp4?s=e8c8d6458b91620efabfcbebdaa2fcb9f29d7445&profile_id=164&oauth2_token_id=57447761',
    'https://media.istockphoto.com/videos/mountain-area-and-seascape-video-id1213812528',
    'https://media.istockphoto.com/videos/4k-aerial-footage-of-nanya-rock-jioufentaiwan-video-id1197129043',
    'https://media.istockphoto.com/videos/school-of-glass-fish-in-coral-reef-video-id614549016',
    'https://media.istockphoto.com/videos/sunlight-rays-of-sun-moon-lake-nantou-taiwan-video-id929421626',
    'https://media.istockphoto.com/videos/4k-aerial-footage-of-sun-moon-laketaiwan-video-id1204111448',
  ], '東部');
}
