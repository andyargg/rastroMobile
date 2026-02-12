import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackingEvent {
  final String date;
  final String time;
  final String status;
  final String location;
  final String description;

  const TrackingEvent({
    required this.date,
    required this.time,
    required this.status,
    required this.location,
    required this.description,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      status: json['status'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class TrackingResult {
  final bool success;
  final String courier;
  final String trackingNumber;
  final String status;
  final List<TrackingEvent> events;
  final String? error;

  const TrackingResult({
    required this.success,
    required this.courier,
    required this.trackingNumber,
    required this.status,
    required this.events,
    this.error,
  });

  factory TrackingResult.fromJson(Map<String, dynamic> json) {
    return TrackingResult(
      success: json['success'] as bool,
      courier: json['courier'] as String,
      trackingNumber: json['trackingNumber'] as String,
      status: json['status'] as String,
      events: (json['events'] as List?)
              ?.map((e) => TrackingEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }
}

class TrackingService {
  static const String _baseUrl = 'https://rastro-back.onrender.com';
  static const Duration _timeout = Duration(seconds: 60);

  Future<TrackingResult> track({
    required String trackingNumber,
    required String courier,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/track').replace(
        queryParameters: {
          'id': trackingNumber,
          'courier': courier,
        },
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200 && response.statusCode != 404) {
        return TrackingResult(
          success: false,
          courier: courier,
          trackingNumber: trackingNumber,
          status: 'error',
          events: [],
          error: 'Server error: ${response.statusCode}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TrackingResult.fromJson(json);
    } catch (e) {
      return TrackingResult(
        success: false,
        courier: courier,
        trackingNumber: trackingNumber,
        status: 'error',
        events: [],
        error: 'Connection error: ${e.toString()}',
      );
    }
  }
}
