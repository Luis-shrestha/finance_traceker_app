import 'package:floor/floor.dart';
import '../entity/incomeEntity.dart';
import '../entity/registerEntity.dart';

@dao
abstract class IncomeDao {
  @Query("SELECT * FROM IncomeEntity")
  Future<List<IncomeEntity>> getAllIncome();

  @insert
  Future<void> insertIncome(IncomeEntity incomeEntity);

  @update
  Future<void> updateIncome(IncomeEntity incomeEntity);

  @delete
  Future<void> deleteIncome(IncomeEntity incomeEntity);

  // Example of a filtered query
  @Query("SELECT * FROM IncomeEntity WHERE amount > :minAmount ORDER BY date DESC")
  Future<List<IncomeEntity>> getIncomeAboveAmount(double minAmount);

  @Query('SELECT * FROM IncomeEntity WHERE userId = :userId')
  Future<List<IncomeEntity>> findIncomesByUserId(int userId);

  @Query('SELECT amount FROM IncomeEntity WHERE userId = :userId')
  Future<List<IncomeEntity>> getAmountNyUserId(int userId);

  @Query('SELECT COALESCE(SUM(amount), 0) FROM IncomeEntity WHERE userId = :userId')
  Future<double?> getTotalIncomeByUserId(int userId);

}
