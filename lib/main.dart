import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/helpers/loading/loading_screen.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/services/auth/firebase_auth_provider.dart';
import 'package:my_notes/views/forgot_password_view.dart';
import 'package:my_notes/views/login_view.dart';
import 'package:my_notes/views/notes/create_update_notes_view.dart';
import 'package:my_notes/views/notes/notes_view.dart';
import 'package:my_notes/views/register_view.dart';
import 'package:my_notes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: "My Notes",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createUpdateNotesRoute: (context) => const CreateUpdateNotesView(),
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
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? "Please wait a moment",
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}


// // Bloc
// // Counter app
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Testing Bloc"),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalidNumber) ? state.invalidValue : "";
//             return Column(
//               children: [
//                 Text("Current value => ${state.value} "),
//                 Visibility(
//                   visible: state is CounterStateInvalidNumber,
//                   child: Text("Invalid input: $invalidValue "),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: "Enter a number ",
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(DecrimentEvent(_controller.text));
//                       },
//                       child: const Text("-"),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(IncrimentEvent(_controller.text));
//                       },
//                       child: const Text("+"),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;

//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;

//   const CounterEvent(this.value);
// }

// class IncrimentEvent extends CounterEvent {
//   const IncrimentEvent(String value) : super(value);
// }

// class DecrimentEvent extends CounterEvent {
//   const DecrimentEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrimentEvent>(
//       (event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(CounterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ));
//         } else {
//           emit(CounterStateValid(state.value + integer));
//         }
//       },
//     );
//     on<DecrimentEvent>(
//       (event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(CounterStateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ));
//         } else {
//           emit(CounterStateValid(state.value - integer));
//         }
//       },
//     );
//   }
// }