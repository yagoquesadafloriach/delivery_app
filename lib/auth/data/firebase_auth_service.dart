import 'dart:async';
import 'dart:developer';

import 'package:delivery_app/auth/models/sign_in_failure.dart';
import 'package:delivery_app/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FirebaseAuthService {
  FirebaseAuthService({
    auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;
  final auth.FirebaseAuth _firebaseAuth;

  User currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map(
      (firebaseUser) {
        final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
        currentUser = user;
        return user;
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (error) {
      log('Firebase Auth Exception Error - $error');
      throw SignInFailure.fromCode(error.code);
    } catch (error) {
      log('Unknown Error - $error');
      throw const SignInFailure();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (error) {
      log('Firebase Auth Exception Error - $error');
      throw SignInFailure.fromCode(error.code);
    } catch (error) {
      log('Unknown Error - $error');
      throw const SignInFailure();
    }
  }

  Future<bool> checkIfExistsAccountWithEmail(String email) async {
    try {
      final list = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SignInFailure {
      rethrow;
    } on auth.FirebaseAuthException catch (e) {
      throw SignInFailure.fromCode(e.code);
    } catch (e) {
      log(e.toString());
      throw const SignInFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on auth.FirebaseAuthException catch (error) {
      log('Firebase Auth Exception Error - $error');
    } catch (error) {
      log('Unknown Error - $error');
    }
  }
}

extension on auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email ?? '',
      photo: photoURL,
    );
  }
}
