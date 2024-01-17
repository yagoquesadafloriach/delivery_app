import 'dart:async';

import 'package:delivery_app/auth/data/auth_repository.dart';
import 'package:delivery_app/auth/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(authRepository.currentUser.isNotEmpty
            ? AuthState.authenticated(authRepository.currentUser)
            : const AuthState.unauthenticated(),) {
    on<AuthUserChanged>(_onUserChanged);

    on<AuthLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authRepository.user.listen((user) => add(AuthUserChanged(user)));
  }
  final AuthRepository _authRepository;
  late StreamSubscription<User>? _userSubscription;

  String? get userId => state.user.id;
  Stream<AuthState> get authStream => stream.distinct((a, b) => a.status == b.status && a.user.id == b.user.id);

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) =>
      emit(event.user.isNotEmpty ? AuthState.authenticated(event.user) : const AuthState.unauthenticated());

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) => unawaited(_authRepository.logOut());

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
