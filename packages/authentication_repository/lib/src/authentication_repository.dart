import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'cache/cache.dart';
import 'package:meta/meta.dart';
import 'models/models.dart';

class SignUpFailure implements Exception {}

class LoginWithEmailandPasswordFailure implements Exception {}

class LoginWithGoogleFailure implements Exception {}

class LogoutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository(
      {fireAuth.FirebaseAuth? firebaseAuth,
      CacheClient? cache,
      GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? fireAuth.FirebaseAuth.instance,
        _cache = cache ?? CacheClient(),
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final fireAuth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final CacheClient _cache;

  static const userCacheKey = "__userKey__";

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null
          ? User.empty
          : User(
              id: firebaseUser.uid,
              email: firebaseUser.email,
              username: firebaseUser.displayName,
              name: firebaseUser.displayName);

      _cache.write<User>(key: userCacheKey, value: user);

      return user;
    });
  }

  User get currentUser => _cache.read<User>(key: userCacheKey) ?? User.empty;

  Future<void> createUserWithEmailPassword(
      String email, String password) async {
    try {
      fireAuth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
    } on fireAuth.FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      throw SignUpFailure();
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      fireAuth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } on Exception {
      throw LoginWithEmailandPasswordFailure();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final fireAuth.OAuthCredential credentials =
          fireAuth.GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken);

      await _firebaseAuth.signInWithCredential(credentials);
    } on Exception {
      throw LoginWithGoogleFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);
    } on Exception {
      throw LogoutFailure();
    }
  }
}
