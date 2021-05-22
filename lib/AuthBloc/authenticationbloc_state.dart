part of 'authenticationbloc_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AuthenticationblocState extends Equatable {
  //definne some constructors with different state
  const AuthenticationblocState._({
    required this.status,
    this.user = User.empty,
  });

  // change when the user is authenticated state chai event fire vaye
  //paxi change hunxa so do it before

  const AuthenticationblocState.authenticated(User user)
      : this._(
          status: AppStatus.authenticated,
          user: user,
        );

  const AuthenticationblocState.unauthenticated()
      : this._(status: AppStatus.unauthenticated);

  @override
  List<Object?> get props => [user, status];

  @required
  final User? user;

  final AppStatus status;
}
