// presentation/widgets/event_card.dart
import 'package:flutter/material.dart';
import '../../../domain/models/event_model.dart'; // Make sure to import your Event model

class EventCard extends StatelessWidget {
  final Event event; // Change from Map<String, dynamic> to Event

  const EventCard({super.key, required this.event});

  String getLocalImagePath(String category) {
    switch (category.toLowerCase()) {
      case 'charity':
        return 'assets/image.png';
      case 'adventure':
        return 'assets/image.png';
      case 'education':
        return 'assets/image.png';
      default:
        return 'assets/image.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.asset(
              getLocalImagePath(event.category),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title, // Access properties directly from Event object
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                // ... rest of your widget code using event properties
              ],
            ),
          ),
        ],
      ),
    );
  }
}
