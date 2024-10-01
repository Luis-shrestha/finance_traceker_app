
import 'package:floor/floor.dart';

@Entity()
class ExpensesEntity{

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? amount;
  String? category;
  String? date;

  ExpensesEntity({this.id, this.category, this.amount, this.date});
}


