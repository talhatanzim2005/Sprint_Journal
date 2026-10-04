import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Minimal user service for Firestore database operations and profile state.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final UserService instance = UserService._internal();
  UserService._internal();

  // Active user profile information
  String firstName = 'Rabeta';
  String lastName = 'Zannat';
  String email = 'rabeta@gmail.com';
  String aboutMe = 'CSE Student';
  String journalStarted = 'August 2026';
  int journalEntries = 0;

  String get fullName {
    final full = '$firstName $lastName'.trim();
    return full.isNotEmpty ? full : 'User';
  }

  void setUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? journalStarted,
    String? aboutMe,
  }) {
    this.firstName = firstName.trim();
    this.lastName = lastName.trim();
    this.email = email.trim();
    if (journalStarted != null && journalStarted.trim().isNotEmpty) {
      this.journalStarted = journalStarted.trim();
    }
    if (aboutMe != null && aboutMe.trim().isNotEmpty) {
      this.aboutMe = aboutMe.trim();
    }
  }

  void updateJournalStarted(String value) {
    journalStarted = value.trim();
  }

  /// Saves or updates basic user profile info in Firestore ('users' collection).
  Future<void> saveUserProfile({
    required String uid,
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? journalStarted,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'username': username.trim(),
        'email': email.trim(),
        if (firstName != null) 'firstName': firstName.trim(),
        if (lastName != null) 'lastName': lastName.trim(),
        if (journalStarted != null) 'journalStarted': journalStarted.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving user profile to Firestore: $e');
    }
  }
}
