import 'package:cloud_firestore/cloud_firestore.dart';

/// Minimal user service for Firestore database operations.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final UserService instance = UserService._internal();
  UserService._internal();

  /// Saves or updates basic user profile info in Firestore ('users' collection).
  Future<void> saveUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username.trim(),
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

