// presentation/screens/organization_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/skill_chip.dart';
import '../../application/blocs/profile_bloc/profile_bloc.dart';
import '../../application/blocs/profile_bloc/profile_event.dart';
import '../../application/blocs/profile_bloc/profile_state.dart';
import 'edit_organization_profile_screen.dart';

class OrganizationProfileScreen extends StatelessWidget {
  const OrganizationProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organization')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EditOrganizationProfileScreen()),
        ),
        child: const Icon(Icons.edit),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (ctx, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoaded) {
            final p = state.profile;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo avatar (you’ll swap Icon for Image.network/logo)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 3),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child:
                            Icon(Icons.person, size: 50, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(p.role, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),

                  // Info
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Information',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    ctx.read<ProfileBloc>().add(DeleteProfile(p.id)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.email, size: 20),
                            const SizedBox(width: 8),
                            Text(p.email)
                          ]),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            Text(p.city)
                          ]),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.phone, size: 20),
                            const SizedBox(width: 8),
                            Text(p.phone)
                          ]),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // Domains (single chip for org)
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Stats',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 23,color: Color.fromRGBO(53, 151, 218, 1),),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.attendedEvents.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Events '),
                                ],
                              ),
                              const SizedBox(width: 32),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Domains',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                              spacing: 8,
                              children:
                              p.skills.map((s) => SkillChip(label: s)).toList()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Applicants'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Create Post'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (_) {},
      ),
    );
  }
}
