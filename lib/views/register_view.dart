import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utilities/dailogs/error_dailogs.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is MyNotesWeakPasswordAuthExceptions) {
            showErrorDailog(context, "weak password");
          } else if (state.exception is MyNotesInvalidEmailAuthExceptions) {
            showErrorDailog(context, "invalid email");
          } else if (state.exception is MyNotesEmailInUseAuthExceptions) {
            showErrorDailog(context, "email already in use");
          } else if (state.exception is MyNotesAuthExceptions) {
            showErrorDailog(context, "Authentication error ");
          } else if (state.exception is Exception) {
            showErrorDailog(context, "Error: ${state.exception.toString()}");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
          elevation: 5,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration:
                      const InputDecoration(hintText: "Enter your password"),
                ),
                TextField(
                  controller: _confirmPassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration:
                      const InputDecoration(hintText: "Re-enter your password"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      final authBloc = context.read<AuthBloc>();
                      if (password != _confirmPassword.text) {
                        showErrorDailog(
                          context,
                          "Password doesn't match",
                        );
                      }
                      authBloc.add(
                        AuthEventRegister(email, password),
                      );
                    },
                    child: const Text("Register"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text("Already registered? Login here"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
