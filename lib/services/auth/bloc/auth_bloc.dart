import 'package:bloc/bloc.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(EmailAuthProvider provider) : super(const AuthStateUninitialize()) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: false),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    // Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.emailCreateUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });
    on<AuthEventShouldRigister>((event, emit) {
      emit(const AuthStateRegistering(null));
    });
    // Send email verification
    on<AuthEventSendVerificationEmail>((event, emit) async {
      provider.sendEmailVerification();
      emit(state);
    });
    // LogIn
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        final user =
            await provider.emailLogIn(email: email, password: password);
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));

          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });
    // LogOut
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateUninitialize());
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });
  }
}
