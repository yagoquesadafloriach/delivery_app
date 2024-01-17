part of 'signin_cubit.dart';

class SigninState extends Equatable {
  const SigninState({
    required this.email,
    required this.password,
    required this.status,
    this.errorMessage,
  });

  factory SigninState.initial() {
    return const SigninState(
      email: '',
      password: '',
      status: FormStatus.initial,
    );
  }

  final String email;
  final String password;
  final FormStatus status;
  final String? errorMessage;

  SigninState copyWith({String? email, String? password, FormStatus? status, String? errorMessage}) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];
}
