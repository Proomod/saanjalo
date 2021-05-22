import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authenticationbloc_event.dart';
part 'authenticationbloc_state.dart';

class AuthenticationblocBloc
    extends Bloc<AuthenticationblocEvent, AuthenticationblocState> {
  AuthenticationblocBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(authenticationRepository.currentUser.isEmpty
            ? const AuthenticationblocState.unauthenticated()
            : AuthenticationblocState.authenticated(
                authenticationRepository.currentUser)) {
    _usersubscription = _authenticationRepository.user.listen(_onUserChanged);
  }

  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription<User> _usersubscription;

  void _onUserChanged(User user) => add(AuthenticationSuccess(user: user));

  @override
  Stream<AuthenticationblocState> mapEventToState(
    AuthenticationblocEvent event,
  ) async* {
    //map event to state based on different conditions
    if (event is AuthenticationSuccess) {
      yield _mapAuthSuccessToState(event, state);
    } else if (event is AuthenticationFailure) {
      yield const AuthenticationblocState.unauthenticated();
    } else if (event is AuthenticationLogOutRequest) {
      _authenticationRepository.logOut();
    }
  }

  AuthenticationblocState _mapAuthSuccessToState(
      AuthenticationSuccess event, AuthenticationblocState state) {
    return event.user.isNotEmpty
        ? AuthenticationblocState.authenticated(event.user)
        : const AuthenticationblocState.unauthenticated();
  }

  @override
  Future<void> close() async {
    await _usersubscription.cancel();
    return super.close();
  }
}
