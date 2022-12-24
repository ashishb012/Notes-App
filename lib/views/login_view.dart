import 'package:flutter/material.dart';
import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_services.dart';
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase()
                          .emailLogIn(email: email, password: password);
                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        Navigator.of(context)
                            .pushReplacementNamed(notesViewRoute);
                      } else {
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      }
                    } on MyNotesNullUserAuthExceptions {
                      await showErrorDailog(
                        context,
                        "User not found",
                      );
                    } on MyNotesWrongPasswordAuthExceptions {
                      await showErrorDailog(
                        context,
                        "Wrong credentials",
                      );
                    } on MyNotesInvalidEmailAuthExceptions {
                      await showErrorDailog(
                        context,
                        "invalid email",
                      );
                    } on MyNotesAuthExceptions catch (e) {
                      await showErrorDailog(
                        context,
                        "Error: ${e.toString()} ",
                      );
                    } catch (e) {
                      await showErrorDailog(
                        context,
                        "Error: ${e.toString()} ",
                      );
                    }
                  },
                  child: const Text("Login")),
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
