import 'package:flutter/material.dart';
import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/services/auth/auth_services.dart';
import 'package:my_notes/views/login_view.dart';
import 'package:my_notes/views/notes_view.dart';
import 'package:my_notes/views/register_view.dart';
import 'package:my_notes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: "My Notes",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        notesViewRoute: (context) => const NotesView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text("Notes"),
      //  elevation: 5,
      //  centerTitle: true,
      //  shape: RoundedRectangleBorder(
      //    borderRadius: BorderRadius.circular(30),
      //  ),
      //),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                  //return const LoginView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
