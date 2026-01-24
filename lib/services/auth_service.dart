import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // send otp code via sms
  Future<void> signInWithOtp(String phone) async {
    await _supabase.auth.signInWithOtp(
      phone: phone,
      shouldCreateUser: true,
    );
  }

  // verify otp code and complete authentication
  Future<AuthResponse> verifyOtp(String phone, String token) async {
    final response = await _supabase.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
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


    // sign in to supabase with google tokens
    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    return response;
  }

  // send otp to new phone for phone change
  Future<void> sendPhoneChangeOtp(String newPhone) async {
    await _supabase.auth.updateUser(UserAttributes(phone: newPhone));
  }

  // verify otp and complete phone change
  Future<AuthResponse> verifyPhoneChange(String phone, String token) async {
    final response = await _supabase.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.phoneChange,
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
}