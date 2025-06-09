// presentation/screens/edit_organization_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunter_connect/presentation/widgets/org_edit_profile_form.dart';
import '../widgets/edit_profile_form.dart';
import '../../application/blocs/profile_bloc/profile_bloc.dart';
import '../../application/blocs/profile_bloc/profile_event.dart';
import '../../application/blocs/profile_bloc/profile_state.dart';

class EditOrganizationProfileScreen extends StatelessWidget {
  const EditOrganizationProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Organization')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (ctx, state) {
          if (state is ProfileLoaded) {
            return OrgEditProfileForm(
              user: state.profile,
              onSave: (updated) {
                ctx.read<ProfileBloc>().add(UpdateProfile(updated));
                Navigator.of(context).pop();
              },
            );
          }
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
