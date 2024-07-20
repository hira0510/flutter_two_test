
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/attractions_dao.dart';
import 'entity/attractions_db_entity.dart';
part 'database.g.dart'; // the generated code will be there

/// 第一次新建資料時 請於Terminal 執行指令 「 flutter packages pub run build_runner build 」
/// 當資料有更新時 請於Terminal 執行指令   「 flutter packages pub run build_runner watch 」
@Database(version: 1, entities: [AttractionsDbEntity])
abstract class DBManager extends FloorDatabase{
  AttractionsDao get getAttractionsDao;
}
