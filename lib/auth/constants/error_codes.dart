import 'package:delivery_app/auth/models/sign_in_failure.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';

const handledErrorCodes = [
  'provider-already-linked',
  'invalid-credential',
  'credential-already-in-use',
  'email-already-in-use',
  'operation-not-allowed',
  'invalid-email',
  'invalid-verification-code',
  'invalid-verification-id',
  'user-not-found',
  'wrong-password',
  'invalid-password',
  'reset-password',
  'passwords-dont-match',
  'too-many-requests',
  'changed-email',
  'error-unknown',
];

extension ErrorMessage on SignInFailure {
  String message(AppLocalizations l10n) {
    switch (code) {
      case 'provider-already-linked':
        return l10n.error_provider_already_linked;
      case 'invalid-credential':
        return l10n.error_invalid_credential;
      case 'credential-already-in-use':
        return l10n.error_credential_already_in_use;
      case 'email-already-in-use':
        return l10n.error_email_already_in_use;
      case 'operation-not-allowed':
        return l10n.error_operation_not_allowed;
      case 'invalid-email':
        return l10n.error_invalid_email;
      case 'invalid-verification-code':
        return l10n.error_invalid_verification_code;
      case 'invalid-verification-id':
        return l10n.error_invalid_verification_id;
      case 'user-not-found':
        return l10n.error_user_not_found;
      case 'wrong-password':
        return l10n.error_wrong_password;
      case 'invalid-password':
        return l10n.error_invalid_password;
      case 'passwords-dont-match':
        return l10n.error_passwords_dont_match;
      case 'too-many-requests':
        return l10n.error_too_many_requests;
      case 'errror-unkown':
      default:
        return l10n.error_something_went_wrong;
    }
  }
}
