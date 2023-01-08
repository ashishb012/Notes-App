import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendVerificationEmail extends AuthEvent {
  const AuthEventSendVerificationEmail();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister(this.email, this.password);
}

class AuthEventShouldRigister extends AuthEvent {
  const AuthEventShouldRigister();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
