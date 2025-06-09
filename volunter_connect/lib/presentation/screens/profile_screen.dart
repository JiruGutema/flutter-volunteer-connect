import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/blocs/profile_bloc/profile_bloc.dart';
import '../../application/blocs/profile_bloc/profile_event.dart';
import '../../application/blocs/profile_bloc/profile_state.dart';
import '../widgets/skill_chip.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
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
                  // Avatar card full-width
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

                  // Personal Info
                  Card(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Personal Information',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
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
                          const Text('Bio',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(p.bio),
                        ],
                      ),
                    ),
                  ),

                  // Volunteer Stats
                  Card(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Volunteer Stats',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),

                          // events & hours left-aligned
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
                                  const Text('Events Attended'),
                                ],
                              ),
                              const SizedBox(width: 32),
                              Icon(Icons.access_time, size: 25,color: Color.fromRGBO(53, 151, 218, 1)),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.hoursVolunteered.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Hours Volunteered'),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Text('Skills',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                              spacing: 8,
                              children:
                              p.skills.map((s) => SkillChip(label: s)).toList()),
                          const SizedBox(height: 16),
                          const Text('Interests',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                              spacing: 8,
                              children: p.interests
                                  .map((i) => SkillChip(label: i))
                                  .toList()),
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
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My App'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (_) {},
      ),
    );
  }
}
