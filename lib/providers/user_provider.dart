import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners(); // Notify listeners about the change
  }

  // ✅ Updated method to modify individual fields
  void updateUser({
    String? name,
    int? age,
    double? weight,
    double? height,
    String? fitnessGoal,
  }) {
    if (_user == null) return; // Ensure user exists before updating

    _user = UserModel(
      name: name ?? _user!.name,
      age: age ?? _user!.age,
      weight: weight ?? _user!.weight,
      height: height ?? _user!.height,
      fitnessGoal: fitnessGoal ?? _user!.fitnessGoal,
    );

    notifyListeners();
  }
}
