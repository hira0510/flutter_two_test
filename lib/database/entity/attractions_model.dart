import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'attractions_model.g.dart';
/// 第一次新建資料時 請於Terminal 執行指令 「 flutter packages pub run build_runner build 」
/// 當資料有更新時 請於Terminal 執行指令   「 flutter packages pub run build_runner watch 」

@JsonSerializable()
class AttractionsModel {

  AttractionsModel();
  @JsonKey(name: "XML_Head")
  AttractionsHead? head;

  factory AttractionsModel.fromJson(Map<String, dynamic> json) => _$AttractionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttractionsModelToJson(this);
}

@JsonSerializable()
class AttractionsHead {

  AttractionsHead();

  @JsonKey(name: 'Infos')
  AttractionsInfoArray? infos;

  factory AttractionsHead.fromJson(Map<String, dynamic> json) => _$AttractionsHeadFromJson(json);

  Map<String, dynamic> toJson() => _$AttractionsHeadToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AttractionsInfoArray {

  AttractionsInfoArray();

  @JsonKey(name: 'Info')
  List<AttractionsInfo>? info;

  factory AttractionsInfoArray.fromJson(Map<String, dynamic> json) => _$AttractionsInfoArrayFromJson(json);

  Map<String, dynamic> toJson() => _$AttractionsInfoArrayToJson(this);
}

@JsonSerializable()
class AttractionsInfo {

  AttractionsInfo();

  @JsonKey(name: 'Id', defaultValue: '')
  late String id;
  @JsonKey(name: 'Name', defaultValue: '')
  late String name;
  @JsonKey(name: 'Tel', defaultValue: '')
  late String tel;
  @JsonKey(name: 'Add', defaultValue: '')
  late String add;
  @JsonKey(name: 'Description', defaultValue: '')
  late String description;
  @JsonKey(name: 'Picture1', defaultValue: '')
  late String image1;
  @JsonKey(name: 'Picture2', defaultValue: '')
  late String image2;
  @JsonKey(name: 'Picture3', defaultValue: '')
  late String image3;
  @JsonKey(name: 'Opentime', defaultValue: '')
  late String openTime;
  @JsonKey(name: 'Parkinginfo', defaultValue: '')
  late String parkingInfo;
  @JsonKey(name: 'Website', defaultValue: '')
  late String website;
  @JsonKey(name: 'Px', defaultValue: 0)
  late double px;
  @JsonKey(name: 'Py', defaultValue: 0)
  late double py;

  factory AttractionsInfo.fromJson(Map<String, dynamic> json) => _$AttractionsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AttractionsInfoToJson(this);
}