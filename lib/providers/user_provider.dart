import 'package:flutter/foundation.dart';
import 'package:instagrem/models/user.dart';
import 'package:instagrem/resourses/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User? get getUser => _user;
  Future<void> refreshUser() async {
    
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
