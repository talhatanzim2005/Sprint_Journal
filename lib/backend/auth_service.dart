// Empty auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Get current logged-in user
  User? get currentUser => _auth.currentUser;

  // 2. Sign In
  Future<UserCredential> signIn(String email, String password) async {
    //SignIn function takes email and password and Returns a usercredential inside Future when finished
    return await _auth.signInWithEmailAndPassword( //waits for Firebase authentication
      email: email.trim(),
      password: password,
    );
  }

  // 3. Sign Up & Save to Firestore
  Future<UserCredential> signUp(String email, String password, String username) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    
    // Save user to Firestore users collection if new
    if (cred.user != null) {
      await UserService.instance.saveUserProfile(
        uid: cred.user!.uid,
        username: username,
        email: email,
      );
    }
    return cred;
  }

  // 4. Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
