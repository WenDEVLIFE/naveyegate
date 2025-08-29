import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionHelpers {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userInfo['email']);
    print('User info saved: ${userInfo['email']}');
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      return {'email': email};
    }
    return null;
  }

  Future <void> clearUserInfo() async{
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('email');
      _auth.signOut();
      print('User info cleared');
    });
  }
}