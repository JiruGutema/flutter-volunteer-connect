// infrastructure/data_sources/events_data_source.dart
import 'package:dio/dio.dart';

class EventsDataSource {
  final Dio _dio;

  EventsDataSource() : _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5500/api', // Update with your API URL
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<Map<String, dynamic>> getEvents() async {
    try {
      final response = await _dio.get('/events');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load events: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}