import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rastro/services/google_auth/google_auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Google authentication implementation for mobile platforms (Android/iOS).
/// Uses the google_sign_in package with native OAuth flow.
class MobileGoogleAuth implements GoogleAuthProvider {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  bool get isRedirectFlow => false;

  @override
  Future<AuthResponse?> signIn() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    final androidClientId = dotenv.env['GOOGLE_ANDROID_CLIENT_ID'];

    final scopes = ['email', 'profile'];
    final googleSignIn = GoogleSignIn.instance;

    if (webClientId == null) {
      throw Exception('GOOGLE_WEB_CLIENT_ID not found in environment variables');
    }

    await googleSignIn.initialize(
      clientId: androidClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.authenticate();

    await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    return response;
  }
}
