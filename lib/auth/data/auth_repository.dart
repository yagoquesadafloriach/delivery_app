import 'package:delivery_app/auth/data/firebase_auth_service.dart';
import 'package:delivery_app/auth/models/user_model.dart';

class AuthRepository {
  static final _firebaseAuthService = FirebaseAuthService();

  User get currentUser => _firebaseAuthService.currentUser;

  Stream<User> get user => _firebaseAuthService.user;

  Future<void> signUp({required String email, required String password}) => _firebaseAuthService.signUp(email: email, password: password);

  Future<void> signIn({required String email, required String password}) => _firebaseAuthService.signIn(email: email, password: password);

  Future<void> logOut() => _firebaseAuthService.logOut();

  Future<bool> checkIfExistsAccountWithEmail(String email) => _firebaseAuthService.checkIfExistsAccountWithEmail(email);
}
