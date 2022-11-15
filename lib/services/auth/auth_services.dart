import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:my_notes/services/auth/firebase_auth_provider.dart';

class AuthService implements EmailAuthProvider {
  final EmailAuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> emailCreateUser(
          {required String email, required String password}) =>
      provider.emailCreateUser(email: email, password: password);

  @override
  Future<AuthUser> emailLogIn(
          {required String email, required String password}) =>
      provider.emailLogIn(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
