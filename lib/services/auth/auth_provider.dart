import 'package:my_notes/services/auth/auth_user.dart';

abstract class EmailAuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> emailCreateUser({
    required String email,
    required String password,
  });

  Future<AuthUser> emailLogIn({
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification();
  Future<void> logout();
  Future<void> sendPasswordResetLink({required String toEmail});
}
