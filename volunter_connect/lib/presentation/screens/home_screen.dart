import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/blocs/auth_bloc.dart';
import '../../../domain/models/user_model.dart';
import '../widgets/event_card.dart';
import './login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      events = [
        {
          "id": "1",
          "title": "Workshop: Intro to Python",
          "subtitle": "Blood Donation",
          "category": "Charity",
          "date": "2024-10-27",
          "time": "10:00 AM",
          "location": "Addis Ababa, Bole",
          "spotsLeft": 15,
          "image": "assets/image.png",
          "description":
              "This is where we strive to save mothers life by denoting blood",
          "requirements": {
            "Free from Disease": true,
            "Age greater than 18": false,
          },
          "additionalInfo": {"Cross": "Hospital", "instructor": "Jane Doe"},
          "contactPhone": "+1-555-123-4567",
          "contactEmail": "jane.doe@example.com",
          "contactTelegram": "@jethior",
        },
        {
          "id": "2",
          "title": "Hiking Trip to Mount Kenya",
          "subtitle": "Explore the beauty of Mount Kenya",
          "category": "Adventure",
          "date": "2024-11-10",
          "time": "8:00 AM",
          "location": "Mount Kenya National Park",
          "spotsLeft": 5,
          "image": "assets/image.png",
          "description":
              "Join us for an adventurous hiking trip to Mount Kenya...",
          "requirements": {
            "hiking_boots": true,
            "good_physical_condition": true,
          },
          "additionalInfo": {
            "guide": "John Smith",
            "packing_list": "Available on website",
          },
          "contactPhone": "+254-700-123-4567",
          "contactEmail": "john.smith@example.com",
          "contactTelegram": "@ashee",
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Access AuthBloc using the correct context
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${widget.user.name}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ready to make a difference today?',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Ongoing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join us at the Workforce Development Center for My Morgan SAID Group Hiring Event.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Upcoming events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: events[index]);
                      },
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Application',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
