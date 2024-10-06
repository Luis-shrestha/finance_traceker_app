
import 'package:floor/floor.dart';

@Entity()
class GoalEntity{

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? amount;
  String? goalName;
  String? date;
  String? goalDescription;

  GoalEntity({this.id, this.goalName, this.amount, this.date, this.goalDescription});
}


