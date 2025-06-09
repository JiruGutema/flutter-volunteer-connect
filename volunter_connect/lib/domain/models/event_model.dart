import 'dart:convert';

class Event {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String date;
  final String time;
  final String location;
  final int spotsLeft;
  final String description;
  final Map<String, dynamic> requirements;
  final Map<String, dynamic> additionalInfo;
  final String contactPhone;
  final String contactEmail;
  final String contactTelegram;
  final String? image; // Optional image property

  Event({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.spotsLeft,
    required this.description,
    required this.requirements,
    required this.additionalInfo,
    required this.contactPhone,
    required this.contactEmail,
    required this.contactTelegram,
    this.image, // Optional, defaults to null
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'].toString(),
      subtitle: json['subtitle'].toString(),
      category: json['category'].toString(),
      date: json['date'].toString(),
      time: json['time'].toString(),
      location: json['location'].toString(),
      spotsLeft: _parseSpotsLeft(json['spotsLeft']),
      description: json['description'].toString(),
      requirements: _parseMap(json['requirements']),
      additionalInfo: _parseMap(json['additionalInfo']),
      contactPhone: json['contactPhone'].toString(),
      contactEmail: json['contactEmail'].toString(),
      contactTelegram: json['contactTelegram'].toString(),
      image: json['image']?.toString(), // Handles null
    );
  }

  static int _parseSpotsLeft(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'date': date,
      'time': time,
      'location': location,
      'spotsLeft': spotsLeft,
      'description': description,
      'requirements': requirements,
      'additionalInfo': additionalInfo,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'contactTelegram': contactTelegram,
      'image': image, // Include in JSON
    };
  }
}
