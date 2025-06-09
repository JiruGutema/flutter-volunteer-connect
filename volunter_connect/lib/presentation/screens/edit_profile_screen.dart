import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunter_connect/presentation/widgets/org_edit_profile_form.dart';
import '../../application/blocs/profile_bloc/profile_bloc.dart';
import '../../application/blocs/profile_bloc/profile_event.dart';
import '../../application/blocs/profile_bloc/profile_state.dart';
import '../widgets/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (ctx, state) {
        if (state is ProfileLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is ProfileLoaded) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Profile')),
            body: EditProfileForm(
              user: state.profile,
              onSave: (updated) {
                ctx.read<ProfileBloc>().add(UpdateProfile(updated));
                Navigator.of(context).pop();
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
