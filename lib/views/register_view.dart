import 'package:flutter/material.dart';

import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_services.dart';
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
    return Scaffold(
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
                  try {
                    if (password != _confirmPassword.text) {
                      throw "Password doesn't match";
                    }
                    await AuthService.firebase()
                        .emailCreateUser(email: email, password: password);
                    await AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on MyNotesWeakPasswordAuthExceptions {
                    await showErrorDailog(
                      context,
                      "weak password",
                    );
                  } on MyNotesInvalidEmailAuthExceptions {
                    await showErrorDailog(
                      context,
                      "invalid email",
                    );
                  } on MyNotesEmailInUseAuthExceptions {
                    await showErrorDailog(
                      context,
                      "email already in use",
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
                child: const Text("Register"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registered? Login here"),
            ),
          ],
        ),
      ),
    );
  }
}
