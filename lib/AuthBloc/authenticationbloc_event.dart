part of 'authenticationbloc_bloc.dart';

@immutable
abstract class AuthenticationblocEvent extends Equatable {}

//
class AuthenticationFailure extends AuthenticationblocEvent {
  @override
  // ignore: always_specify_types
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationblocEvent {
  AuthenticationSuccess({required this.user});

  final User user;
  @override
  // ignore: always_specify_types
  List<Object?> get props => [user];
}

class AuthenticationLogOutRequest extends AuthenticationblocEvent {
  @override
  // ignore: always_specify_types
  List<Object> get props => [];
}
