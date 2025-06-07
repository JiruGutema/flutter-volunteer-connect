import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/models/user_model.dart';
import '../../../infrastructure/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final payload = json.decode(
          utf8.decode(base64.decode(base64.normalize(token.split('.')[1]))),
        );
        final user = User.fromJson(payload);
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      final user = User.fromJson(response['user']);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

Future<void> _onSignupRequested(
  SignupRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  try {
    final response = await authRepository.signup(
      name: event.name,
      email: event.email,
      password: event.password,
      role: event.role,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response['token']);
    
    // Immediately log out after signup
    await prefs.remove('token');
    emit(Unauthenticated());
    
  } catch (e) {
    emit(AuthError(message: e.toString()));
    emit(Unauthenticated());
  }
}

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}