import 'package:flutter_two_test/generated/json/base/json_convert_content.dart';
import 'package:flutter_two_test/entity/json_bean_factory_test_entity.dart';

JsonBeanFactoryTestEntity $JsonBeanFactoryTestEntityFromJson(Map<String, dynamic> json) {
	final JsonBeanFactoryTestEntity jsonBeanFactoryTestEntity = JsonBeanFactoryTestEntity();
	final JsonBeanFactoryTestXmlHead? xmlHead = jsonConvert.convert<JsonBeanFactoryTestXmlHead>(json['XML_Head']);
	if (xmlHead != null) {
		jsonBeanFactoryTestEntity.xmlHead = xmlHead;
	}
	return jsonBeanFactoryTestEntity;
}

Map<String, dynamic> $JsonBeanFactoryTestEntityToJson(JsonBeanFactoryTestEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['XML_Head'] = entity.xmlHead.toJson();
	return data;
}

JsonBeanFactoryTestXmlHead $JsonBeanFactoryTestXmlHeadFromJson(Map<String, dynamic> json) {
	final JsonBeanFactoryTestXmlHead jsonBeanFactoryTestXmlHead = JsonBeanFactoryTestXmlHead();
	final String? listname = jsonConvert.convert<String>(json['Listname']);
	if (listname != null) {
		jsonBeanFactoryTestXmlHead.listname = listname;
	}
	final String? language = jsonConvert.convert<String>(json['Language']);
	if (language != null) {
		jsonBeanFactoryTestXmlHead.language = language;
	}
	final String? orgname = jsonConvert.convert<String>(json['Orgname']);
	if (orgname != null) {
		jsonBeanFactoryTestXmlHead.orgname = orgname;
	}
	final String? updatetime = jsonConvert.convert<String>(json['Updatetime']);
	if (updatetime != null) {
		jsonBeanFactoryTestXmlHead.updatetime = updatetime;
	}
	final JsonBeanFactoryTestXmlHeadInfos? infos = jsonConvert.convert<JsonBeanFactoryTestXmlHeadInfos>(json['Infos']);
	if (infos != null) {
		jsonBeanFactoryTestXmlHead.infos = infos;
	}
	return jsonBeanFactoryTestXmlHead;
}

Map<String, dynamic> $JsonBeanFactoryTestXmlHeadToJson(JsonBeanFactoryTestXmlHead entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Listname'] = entity.listname;
	data['Language'] = entity.language;
	data['Orgname'] = entity.orgname;
	data['Updatetime'] = entity.updatetime;
	data['Infos'] = entity.infos.toJson();
	return data;
}

JsonBeanFactoryTestXmlHeadInfos $JsonBeanFactoryTestXmlHeadInfosFromJson(Map<String, dynamic> json) {
	final JsonBeanFactoryTestXmlHeadInfos jsonBeanFactoryTestXmlHeadInfos = JsonBeanFactoryTestXmlHeadInfos();
	final List<JsonBeanFactoryTestXmlHeadInfosInfo>? info = jsonConvert.convertListNotNull<JsonBeanFactoryTestXmlHeadInfosInfo>(json['Info']);
	if (info != null) {
		jsonBeanFactoryTestXmlHeadInfos.info = info;
	}
	return jsonBeanFactoryTestXmlHeadInfos;
}

Map<String, dynamic> $JsonBeanFactoryTestXmlHeadInfosToJson(JsonBeanFactoryTestXmlHeadInfos entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Info'] =  entity.info.map((v) => v.toJson()).toList();
	return data;
}

