// // ignore: use_function_type_syntax_for_parameters


// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// // ignore: use_function_type_syntax_for_parameters
// test('Login with valid credentials returns Authenticated state', () async {
//   // Mock successful login response
//   when(mockAuthRepository.login(any, any)).thenAnswer((_) async => {
//     'token': 'valid_jwt_token',
//     'user': {'id': 1, 'name': 'Test Org', 'email': 'org@test.com', 'role': 'Organization'}
//   });

//   bloc.add(LoginRequested(email: 'org@test.com', password: 'validpassword'));
//   await expectLater(
//     bloc.stream,
//     emitsInOrder([
//       AuthLoading(),
//       isA<Authenticated>(),
//     ]),
//   );
// });

// test('Login with invalid credentials returns Unauthenticated state', () async {
//   when(mockAuthRepository.login(any, any)).thenThrow(Exception('Invalid credentials'));
  
//   bloc.add(LoginRequested(email: 'wrong@test.com', password: 'wrongpass'));
//   await expectLater(
//     bloc.stream,
//     emitsInOrder([
//       AuthLoading(),
//       AuthError(message: 'Exception: Invalid credentials'),
//       Unauthenticated(),
//     ]),
//   );
// });