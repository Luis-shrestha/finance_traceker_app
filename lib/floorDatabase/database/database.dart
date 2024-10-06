import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/DAO/expensesDao.dart';
import 'package:sales_tracker/floorDatabase/DAO/goalDao.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:sales_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:sales_tracker/floorDatabase/entity/incomeEntity.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import '../DAO/incomeDao.dart';
import '../DAO/registerDao.dart';
import '../entity/registerEntity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [IncomeEntity, RegisterEntity, ExpensesEntity, GoalEntity])
abstract class AppDatabase extends FloorDatabase {
  IncomeDao get incomeDao;
  RegisterDao get registerDao;
  ExpensesDao get expensesDao;
  GoalDao get goalDao;
}

