import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';

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

  @Query('SELECT amount FROM ExpensesEntity WHERE userId = :userId')
  Future<List<ExpensesEntity>> getAmountNyUserId(int userId);

  @Query('SELECT COALESCE(SUM(amount), 0) FROM ExpensesEntity WHERE userId = :userId')
  Future<double?> getTotalExpensesByUserId(int userId);
}
