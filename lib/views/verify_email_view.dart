import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_services.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify email"),
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Check your inbox and verify your email by clicking the link",
              ),
              const Text("\nDidn't recive the email"),
              TextButton(
                onPressed: () async {
                  //final user = FirebaseAuth.instance.currentUser;
                  //await user?.sendEmailVerification();
                  await AuthService.firebase().sendEmailVerification();
                },
                child: const Text("Resend email verification link"),
              ),
              const Text("\nEntered wrong email"),
              TextButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await AuthService.firebase().logout();
                  navigator.pop();
                },
                child: const Text("Restart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
