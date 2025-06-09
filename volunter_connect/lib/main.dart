import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunter_connect/application/blocs/auth_bloc.dart';
import 'package:volunter_connect/application/blocs/event_creation_bloc.dart';
import 'package:volunter_connect/application/blocs/events_bloc.dart';
import 'package:volunter_connect/infrastructure/data_sources/auth_data_source.dart';
import 'package:volunter_connect/infrastructure/data_sources/event_creation_data_source.dart';
import 'package:volunter_connect/infrastructure/repositories/auth_repository.dart';
import 'package:volunter_connect/infrastructure/repositories/event_creation_repository.dart';
import 'package:volunter_connect/presentation/screens/login_screen.dart';
import 'package:volunter_connect/presentation/screens/organization_home_screen.dart';
import 'package:volunter_connect/presentation/screens/volunteer_home_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();

  runApp(VolunteerConnectApp(prefs: prefs));
}

class VolunteerConnectApp extends StatelessWidget {
  final SharedPreferences prefs;

  const VolunteerConnectApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: prefs),
        RepositoryProvider(
          create: (context) => AuthRepository(authDataSource: AuthDataSource()),
        ),
        RepositoryProvider(
          create:
              (context) => EventRepository(eventDataSource: EventDataSource()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                  prefs: context.read<SharedPreferences>(),
                )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create:
                (context) => EventsBloc(
                  eventsRepository: context.read<EventRepository>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => EventCreationBloc(
                  eventRepository: context.read<EventRepository>(),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'Volunteer Connect',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AppRouter(),
        ),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Route based on user role
          return state.user.role == 'Volunteer'
              ? VolunteerHomeScreen(user: state.user)
              : OrganizationHomeScreen(user: state.user);
        } else if (state is Unauthenticated) {
          return const LoginScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
