import 'package:formz/formz.dart';

enum PasswordError { invalidPassword }

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = ""]) : super.dirty(value);

  static final RegExp regExp = new RegExp(
    r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$",
  );

  @override
  PasswordError? validator(String? value) {
    return regExp.hasMatch(value ?? "") ? null : PasswordError.invalidPassword;
  }
}
