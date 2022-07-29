import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/auth/services/auth.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _userModel = user;
    notifyListeners();
  }
}
