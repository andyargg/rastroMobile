import 'dart:convert';

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

    // block if the email is already registered with a different provider
    final googleEmail = _emailFromIdToken(idToken);
    final provider = await _getEmailProvider(googleEmail);
    if (provider != null && provider != 'google') {
      throw AuthException(
        'Este email ya está registrado con código de verificación. '
        'Usá ese método para iniciar sesión.',
      );
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    return response;
  }

  // return the auth provider ('email', 'google', etc.) for a given email, or null
  Future<String?> _getEmailProvider(String email) async {
    try {
      final result = await _supabase.rpc(
        'get_provider_for_email',
        params: {'lookup_email': email},
      );
      return result as String?;
    } catch (_) {
      // fail open: if the rpc is unavailable, allow sign-in
      return null;
    }
  }

  // decode email claim from a google id token (jwt)
  String _emailFromIdToken(String idToken) {
    final parts = idToken.split('.');
    final normalized = base64Url.normalize(parts[1]);
    final payload = utf8.decode(base64Url.decode(normalized));
    final map = jsonDecode(payload) as Map<String, dynamic>;
    return map['email'] as String;
  }
}
