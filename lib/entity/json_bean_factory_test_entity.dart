import 'dart:convert';
import 'package:flutter_two_test/generated/json/base/json_field.dart';
import 'package:flutter_two_test/generated/json/json_bean_factory_test_entity.g.dart';

@JsonSerializable()
class JsonBeanFactoryTestEntity {

	@JSONField(name: "XML_Head")
	late JsonBeanFactoryTestXmlHead xmlHead;
  
  JsonBeanFactoryTestEntity();

  factory JsonBeanFactoryTestEntity.fromJson(Map<String, dynamic> json) => $JsonBeanFactoryTestEntityFromJson(json);

  Map<String, dynamic> toJson() => $JsonBeanFactoryTestEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class JsonBeanFactoryTestXmlHead {

	@JSONField(name: "Listname")
	late String listname;
	@JSONField(name: "Language")
	late String language;
	@JSONField(name: "Orgname")
	late String orgname;
	@JSONField(name: "Updatetime")
	late String updatetime;
	@JSONField(name: "Infos")
	late JsonBeanFactoryTestXmlHeadInfos infos;
  
  JsonBeanFactoryTestXmlHead();

  factory JsonBeanFactoryTestXmlHead.fromJson(Map<String, dynamic> json) => $JsonBeanFactoryTestXmlHeadFromJson(json);

  Map<String, dynamic> toJson() => $JsonBeanFactoryTestXmlHeadToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class JsonBeanFactoryTestXmlHeadInfos {

	@JSONField(name: "Info")
	late List<JsonBeanFactoryTestXmlHeadInfosInfo> info;
  
  JsonBeanFactoryTestXmlHeadInfos();

  factory JsonBeanFactoryTestXmlHeadInfos.fromJson(Map<String, dynamic> json) => $JsonBeanFactoryTestXmlHeadInfosFromJson(json);

  Map<String, dynamic> toJson() => $JsonBeanFactoryTestXmlHeadInfosToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class JsonBeanFactoryTestXmlHeadInfosInfo {

	@JSONField(name: "Id")
	late String id;
	@JSONField(name: "Name")
	late String name;
	@JSONField(name: "Zone")
	late String zone;
	@JSONField(name: "Toldescribe")
	late String toldescribe;
	@JSONField(name: "Description")
	late String description;
	@JSONField(name: "Tel")
	late String tel;
	@JSONField(name: "Add")
	late String add;
	@JSONField(name: "Zipcode")
	late String zipcode;
	@JSONField(name: "Region")
	late String region;
	@JSONField(name: "Town")
	late String town;
	@JSONField(name: "Travellinginfo")
	late String travellinginfo;
	@JSONField(name: "Opentime")
	late String opentime;
	@JSONField(name: "Picture1")
	late String picture1;
	@JSONField(name: "Picdescribe1")
	late String picdescribe1;
	@JSONField(name: "Picture2")
	late String picture2;
	@JSONField(name: "Picdescribe2")
	late String picdescribe2;
	@JSONField(name: "Picture3")
	late String picture3;
	@JSONField(name: "Picdescribe3")
	late String picdescribe3;
	@JSONField(name: "Map")
	late String map;
	@JSONField(name: "Gov")
	late String gov;
	@JSONField(name: "Px")
	late double px;
	@JSONField(name: "Py")
	late double py;
	@JSONField(name: "Orgclass")
	late String orgclass;
	@JSONField(name: "Class1")
	late String class1;
	@JSONField(name: "Class2")
	late String class2;
	@JSONField(name: "Class3")
	late String class3;
	@JSONField(name: "Level")
	late String level;
	@JSONField(name: "Website")
	late String website;
	@JSONField(name: "Parkinginfo")
	late String parkinginfo;
	@JSONField(name: "Parkinginfo_Px")
	late double parkinginfoPx;
	@JSONField(name: "Parkinginfo_Py")
	late double parkinginfoPy;
	@JSONField(name: "Ticketinfo")
	late String ticketinfo;
	@JSONField(name: "Remarks")
	late String remarks;
	@JSONField(name: "Keyword")
	late String keyword;
	@JSONField(name: "Changetime")
	late String changetime;
  
  JsonBeanFactoryTestXmlHeadInfosInfo();

  factory JsonBeanFactoryTestXmlHeadInfosInfo.fromJson(Map<String, dynamic> json) => $JsonBeanFactoryTestXmlHeadInfosInfoFromJson(json);

  Map<String, dynamic> toJson() => $JsonBeanFactoryTestXmlHeadInfosInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}