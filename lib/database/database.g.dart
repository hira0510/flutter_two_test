// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorDBManager {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DBManagerBuilder databaseBuilder(String name) =>
      _$DBManagerBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DBManagerBuilder inMemoryDatabaseBuilder() =>
      _$DBManagerBuilder(null);
}

class _$DBManagerBuilder {
  _$DBManagerBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DBManagerBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DBManagerBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DBManager> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DBManager();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DBManager extends DBManager {
  _$DBManager([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AttractionsDao? _getAttractionsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ATTEACTIONS` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sid` TEXT NOT NULL, `name` TEXT NOT NULL, `tel` TEXT NOT NULL, `add` TEXT NOT NULL, `description` TEXT NOT NULL, `image1` TEXT NOT NULL, `image2` TEXT NOT NULL, `image3` TEXT NOT NULL, `openTime` TEXT NOT NULL, `parkingInfo` TEXT NOT NULL, `website` TEXT NOT NULL, `px` REAL NOT NULL, `py` REAL NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AttractionsDao get getAttractionsDao {
    return _getAttractionsDaoInstance ??=
        _$AttractionsDao(database, changeListener);
  }
}

class _$AttractionsDao extends AttractionsDao {
  _$AttractionsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _attractionsDbEntityInsertionAdapter = InsertionAdapter(
            database,
            'ATTEACTIONS',
            (AttractionsDbEntity item) => <String, Object?>{
                  'id': item.id,
                  'sid': item.sid,
                  'name': item.name,
                  'tel': item.tel,
                  'add': item.add,
                  'description': item.description,
                  'image1': item.image1,
                  'image2': item.image2,
                  'image3': item.image3,
                  'openTime': item.openTime,
                  'parkingInfo': item.parkingInfo,
                  'website': item.website,
                  'px': item.px,
                  'py': item.py
                }),
        _attractionsDbEntityUpdateAdapter = UpdateAdapter(
            database,
            'ATTEACTIONS',
            ['id'],
            (AttractionsDbEntity item) => <String, Object?>{
                  'id': item.id,
                  'sid': item.sid,
                  'name': item.name,
                  'tel': item.tel,
                  'add': item.add,
                  'description': item.description,
                  'image1': item.image1,
                  'image2': item.image2,
                  'image3': item.image3,
                  'openTime': item.openTime,
                  'parkingInfo': item.parkingInfo,
                  'website': item.website,
                  'px': item.px,
                  'py': item.py
                }),
        _attractionsDbEntityDeletionAdapter = DeletionAdapter(
            database,
            'ATTEACTIONS',
            ['id'],
            (AttractionsDbEntity item) => <String, Object?>{
                  'id': item.id,
                  'sid': item.sid,
                  'name': item.name,
                  'tel': item.tel,
                  'add': item.add,
                  'description': item.description,
                  'image1': item.image1,
                  'image2': item.image2,
                  'image3': item.image3,
                  'openTime': item.openTime,
                  'parkingInfo': item.parkingInfo,
                  'website': item.website,
                  'px': item.px,
                  'py': item.py
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttractionsDbEntity>
      _attractionsDbEntityInsertionAdapter;

  final UpdateAdapter<AttractionsDbEntity> _attractionsDbEntityUpdateAdapter;

  final DeletionAdapter<AttractionsDbEntity>
      _attractionsDbEntityDeletionAdapter;

  @override
  Future<AttractionsDbEntity?> findDataBySid(String sid) async {
    return _queryAdapter.query('SELECT * FROM ATTEACTIONS WHERE sid = ?1',
        mapper: (Map<String, Object?> row) => AttractionsDbEntity(
            id: row['id'] as int?,
            sid: row['sid'] as String,
            name: row['name'] as String,
            tel: row['tel'] as String,
            add: row['add'] as String,
            description: row['description'] as String,
            image1: row['image1'] as String,
            image2: row['image2'] as String,
            image3: row['image3'] as String,
            openTime: row['openTime'] as String,
            parkingInfo: row['parkingInfo'] as String,
            website: row['website'] as String,
            px: row['px'] as double,
            py: row['py'] as double),
        arguments: [sid]);
  }

  @override
  Future<List<AttractionsDbEntity>> findAllData() async {
    return _queryAdapter.queryList('SELECT * FROM ATTEACTIONS',
        mapper: (Map<String, Object?> row) => AttractionsDbEntity(
            id: row['id'] as int?,
            sid: row['sid'] as String,
            name: row['name'] as String,
            tel: row['tel'] as String,
            add: row['add'] as String,
            description: row['description'] as String,
            image1: row['image1'] as String,
            image2: row['image2'] as String,
            image3: row['image3'] as String,
            openTime: row['openTime'] as String,
            parkingInfo: row['parkingInfo'] as String,
            website: row['website'] as String,
            px: row['px'] as double,
            py: row['py'] as double));
  }

  @override
  Future<void> deleteAllData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ATTEACTIONS');
  }

  @override
  Future<void> insertData(AttractionsDbEntity video) async {
    await _attractionsDbEntityInsertionAdapter.insert(
        video, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateData(AttractionsDbEntity video) async {
    await _attractionsDbEntityUpdateAdapter.update(
        video, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteData(AttractionsDbEntity video) async {
    await _attractionsDbEntityDeletionAdapter.delete(video);
  }
}
