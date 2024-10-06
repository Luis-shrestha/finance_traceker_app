import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import '../entity/incomeEntity.dart';
import '../entity/registerEntity.dart';

@dao
abstract class ExpensesDao {
  @Query("SELECT * FROM ExpensesEntity")
  Future<List<ExpensesEntity>> getAllExpenses();

  @insert
  Future<void> insertExpenses(ExpensesEntity expensesEntity);

  @update
  Future<void> updateExpenses(ExpensesEntity expensesEntity);

  @delete
  Future<void> deleteExpenses(ExpensesEntity expensesEntity);

  // Example of a filtered query
  @Query("SELECT * FROM ExpensesEntity WHERE amount > :minAmount ORDER BY date DESC")
  Future<List<ExpensesEntity>> getExpensesAboveAmount(double minAmount);

  @Query('SELECT * FROM ExpensesEntity WHERE userId = :userId')
  Future<List<ExpensesEntity>> findExpensesByUserId(int userId);
}
