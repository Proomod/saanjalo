import 'package:formz/formz.dart';

enum ConfirmPasswordError { unMatchedPassword }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordError> {
  ConfirmPassword.pure({this.password = ''}) : super.pure('');
  ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  String password;

  // Password password = new Password.dirty("bbb12Abc12");

  @override
  ConfirmPasswordError? validator(String value) {
    return value == password ? null : ConfirmPasswordError.unMatchedPassword;
  }
}

// main(List<String> args) {
//   ConfirmPassword pass =
//       ConfirmPassword.dirty(password: "Hello world", value: "Helo msiter");

//   print(pass.error);
// }
