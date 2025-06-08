
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunter_connect/application/blocs/auth_bloc.dart';
import 'package:volunter_connect/application/blocs/events_bloc.dart';
import 'package:volunter_connect/infrastructure/data_sources/auth_data_source.dart';
import 'package:volunter_connect/infrastructure/data_sources/events_data_source.dart';
import 'package:volunter_connect/infrastructure/repositories/auth_repository.dart';
import 'package:volunter_connect/infrastructure/repositories/event_repository.dart';
import 'package:volunter_connect/presentation/screens/home_screen.dart';
import 'package:volunter_connect/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    RepositoryProvider<SharedPreferences>.value(
      value: prefs,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) {
        final prefs = RepositoryProvider.of<SharedPreferences>(context);
        final authBloc = AuthBloc(
          authRepository: AuthRepository(
            authDataSource: AuthDataSource(),
          ),
          prefs: prefs,
        );
        
        // Add AuthCheckRequested when the bloc is created
        authBloc.add(AuthCheckRequested());
        
        // Listen for authentication changes to persist state
        authBloc.stream.listen((state) {
          if (state is Authenticated) {
            prefs.setString('user', jsonEncode(state.user.toJson()));
          } else if (state is Unauthenticated) {
            prefs.remove('user');
          }
        });
        
        return authBloc;
      },
      child: MaterialApp(
        title: 'Volunteer App',
        debugShowCheckedModeBanner: false,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => EventsRepository(
                eventsDataSource: EventsDataSource(),
              ),
            ),
          ],
          child: BlocProvider<EventsBloc>(
            create: (context) => EventsBloc(
              eventsRepository: context.read<EventsRepository>(),
            ),
            child: const AuthWrapper(),
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return HomeScreen(user: state.user);
        } else if (state is Unauthenticated) {
          return const LoginScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}