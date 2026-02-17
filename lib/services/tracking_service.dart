import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

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
  static final String _backendUrl =
      dotenv.env['BACKEND_URL'] ?? 'https://rastro-back.onrender.com';

  Future<TrackingResult> track({
    required String trackingNumber,
    required String courier,
  }) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        return TrackingResult(
          success: false,
          courier: courier,
          trackingNumber: trackingNumber,
          status: 'error',
          events: [],
          error: 'No active session',
        );
      }

      final uri = Uri.parse(
        '$_backendUrl/api/track?id=$trackingNumber&courier=$courier',
      );

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      });

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return TrackingResult.fromJson(json);
      } else {
        return TrackingResult(
          success: false,
          courier: courier,
          trackingNumber: trackingNumber,
          status: 'error',
          events: [],
          error: json['error'] as String? ?? 'Server error',
        );
      }
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
