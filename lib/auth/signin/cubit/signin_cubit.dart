import 'dart:developer';

import 'package:delivery_app/auth/constants/error_codes.dart';
import 'package:delivery_app/auth/data/auth_repository.dart';
import 'package:delivery_app/auth/mixins/auth_mixin.dart';
import 'package:delivery_app/auth/models/sign_in_failure.dart';
import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> with AuthMixin {
  SigninCubit({required this.authRepository, required this.l10n}) : super(SigninState.initial());

  final AuthRepository authRepository;
  final AppLocalizations l10n;

  void emailChanged(String value) => emit(state.copyWith(email: value, status: FormStatus.initial));

  void passwordChanged(String value) => emit(state.copyWith(password: value, status: FormStatus.initial));

  Future<void> signin({required bool isSignIn}) async {
    if (!isValidEmail(state.email) || !isValidPassword(state.password)) {
      return emit(state.copyWith(status: FormStatus.error, errorMessage: const SignInFailure().message(l10n)));
    }

    emit(state.copyWith(status: FormStatus.loading));

    try {
      if (isSignIn) {
        await authRepository.signIn(email: state.email, password: state.password);
      } else {
        await authRepository.signUp(email: state.email, password: state.password);
      }
      emit(state.copyWith(status: FormStatus.success));
    } on SignInFailure catch (error) {
      log('Sign In Failure Error - $error');
      emit(state.copyWith(status: FormStatus.error, errorMessage: error.message(l10n)));
    } on auth.FirebaseAuthException catch (error) {
      log('Firebase Auth Exception Error - $error ');
      final ex = SignInFailure.fromCode(error.code);
      emit(state.copyWith(status: FormStatus.error, errorMessage: ex.message(l10n)));
    } catch (error) {
      log('Unknown Error - $error');
      emit(state.copyWith(status: FormStatus.error, errorMessage: const SignInFailure().message(l10n)));
    }
  }
}
