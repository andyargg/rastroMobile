import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // send otp code via email
  Future<void> signInWithOtp(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      shouldCreateUser: true,
    );
  }

  // verify otp code and complete authentication
  Future<AuthResponse> verifyOtp(String email, String token) async {
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
    return response;
  }

  // google sign in using supabase signinwithidtoken
  Future<AuthResponse> nativeGoogleSignIn() async {
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
    

    final authorization =
      await googleUser.authorizationClient.authorizationForScopes(scopes) ??
      await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }

    // block if the email is already registered with a different provider
    final googleEmail = _emailFromIdToken(idToken);
    final provider = await getEmailProvider(googleEmail);
    if (provider != null && provider != 'google') {
      throw AuthException(
        'Este email ya está registrado con código de verificación. '
        'Usá ese método para iniciar sesión.',
      );
    }

    // sign in to supabase with google tokens
    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    return response;
  }

  // send otp to new email for email change
  Future<void> sendEmailChangeOtp(String newEmail) async {
    await _supabase.auth.updateUser(UserAttributes(email: newEmail));
  }

  // verify otp and complete email change
  Future<AuthResponse> verifyEmailChange(String email, String token) async {
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.emailChange,
    );
    return response;
  }

  // sign out
  Future<void> signOut() async {                                                                                                                                                                              
    await _supabase.auth.signOut(scope: SignOutScope.local);
  }

  String? getCurrentEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // returns the currently authenticated supabase user or null if none
  User? get currentUser => _supabase.auth.currentUser;
  String? get accessToken => _supabase.auth.currentSession?.accessToken;

  // check if user logged in with google
  bool get isGoogleUser => currentUser?.appMetadata['provider'] == 'google';

  // return the auth provider ('email', 'google', etc.) for a given email, or null
  Future<String?> getEmailProvider(String email) async {
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