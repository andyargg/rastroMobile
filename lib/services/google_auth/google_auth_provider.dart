import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract interface for Google authentication.
/// Platform-specific implementations handle the actual sign-in flow.
abstract class GoogleAuthProvider {
  /// Performs Google sign-in and returns the auth response.
  /// Returns null for redirect-based flows (web) where the response
  /// comes after page reload.
  Future<AuthResponse?> signIn();

  /// Whether this provider uses a redirect flow (true for web).
  /// When true, signIn() returns null and auth state is detected after redirect.
  bool get isRedirectFlow;
}
