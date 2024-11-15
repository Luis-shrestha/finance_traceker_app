// user_data_service.dart
import 'package:flutter/material.dart';
import 'package:sales_tracker/floorDatabase/database/database.dart';
import 'package:sales_tracker/floorDatabase/entity/registerEntity.dart';
import '../../supports/utils/sharedPreferenceManager.dart';

class UserDataService {
  final AppDatabase database;

  UserDataService(this.database);

  Future<RegisterEntity?> getUserData(BuildContext context) async {
    RegisterEntity? user;
    try {
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();

      if (username != null && password != null) {
        user = await database.registerDao.getUserByUsernameAndPassword(username, password);
      }
    } catch (e) {
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    }
    return user;
  }
}
