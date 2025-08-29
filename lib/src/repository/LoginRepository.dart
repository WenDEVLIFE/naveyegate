import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class LoginRepository {
  Future<bool> loginUser(String username, String password);
}

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<bool> loginUser(String username, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: username, password: password);
      Fluttertoast.showToast(msg: "Login Successful");
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Login Failed: ${e.toString()}");
      return false;
    }
  }
  }