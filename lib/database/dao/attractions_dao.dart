import 'package:floor/floor.dart';
import 'package:flutter_two_test/database/entity/attractions_db_entity.dart';

@dao
abstract class AttractionsDao {
  @Query('SELECT * FROM ATTEACTIONS WHERE sid = :sid')
  Future<AttractionsDbEntity?> findDataBySid(String sid);

  @Query('SELECT * FROM ATTEACTIONS')
  Future<List<AttractionsDbEntity>> findAllData();

  @Query('DELETE FROM ATTEACTIONS')
  Future<void> deleteAllData();

  @insert
  Future<void> insertData(AttractionsDbEntity video);

  @update
  Future<void> updateData(AttractionsDbEntity video);

  @delete
  Future<void> deleteData(AttractionsDbEntity video);
}