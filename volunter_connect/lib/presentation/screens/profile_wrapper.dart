import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunter_connect/presentation/screens/profile_screen.dart';

import '../../application/blocs/profile_bloc/profile_bloc.dart';
import '../../application/blocs/profile_bloc/profile_event.dart';
import '../../application/blocs/profile_bloc/profile_state.dart';

import 'organization_profile_screen.dart';

class ProfileWrapper extends StatefulWidget {
  final int userId;
  const ProfileWrapper({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileWrapper> createState() => _ProfileWrapperState();
}

class _ProfileWrapperState extends State<ProfileWrapper> {
  @override
  void initState() {
    super.initState();
    // Fire the load only once
    context.read<ProfileBloc>().add(LoadProfile(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (ctx, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }

        if (state is ProfileLoaded) {
          final role = state.profile.role.toLowerCase();
          if (role == 'organization') {
            return const OrganizationProfileScreen();
          } else {
            return const ProfileScreen();
          }
        }

        // Fallback
        return const Scaffold(
          body: Center(child: Text('Unknown profile state')),
        );
      },
    );
  }
}
