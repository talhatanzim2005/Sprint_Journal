import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_service.dart';

/// Simplified Authentication Service for SprintJournal.
/// Encapsulates Email/Password and Google Authentication.
class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  // Singleton instance
  static final AuthService instance = AuthService._internal();

  AuthService._internal()
    : _auth = FirebaseAuth.instance,
      _googleSignIn = GoogleSignIn();

  /// Constructor for dependency injection and testing.
  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Gets the currently authenticated Firebase user.
  User? get currentUser => _auth.currentUser;

  /// Stream of user authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Email and Password.
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign up with Email and Password (optional display name / username).
  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      final username = name?.trim() ?? email.split('@').first;

      if (name != null && name.trim().isNotEmpty) {
        await user?.updateDisplayName(name.trim());
      }

      if (user != null) {
        await UserService.instance.saveUserProfile(
          uid: user.uid,
          username: username,
          email: user.email ?? email.trim(),
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with Google account.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await UserService.instance.saveUserProfile(
          uid: user.uid,
          username: user.displayName ?? user.email?.split('@').first ?? 'User',
          email: user.email ?? '',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Sign out from both Firebase and Google.
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  /// Formats Firebase Auth exception codes to clean user-friendly messages.
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }
}
