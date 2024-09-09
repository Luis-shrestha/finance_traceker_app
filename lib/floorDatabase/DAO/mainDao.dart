import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/entity/incomeEntity.dart';

@dao
abstract class MainDao {

  @Query("SELECT * FROM NoteEntity")
  Future<List<IncomeEntity>> getAllIncome();

  @insert
  Future<void> insertIncome(IncomeEntity noteEntity);

  @update
  Future<void> updateIncome(IncomeEntity noteEntity);

  @delete
  Future<void> deleteIncome(IncomeEntity noteEntity);
}
