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
class IncomeEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final double? amount;
  final String? category;
  final String? date;

  @ColumnInfo(name: 'userId')
  final int userId;

  IncomeEntity(
      {this.id, this.category, this.amount, this.date, required this.userId});
}
