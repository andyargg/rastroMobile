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
  Future<TrackingResult> track({
    required String trackingNumber,
    required String courier,
  }) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      print('=== AUTH DEBUG ===');
      print('Session: ${session != null ? "EXISTS" : "NULL"}');
      print('Token: ${session?.accessToken.substring(0, 20)}...');
      print('==================');

      final response = await Supabase.instance.client.functions.invoke(
        'track',
        body: {
          'tracking_number': trackingNumber,
          'courier': courier,
        },
      );

      print('=== TRACKING DEBUG ===');
      print('Status: ${response.status}');
      print('Data type: ${response.data.runtimeType}');
      print('Data: ${response.data}');
      print('=====================');


      final json = response.data as Map<String, dynamic>;
      return TrackingResult.fromJson(json);
    } on FunctionException catch (e) {
      print('=== TRACKING FunctionException ===');
      print('Status: ${e.status}, Details: ${e.details}, Reason: ${e.reasonPhrase}');
      return TrackingResult(
        success: false,
        courier: courier,
        trackingNumber: trackingNumber,
        status: 'error',
        events: [],
        error: 'Server error: ${e.reasonPhrase}',
      );
    } catch (e) {
      print('=== TRACKING CATCH ===');
      print('Error: $e');
      print('=====================');
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
