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
            await showErrorDailog(
              context,
              "weak password",
            );
          } else if (state.exception is MyNotesInvalidEmailAuthExceptions) {
            await showErrorDailog(
              context,
              "invalid email",
            );
          } else if (state.exception is MyNotesEmailInUseAuthExceptions) {
            await showErrorDailog(
              context,
              "email already in use",
            );
          } else if (state.exception is MyNotesAuthExceptions) {
            await showErrorDailog(
              context,
              "Authentication error ",
            );
          } else {
            await showErrorDailog(
              context,
              "Error: ${state.exception.toString()}",
            );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                decoration: const InputDecoration(hintText: "Enter your email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _password,
                decoration:
                    const InputDecoration(hintText: "Enter your password"),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              TextField(
                controller: _confirmPassword,
                decoration:
                    const InputDecoration(hintText: "Re-enter your password"),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    if (password != _confirmPassword.text) {
                      await showErrorDailog(
                        context,
                        "Password doesn't match",
                      );
                    }
                    context.read<AuthBloc>().add(
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
    );
  }
}
