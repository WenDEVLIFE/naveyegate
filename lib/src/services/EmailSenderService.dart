import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSenderService {
  static const String gmailkey ='ifbw ykot sqon hxwo';

  static Future<void> sendEmail(String email, String code) async {
    final smtpServer = gmail('frouenmedinajr@gmail.com', gmailkey);

    final message = Message()
      ..from = Address('frouenmedinajr@gmail.com', 'Naveygate Verification Code')
      ..recipients.add(email)
      ..subject = 'Naveygate Verification Code'
      ..html = '<h1>Your verification code is: $code</h1>';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent successfully: $sendReport');
    } on MailerException catch (e) {
      print('Failed to send email: ${e.message}');
      for (var problem in e.problems) {
        print('Problem: ${problem.code} - ${problem.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
}