import 'package:floor/floor.dart';

@Entity(tableName:'ATTEACTIONS')
class AttractionsDbEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String sid;
  String name;
  String tel;
  String add;
  String description;
  String image1;
  String image2;
  String image3;
  String openTime;
  String parkingInfo;
  String website;
  double px;
  double py;

  AttractionsDbEntity(
      {this.id,
        required this.sid,
        required this.name,
        required this.tel,
        required this.add,
        required this.description,
        required this.image1,
        required this.image2,
        required this.image3,
        required this.openTime,
        required this.parkingInfo,
        required this.website,
        required this.px,
        required this.py,});
}