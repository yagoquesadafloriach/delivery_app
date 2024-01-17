import 'package:delivery_app/auth/constants/error_codes.dart';

class SignInFailure implements Exception {
  const SignInFailure([this.code = 'error-unknown']);

  factory SignInFailure.fromCode(String code) {
    if (handledErrorCodes.contains(code)) return SignInFailure(code);
    return const SignInFailure();
  }

  final String code;
}
