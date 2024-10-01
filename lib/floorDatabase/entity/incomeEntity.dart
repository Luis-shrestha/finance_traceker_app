
import 'package:floor/floor.dart';

@Entity()
class IncomeEntity{

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? amount;
  String? category;
  String? date;

  IncomeEntity({this.id, this.category, this.amount, this.date});
}


