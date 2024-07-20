// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attractions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttractionsModel _$AttractionsModelFromJson(Map<String, dynamic> json) =>
    AttractionsModel()
      ..head = json['XML_Head'] == null
          ? null
          : AttractionsHead.fromJson(json['XML_Head'] as Map<String, dynamic>);

Map<String, dynamic> _$AttractionsModelToJson(AttractionsModel instance) =>
    <String, dynamic>{
      'XML_Head': instance.head,
    };

AttractionsHead _$AttractionsHeadFromJson(Map<String, dynamic> json) =>
    AttractionsHead()
      ..infos = json['Infos'] == null
          ? null
          : AttractionsInfoArray.fromJson(
              json['Infos'] as Map<String, dynamic>);

Map<String, dynamic> _$AttractionsHeadToJson(AttractionsHead instance) =>
    <String, dynamic>{
      'Infos': instance.infos,
    };

AttractionsInfoArray _$AttractionsInfoArrayFromJson(
        Map<String, dynamic> json) =>
    AttractionsInfoArray()
      ..info = (json['Info'] as List<dynamic>?)
          ?.map((e) => AttractionsInfo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$AttractionsInfoArrayToJson(
        AttractionsInfoArray instance) =>
    <String, dynamic>{
      'Info': instance.info,
    };

AttractionsInfo _$AttractionsInfoFromJson(Map<String, dynamic> json) =>
    AttractionsInfo()
      ..id = json['Id'] as String? ?? ''
      ..name = json['Name'] as String? ?? ''
      ..tel = json['Tel'] as String? ?? ''
      ..add = json['Add'] as String? ?? ''
      ..description = json['Description'] as String? ?? ''
      ..image1 = json['Picture1'] as String? ?? ''
      ..image2 = json['Picture2'] as String? ?? ''
      ..image3 = json['Picture3'] as String? ?? ''
      ..openTime = json['Opentime'] as String? ?? ''
      ..parkingInfo = json['Parkinginfo'] as String? ?? ''
      ..website = json['Website'] as String? ?? ''
      ..px = (json['Px'] as num?)?.toDouble() ?? 0
      ..py = (json['Py'] as num?)?.toDouble() ?? 0;

Map<String, dynamic> _$AttractionsInfoToJson(AttractionsInfo instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Tel': instance.tel,
      'Add': instance.add,
      'Description': instance.description,
      'Picture1': instance.image1,
      'Picture2': instance.image2,
      'Picture3': instance.image3,
      'Opentime': instance.openTime,
      'Parkinginfo': instance.parkingInfo,
      'Website': instance.website,
      'Px': instance.px,
      'Py': instance.py,
    };
