// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  IncomeDao? _incomeDaoInstance;

  RegisterDao? _registerDaoInstance;

  ExpensesDao? _expensesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `IncomeEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `amount` TEXT, `category` TEXT, `date` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RegisterEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userName` TEXT NOT NULL, `email` TEXT NOT NULL, `contact` TEXT NOT NULL, `password` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ExpensesEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `amount` TEXT, `category` TEXT, `date` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  IncomeDao get incomeDao {
    return _incomeDaoInstance ??= _$IncomeDao(database, changeListener);
  }

  @override
  RegisterDao get registerDao {
    return _registerDaoInstance ??= _$RegisterDao(database, changeListener);
  }

  @override
  ExpensesDao get expensesDao {
    return _expensesDaoInstance ??= _$ExpensesDao(database, changeListener);
  }
}

class _$IncomeDao extends IncomeDao {
  _$IncomeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _incomeEntityInsertionAdapter = InsertionAdapter(
            database,
            'IncomeEntity',
            (IncomeEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date
                }),
        _incomeEntityUpdateAdapter = UpdateAdapter(
            database,
            'IncomeEntity',
            ['id'],
            (IncomeEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date
                }),
        _incomeEntityDeletionAdapter = DeletionAdapter(
            database,
            'IncomeEntity',
            ['id'],
            (IncomeEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<IncomeEntity> _incomeEntityInsertionAdapter;

  final UpdateAdapter<IncomeEntity> _incomeEntityUpdateAdapter;

  final DeletionAdapter<IncomeEntity> _incomeEntityDeletionAdapter;

  @override
  Future<List<IncomeEntity>> getAllIncome() async {
    return _queryAdapter.queryList('SELECT * FROM IncomeEntity',
        mapper: (Map<String, Object?> row) => IncomeEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as String?,
            date: row['date'] as String?));
  }

  @override
  Future<List<IncomeEntity>> getIncomeAboveAmount(double minAmount) async {
    return _queryAdapter.queryList(
        'SELECT * FROM IncomeEntity WHERE amount > ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => IncomeEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as String?,
            date: row['date'] as String?),
        arguments: [minAmount]);
  }

  @override
  Future<void> insertIncome(IncomeEntity incomeEntity) async {
    await _incomeEntityInsertionAdapter.insert(
        incomeEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateIncome(IncomeEntity incomeEntity) async {
    await _incomeEntityUpdateAdapter.update(
        incomeEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteIncome(IncomeEntity incomeEntity) async {
    await _incomeEntityDeletionAdapter.delete(incomeEntity);
  }
}

class _$RegisterDao extends RegisterDao {
  _$RegisterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _registerEntityInsertionAdapter = InsertionAdapter(
            database,
            'RegisterEntity',
            (RegisterEntity item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'email': item.email,
                  'contact': item.contact,
                  'password': item.password
                }),
        _registerEntityUpdateAdapter = UpdateAdapter(
            database,
            'RegisterEntity',
            ['id'],
            (RegisterEntity item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'email': item.email,
                  'contact': item.contact,
                  'password': item.password
                }),
        _registerEntityDeletionAdapter = DeletionAdapter(
            database,
            'RegisterEntity',
            ['id'],
            (RegisterEntity item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'email': item.email,
                  'contact': item.contact,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RegisterEntity> _registerEntityInsertionAdapter;

  final UpdateAdapter<RegisterEntity> _registerEntityUpdateAdapter;

  final DeletionAdapter<RegisterEntity> _registerEntityDeletionAdapter;

  @override
  Future<List<RegisterEntity>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM RegisterEntity',
        mapper: (Map<String, Object?> row) => RegisterEntity(
            id: row['id'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            contact: row['contact'] as String));
  }

  @override
  Future<RegisterEntity?> getUserByUsernameAndPassword(
    String username,
    String hashedPassword,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM RegisterEntity WHERE userName = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => RegisterEntity(
            id: row['id'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            contact: row['contact'] as String),
        arguments: [username, hashedPassword]);
  }

  @override
  Future<void> insertUser(RegisterEntity registerEntity) async {
    await _registerEntityInsertionAdapter.insert(
        registerEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(RegisterEntity registerEntity) async {
    await _registerEntityUpdateAdapter.update(
        registerEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(RegisterEntity registerEntity) async {
    await _registerEntityDeletionAdapter.delete(registerEntity);
  }
}

class _$ExpensesDao extends ExpensesDao {
  _$ExpensesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expensesEntityInsertionAdapter = InsertionAdapter(
            database,
            'ExpensesEntity',
            (ExpensesEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date
                }),
        _expensesEntityUpdateAdapter = UpdateAdapter(
            database,
            'ExpensesEntity',
            ['id'],
            (ExpensesEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date
                }),
        _expensesEntityDeletionAdapter = DeletionAdapter(
            database,
            'ExpensesEntity',
            ['id'],
            (ExpensesEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExpensesEntity> _expensesEntityInsertionAdapter;

  final UpdateAdapter<ExpensesEntity> _expensesEntityUpdateAdapter;

  final DeletionAdapter<ExpensesEntity> _expensesEntityDeletionAdapter;

  @override
  Future<List<ExpensesEntity>> getAllExpenses() async {
    return _queryAdapter.queryList('SELECT * FROM ExpensesEntity',
        mapper: (Map<String, Object?> row) => ExpensesEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as String?,
            date: row['date'] as String?));
  }

  @override
  Future<List<ExpensesEntity>> getExpensesAboveAmount(double minAmount) async {
    return _queryAdapter.queryList(
        'SELECT * FROM IncomeEntity WHERE amount > ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpensesEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as String?,
            date: row['date'] as String?),
        arguments: [minAmount]);
  }

  @override
  Future<void> insertExpenses(ExpensesEntity expensesEntity) async {
    await _expensesEntityInsertionAdapter.insert(
        expensesEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpenses(ExpensesEntity expensesEntity) async {
    await _expensesEntityUpdateAdapter.update(
        expensesEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExpenses(ExpensesEntity expensesEntity) async {
    await _expensesEntityDeletionAdapter.delete(expensesEntity);
  }
}
