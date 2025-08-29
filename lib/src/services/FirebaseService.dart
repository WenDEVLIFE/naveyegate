import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseService {
  static final adminEmail = 'admin@gmail.com';
  static final adminPassword = '@admin123';

  static Future<void> run() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId:  '1:612619355729:android:1ce37f566938fe47c35a70',
        apiKey: 'AIzaSyBzfJ1OyuDc8_W2uYApGH3Z3PVojPskM-4',
        projectId: 'naveyegate-3b0c4',
        messagingSenderId: '612619355729',
        storageBucket:  'naveyegate-3b0c4.firebasestorage.app',
      ),
    );

    if (Firebase.apps.isEmpty) {
      print('Firebase is not running');
    } else {
      print('Firebase is running');
    }
  }

  // send the email
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    if (email == adminEmail) {
      print('Password reset email sent to $email');
    } else {
      print('No admin email found for $email');
    }
  }
}