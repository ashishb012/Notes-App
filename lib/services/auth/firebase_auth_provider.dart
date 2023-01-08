import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';

import 'package:my_notes/firebase_options.dart';

class FirebaseAuthProvider implements EmailAuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> emailCreateUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw MyNotesNullUserAuthExceptions();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw MyNotesWeakPasswordAuthExceptions();
      } else if (e.code == "email-already-in-use") {
        throw MyNotesEmailInUseAuthExceptions();
      } else if (e.code == "invalid-email") {
        throw MyNotesInvalidEmailAuthExceptions();
      } else {
        throw MyNotesAuthExceptions();
      }
    } catch (e) {
      throw MyNotesAuthExceptions();
    }
  }

  @override
  Future<AuthUser> emailLogIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw MyNotesNullUserAuthExceptions();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        throw MyNotesWrongPasswordAuthExceptions();
      } else if (e.code == "user-not-found") {
        throw MyNotesNullUserAuthExceptions();
      } else if (e.code == "invalid-email") {
        throw MyNotesInvalidEmailAuthExceptions();
      } else {
        throw MyNotesAuthExceptions();
      }
    } catch (e) {
      throw MyNotesAuthExceptions();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw MyNotesNullUserAuthExceptions();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification();
    } else {
      throw MyNotesNullUserAuthExceptions();
    }
  }

  @override
  Future<void> sendPasswordResetLink({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw MyNotesInvalidEmailAuthExceptions();
      } else if (e.code == "user-not-found") {
        throw MyNotesNullUserAuthExceptions();
      } else {
        throw MyNotesAuthExceptions();
      }
    } catch (_) {
      throw MyNotesAuthExceptions();
    }
  }
}
