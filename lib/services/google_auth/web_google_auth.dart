import 'package:rastro/services/google_auth/google_auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Google authentication implementation for web platform.
/// Uses Supabase OAuth redirect flow.
class WebGoogleAuth implements GoogleAuthProvider {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  bool get isRedirectFlow => true;

  @override
  Future<AuthResponse?> signIn() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: Uri.base.origin,
      queryParams: {
        'prompt': 'select_account',
      },
    );
    // OAuth redirects the page, so we don't return a response here.
    // The auth state will be detected after the redirect via AuthGuard.
    return null;
  }
}
