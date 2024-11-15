import 'package:floor/floor.dart';
import 'package:sales_tracker/floorDatabase/entity/registerEntity.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['id'],
      entity: RegisterEntity,
    ),
  ],
)
class GoalEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final double? amount;
  final String? goalName;
  final String? date;
  final String? goalDescription;

  @ColumnInfo(name: 'userId')
  final int userId;

  GoalEntity({
    this.id,
    this.goalName,
    this.amount,
    this.date,
    this.goalDescription,
    required this.userId,
  });
}
