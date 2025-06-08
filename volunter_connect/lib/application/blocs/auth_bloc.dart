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
  final SharedPreferences prefs;

  AuthBloc({required this.authRepository, required this.prefs})
    : super(AuthInitial()) {
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
      final token = prefs.getString('token');
      final savedUser = prefs.getString('user');
      
      if (token != null && _isTokenValid(token)) {
        // First try to use saved user data if available
        if (savedUser != null) {
          try {
            final user = User.fromJson(json.decode(savedUser));
            emit(Authenticated(user: user));
            return;
          } catch (e) {
            // If saved user data is invalid, fetch fresh data
          }
        }
        
        // If no saved user data or it's invalid, fetch from server
        final response = await authRepository.getCurrentUser();
        final user = User.fromJson(response);
        emit(Authenticated(user: user));
      } else {
        await prefs.remove('token');
        await prefs.remove('user');
        emit(Unauthenticated());
      }
    } catch (e) {
      await prefs.remove('token');
      await prefs.remove('user');
      emit(Unauthenticated());
    }
  }

  bool _isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      // Get the payload part of the JWT
      final jwtPayload = base64Url.normalize(parts[1]);
      final decodedPayload = utf8.decode(base64Url.decode(jwtPayload));
      final Map<String, dynamic> payloadData = json.decode(decodedPayload);

      // Check if token has expired
      final exp = payloadData['exp'] as int?;
      return exp != null &&
          DateTime.fromMillisecondsSinceEpoch(
            exp * 1000,
          ).isAfter(DateTime.now());
    } catch (e) {
      return false;
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

      await prefs.setString('token', response['token']);
      final user = User.fromJson(response['user']);
      emit(Authenticated(user: user));
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
      await prefs.remove('token');
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
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

      await prefs.setString('token', response['token']);
      final user = User.fromJson(response['user']);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }
}
