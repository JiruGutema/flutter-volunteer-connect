import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return RepositoryProvider(
      create: (context) => AuthRepository(
        authDataSource: AuthDataSource(),
      ),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        )..add(AuthCheckRequested()),
        child: MaterialApp(
          title: 'Volunteer App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
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