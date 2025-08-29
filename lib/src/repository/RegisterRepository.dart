import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class RegisterRepository {
  Future<void> registerUser(String email, String password);
}

class RegisterRepositoryImpl implements RegisterRepository {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register the user with email and password
  @override
  Future<void> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(msg: "Registration Successful");
    } catch (e) {
      rethrow;
    }
  }
}