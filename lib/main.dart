import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/constants/routs.dart';
import 'package:my_notes/services/auth/auth_services.dart';
import 'package:my_notes/views/login_view.dart';
import 'package:my_notes/views/notes/create_update_notes_view.dart';
import 'package:my_notes/views/notes/notes_view.dart';
import 'package:my_notes/views/register_view.dart';
import 'package:my_notes/views/verify_email_view.dart';
import 'package:path/path.dart';

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
        createUpdateNotesRoute: (context) => const CreateUpdateNotesView(),
      },
    ),
  );
}

// Bloc
// Counter app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Testing Bloc"),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : "";
            return Column(
              children: [
                Text("Current value => ${state.value} "),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text("Invalid input: $invalidValue "),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Enter a number ",
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrimentEvent(_controller.text));
                      },
                      child: const Text("-"),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrimentEvent(_controller.text));
                      },
                      child: const Text("+"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrimentEvent extends CounterEvent {
  const IncrimentEvent(String value) : super(value);
}

class DecrimentEvent extends CounterEvent {
  const DecrimentEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrimentEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ));
        } else {
          emit(CounterStateValid(state.value + integer));
        }
      },
    );
    on<DecrimentEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ));
        } else {
          emit(CounterStateValid(state.value - integer));
        }
      },
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //appBar: AppBar(
//       //  title: const Text("Notes"),
//       //  elevation: 5,
//       //  centerTitle: true,
//       //  shape: RoundedRectangleBorder(
//       //    borderRadius: BorderRadius.circular(30),
//       //  ),
//       //),
//       body: FutureBuilder(
//         future: AuthService.firebase().initialize(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               final user = AuthService.firebase().currentUser;
//               if (user != null) {
//                 if (user.isEmailVerified) {
//                   return const NotesView();
//                 } else {
//                   return const VerifyEmailView();
//                 }
//               } else {
//                 return const LoginView();
//               }

//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
