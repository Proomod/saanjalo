import 'package:formz/formz.dart';

enum EmailError {
  empty,
  notEmail,
}

class Email extends FormzInput<String, EmailError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  //we can define regex for email and check if email is equal to it

  static final RegExp regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  EmailError? validator(String? value) {
    return regExp.hasMatch(value ?? '') ? null : EmailError.notEmail;
  }
}

// main(List<String> args) {
//   Email email = new Email.dirty('Bhusalpramod456@gmail.com');
//   print(email.status);
// }
