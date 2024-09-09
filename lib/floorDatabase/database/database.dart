import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/entity/incomeEntity.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import '../DAO/mainDao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [IncomeEntity])
abstract class AppDatabase extends FloorDatabase{

  MainDao get mainDao;
}