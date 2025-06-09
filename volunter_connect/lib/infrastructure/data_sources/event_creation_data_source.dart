// infrastructure/data_sources/event_data_source.dart
import 'package:dio/dio.dart';
import 'package:volunter_connect/domain/models/event_model.dart';

class EventDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5500/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<String, dynamic>> createEvent(Event event, String token) async {
    try {
      final response = await _dio.post(
        '/events/create',
        data: event.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create event: ${e.message}');
    }
  }
}
