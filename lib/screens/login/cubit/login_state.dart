part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  //make a function which updates all value continuously

  final Password password;
  final Email email;
  final FormzStatus status;

  LoginState copyWith({Email? email, Password? password, FormzStatus? status}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [email, password, status];
}

//define parameters and update as well
