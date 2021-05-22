import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:formz/formz.dart';
import 'package:form_models/form_models.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    print(_authenticationRepository.currentUser);
  }

  final AuthenticationRepository _authenticationRepository;

  //lets define functions which will be exposed instead of events
  void updateEmail(String value) {
    final Email email = Email.dirty(value);
    emit(state.copyWith(
        email: email, status: Formz.validate([email, state.password])));
  }

  void updatePassword(String value) {
    final Password password = Password.dirty(value);

    emit(state.copyWith(
        password: password, status: Formz.validate([state.email, password])));
  }

  // now loginUsingEmailandpassword

  Future<void> loginUsingEmailandpassword() async {
    if (state.status.isInvalid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      // await Future.delayed(Duration(seconds: 5));
      await _authenticationRepository.loginWithEmailAndPassword(
          state.email.value, state.password.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> loginUsingGoogleSignIn() async {
    if (state.status.isInvalid) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.loginWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
