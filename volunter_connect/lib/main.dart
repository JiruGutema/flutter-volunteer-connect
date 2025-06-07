import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunter_connect/application/blocs/events_bloc.dart';
import 'package:volunter_connect/infrastructure/data_sources/events_data_source.dart';
import 'package:volunter_connect/infrastructure/repositories/event_repository.dart';
import 'application/blocs/auth_bloc.dart';
import 'infrastructure/data_sources/auth_data_source.dart';
import 'infrastructure/repositories/auth_repository.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            authDataSource: AuthDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => EventsRepository(
            eventsDataSource: EventsDataSource(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => EventsBloc(
              eventsRepository: context.read<EventsRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Volunteer App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
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
          ),
        ),
      ),
    );
  }
}