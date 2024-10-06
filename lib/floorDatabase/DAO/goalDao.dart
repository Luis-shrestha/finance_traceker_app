import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:sales_tracker/floorDatabase/entity/goalEntity.dart';

@dao
abstract class GoalDao {
  @Query("SELECT * FROM GoalEntity")
  Future<List<GoalEntity>> getAllGoal();

  @insert
  Future<void> insertGoal(GoalEntity goalEntity);

  @update
  Future<void> updateGoal(GoalEntity goalEntity);

  @delete
  Future<void> deleteGoal(GoalEntity goalEntity);

  @Query("SELECT * FROM GoalEntity WHERE amount > :minAmount ORDER BY date DESC")
  Future<List<GoalEntity>> getGoalAboveAmount(double minAmount);
}
