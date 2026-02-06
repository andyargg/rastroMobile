import 'package:get_it/get_it.dart';
import 'package:rastro/services/google_auth/google_auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleAuthProvider _googleAuth = GetIt.instance<GoogleAuthProvider>();

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

  // Google sign in - delegates to platform-specific provider
  Future<AuthResponse?> googleSignIn() async {
    return await _googleAuth.signIn();
  }

  // Whether Google auth uses redirect flow (true for web)
  bool get isGoogleRedirectFlow => _googleAuth.isRedirectFlow;

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
}