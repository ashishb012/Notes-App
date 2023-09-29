import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utilities/dailogs/error_dailogs.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is MyNotesNullUserAuthExceptions) {
            showErrorDailog(
                context, "Cannot find user with the entered credentials");
          } else if (state.exception is MyNotesWrongPasswordAuthExceptions) {
            showErrorDailog(context, "Wrong credentials");
          } else if (state.exception is MyNotesInvalidEmailAuthExceptions) {
            showErrorDailog(context, "invalid email");
          } else if (state.exception is MyNotesAuthExceptions) {
            showErrorDailog(context, "Authentication error ");
          } else if (state.exception is Exception) {
            showErrorDailog(context, "Error: ${state.exception.toString()}");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          elevation: 5,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration:
                      const InputDecoration(hintText: "Enter your email"),
                ),
                TextField(
                  controller: _password,
                  decoration:
                      const InputDecoration(hintText: "Enter your password"),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(email, password),
                          );
                    },
                    child: const Text("Login"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: const Text("Forgot password?"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRigister(),
                        );
                  },
                  child: const Text("Not registered? Register here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
