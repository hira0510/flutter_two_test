import 'package:flutter_two_test/generated/json/base/json_convert_content.dart';
import 'package:flutter_two_test/database/entity/attractions_model.dart';
import 'package:json_annotation/json_annotation.dart';


AttractionsModel $AttractionsModelFromJson(Map<String, dynamic> json) {
	final AttractionsModel attractionsModel = AttractionsModel();
	final AttractionsHead? head = jsonConvert.convert<AttractionsHead>(json['head']);
	if (head != null) {
		attractionsModel.head = head;
	}
	return attractionsModel;
}

Map<String, dynamic> $AttractionsModelToJson(AttractionsModel entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['head'] = entity.head?.toJson();
	return data;
}

AttractionsHead $AttractionsHeadFromJson(Map<String, dynamic> json) {
	final AttractionsHead attractionsHead = AttractionsHead();
	final AttractionsInfoArray? infos = jsonConvert.convert<AttractionsInfoArray>(json['infos']);
	if (infos != null) {
		attractionsHead.infos = infos;
	}
	return attractionsHead;
}

Map<String, dynamic> $AttractionsHeadToJson(AttractionsHead entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['infos'] = entity.infos?.toJson();
	return data;
}

AttractionsInfoArray $AttractionsInfoArrayFromJson(Map<String, dynamic> json) {
	final AttractionsInfoArray attractionsInfoArray = AttractionsInfoArray();
	final List<AttractionsInfo>? info = jsonConvert.convertListNotNull<AttractionsInfo>(json['info']);
	if (info != null) {
		attractionsInfoArray.info = info;
	}
	return attractionsInfoArray;
}

Map<String, dynamic> $AttractionsInfoArrayToJson(AttractionsInfoArray entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['info'] =  entity.info?.map((v) => v.toJson()).toList();
	return data;
}

AttractionsInfo $AttractionsInfoFromJson(Map<String, dynamic> json) {
	final AttractionsInfo attractionsInfo = AttractionsInfo();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		attractionsInfo.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		attractionsInfo.name = name;
	}
	final String? tel = jsonConvert.convert<String>(json['tel']);
	if (tel != null) {
		attractionsInfo.tel = tel;
	}
	final String? add = jsonConvert.convert<String>(json['add']);
	if (add != null) {
		attractionsInfo.add = add;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		attractionsInfo.description = description;
	}
	final String? image1 = jsonConvert.convert<String>(json['image1']);
	if (image1 != null) {
		attractionsInfo.image1 = image1;
	}
	final String? image2 = jsonConvert.convert<String>(json['image2']);
	if (image2 != null) {
		attractionsInfo.image2 = image2;
	}
	final String? image3 = jsonConvert.convert<String>(json['image3']);
	if (image3 != null) {
		attractionsInfo.image3 = image3;
	}
	final String? openTime = jsonConvert.convert<String>(json['openTime']);
	if (openTime != null) {
		attractionsInfo.openTime = openTime;
	}
	final String? parkingInfo = jsonConvert.convert<String>(json['parkingInfo']);
	if (parkingInfo != null) {
		attractionsInfo.parkingInfo = parkingInfo;
	}
	final String? website = jsonConvert.convert<String>(json['website']);
	if (website != null) {
		attractionsInfo.website = website;
	}
	final double? px = jsonConvert.convert<double>(json['px']);
	if (px != null) {
		attractionsInfo.px = px;
	}
	final double? py = jsonConvert.convert<double>(json['py']);
	if (py != null) {
		attractionsInfo.py = py;
	}
	return attractionsInfo;
}

Map<String, dynamic> $AttractionsInfoToJson(AttractionsInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['tel'] = entity.tel;
	data['add'] = entity.add;
	data['description'] = entity.description;
	data['image1'] = entity.image1;
	data['image2'] = entity.image2;
	data['image3'] = entity.image3;
	data['openTime'] = entity.openTime;
	data['parkingInfo'] = entity.parkingInfo;
	data['website'] = entity.website;
	data['px'] = entity.px;
	data['py'] = entity.py;
	return data;
}