JsonBeanFactoryTestXmlHeadInfosInfo $JsonBeanFactoryTestXmlHeadInfosInfoFromJson(Map<String, dynamic> json) {
	final JsonBeanFactoryTestXmlHeadInfosInfo jsonBeanFactoryTestXmlHeadInfosInfo = JsonBeanFactoryTestXmlHeadInfosInfo();
	final String? id = jsonConvert.convert<String>(json['Id']);
	if (id != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['Name']);
	if (name != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.name = name;
	}
	final String? zone = jsonConvert.convert<String>(json['Zone']);
	if (zone != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.zone = zone;
	}
	final String? toldescribe = jsonConvert.convert<String>(json['Toldescribe']);
	if (toldescribe != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.toldescribe = toldescribe;
	}
	final String? description = jsonConvert.convert<String>(json['Description']);
	if (description != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.description = description;
	}
	final String? tel = jsonConvert.convert<String>(json['Tel']);
	if (tel != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.tel = tel;
	}
	final String? add = jsonConvert.convert<String>(json['Add']);
	if (add != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.add = add;
	}
	final String? zipcode = jsonConvert.convert<String>(json['Zipcode']);
	if (zipcode != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.zipcode = zipcode;
	}
	final String? region = jsonConvert.convert<String>(json['Region']);
	if (region != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.region = region;
	}
	final String? town = jsonConvert.convert<String>(json['Town']);
	if (town != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.town = town;
	}
	final String? travellinginfo = jsonConvert.convert<String>(json['Travellinginfo']);
	if (travellinginfo != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.travellinginfo = travellinginfo;
	}
	final String? opentime = jsonConvert.convert<String>(json['Opentime']);
	if (opentime != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.opentime = opentime;
	}
	final String? picture1 = jsonConvert.convert<String>(json['Picture1']);
	if (picture1 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.picture1 = picture1;
	}
	final String? picdescribe1 = jsonConvert.convert<String>(json['Picdescribe1']);
	if (picdescribe1 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.picdescribe1 = picdescribe1;
	}
	final String? picture2 = jsonConvert.convert<String>(json['Picture2']);
	if (picture2 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.picture2 = picture2;
	}
	final String? picdescribe2 = jsonConvert.convert<String>(json['Picdescribe2']);
	if (picdescribe2 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.picdescribe2 = picdescribe2;
	}
	final String? picture3 = jsonConvert.convert<String>(json['Picture3']);
	if (picture3 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.picture3 = picture3;
	}
	final String? picdescribe3 = jsonConvert.convert<String>(json['Picdescribe3']);
	if (picdescribe3 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.picdescribe3 = picdescribe3;
	}
	final String? map = jsonConvert.convert<String>(json['Map']);
	if (map != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.map = map;
	}
	final String? gov = jsonConvert.convert<String>(json['Gov']);
	if (gov != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.gov = gov;
	}
	final double? px = jsonConvert.convert<double>(json['Px']);
	if (px != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.px = px;
	}
	final double? py = jsonConvert.convert<double>(json['Py']);
	if (py != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.py = py;
	}
	final String? orgclass = jsonConvert.convert<String>(json['Orgclass']);
	if (orgclass != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.orgclass = orgclass;
	}
	final String? class1 = jsonConvert.convert<String>(json['Class1']);
	if (class1 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.class1 = class1;
	}
	final String? class2 = jsonConvert.convert<String>(json['Class2']);
	if (class2 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.class2 = class2;
	}
	final String? class3 = jsonConvert.convert<String>(json['Class3']);
	if (class3 != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.class3 = class3;
	}
	final String? level = jsonConvert.convert<String>(json['Level']);
	if (level != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.level = level;
	}
	final String? website = jsonConvert.convert<String>(json['Website']);
	if (website != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.website = website;
	}
	final String? parkinginfo = jsonConvert.convert<String>(json['Parkinginfo']);
	if (parkinginfo != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.parkinginfo = parkinginfo;
	}
	final double? parkinginfoPx = jsonConvert.convert<double>(json['Parkinginfo_Px']);
	if (parkinginfoPx != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.parkinginfoPx = parkinginfoPx;
	}
	final double? parkinginfoPy = jsonConvert.convert<double>(json['Parkinginfo_Py']);
	if (parkinginfoPy != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.parkinginfoPy = parkinginfoPy;
	}
	final String? ticketinfo = jsonConvert.convert<String>(json['Ticketinfo']);
	if (ticketinfo != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.ticketinfo = ticketinfo;
	}
	final String? remarks = jsonConvert.convert<String>(json['Remarks']);
	if (remarks != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.remarks = remarks;
	}
	final String? keyword = jsonConvert.convert<String>(json['Keyword']);
	if (keyword != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.keyword = keyword;
	}
	final String? changetime = jsonConvert.convert<String>(json['Changetime']);
	if (changetime != null) {
		jsonBeanFactoryTestXmlHeadInfosInfo.changetime = changetime;
	}
	return jsonBeanFactoryTestXmlHeadInfosInfo;
}

Map<String, dynamic> $JsonBeanFactoryTestXmlHeadInfosInfoToJson(JsonBeanFactoryTestXmlHeadInfosInfo entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Id'] = entity.id;
	data['Name'] = entity.name;
	data['Zone'] = entity.zone;
	data['Toldescribe'] = entity.toldescribe;
	data['Description'] = entity.description;
	data['Tel'] = entity.tel;
	data['Add'] = entity.add;
	data['Zipcode'] = entity.zipcode;
	data['Region'] = entity.region;
	data['Town'] = entity.town;
	data['Travellinginfo'] = entity.travellinginfo;
	data['Opentime'] = entity.opentime;
	data['Picture1'] = entity.picture1;
	data['Picdescribe1'] = entity.picdescribe1;
	data['Picture2'] = entity.picture2;
	data['Picdescribe2'] = entity.picdescribe2;
	data['Picture3'] = entity.picture3;
	data['Picdescribe3'] = entity.picdescribe3;
	data['Map'] = entity.map;
	data['Gov'] = entity.gov;
	data['Px'] = entity.px;
	data['Py'] = entity.py;
	data['Orgclass'] = entity.orgclass;
	data['Class1'] = entity.class1;
	data['Class2'] = entity.class2;
	data['Class3'] = entity.class3;
	data['Level'] = entity.level;
	data['Website'] = entity.website;
	data['Parkinginfo'] = entity.parkinginfo;
	data['Parkinginfo_Px'] = entity.parkinginfoPx;
	data['Parkinginfo_Py'] = entity.parkinginfoPy;
	data['Ticketinfo'] = entity.ticketinfo;
	data['Remarks'] = entity.remarks;
	data['Keyword'] = entity.keyword;
	data['Changetime'] = entity.changetime;
	return data;
}