import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/constants/routs.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
            BlocListener<Authbloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is MyNotesNullUserAuthExceptions) {
                    await showErrorDailog(
                      context,
                      "User not found",
                    );
                  } else if (state.exception
                      is MyNotesWrongPasswordAuthExceptions) {
                    await showErrorDailog(
                      context,
                      "Wrong credentials",
                    );
                  } else if (state.exception
                      is MyNotesInvalidEmailAuthExceptions) {
                    await showErrorDailog(
                      context,
                      "invalid email",
                    );
                  } else if (state.exception is MyNotesAuthExceptions) {
                    await showErrorDailog(
                      context,
                      "Authentication error",
                    );
                  } else {
                    await showErrorDailog(
                      context,
                      "Error: ${state.exception.toString()}",
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<Authbloc>().add(
                          AuthEventLogIn(email, password),
                        );
                  },
                  child: const Text("Login"),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not registered? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
