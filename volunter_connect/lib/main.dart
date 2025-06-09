import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/blocs/auth_bloc.dart';
import 'application/blocs/events_bloc.dart';
import 'application/blocs/profile_bloc/profile_bloc.dart';                // ← NEW
import 'infrastructure/data_sources/auth_data_source.dart';
import 'infrastructure/data_sources/events_data_source.dart';
import 'infrastructure/data_sources/profile_data_source.dart';             // ← NEW
import 'infrastructure/repositories/auth_repository.dart';
import 'infrastructure/repositories/event_repository.dart';
import 'infrastructure/repositories/profile_repository.dart';              // ← NEW
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepositoryImpl(ProfileDataSource()),      // ← NEW
        ),
        RepositoryProvider(
          create: (_) => AuthRepository(authDataSource: AuthDataSource()),
        ),
        RepositoryProvider(
          create: (_) => EventsRepository(eventsDataSource: EventsDataSource()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AuthBloc(authRepository: ctx.read<AuthRepository>())
              ..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (ctx) => EventsBloc(eventsRepository: ctx.read<EventsRepository>()),
          ),
          BlocProvider<ProfileBloc>(                                         // ← NEW
            create: (ctx) => ProfileBloc(repository: ctx.read<ProfileRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Volunteer App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (ctx, state) {
              if (state is Authenticated) {
                return HomeScreen(user: state.user);
              } else if (state is Unauthenticated) {
                return const LoginScreen();
              }
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          ),
        ),
      ),
    );
  }
}
