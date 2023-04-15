import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Check your inbox and verify your email by clicking the link"),
                const Text("\nAlso check spam folder"),
                const Text("\nIf you didn't recive the email"),
                TextButton(
                  onPressed: () {
                    //add exception for "too-many-requests"
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendVerificationEmail());
                  },
                  child: const Text("Resend email verification link"),
                ),
                const Text("\n\nEntered wrong email"),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text("Restart"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text("Verified Email go to Login page"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
