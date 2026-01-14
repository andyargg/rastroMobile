import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;


  // sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // sign up with email and password
  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // native google sign in using supabase signinwithidtoken
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


    // sign in to supabase with google tokens
    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    return response;
  }

  // sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // returns the currently authenticated supabase user or null if none
  User? get currentUser => _supabase.auth.currentUser;
  String? get accessToken => _supabase.auth.currentSession?.accessToken;
}