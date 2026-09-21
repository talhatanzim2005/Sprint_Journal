import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a user profile in Firestore.
class UserModel {
  final String uid;
  final String username;
  final String email;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.createdAt,
  });

  /// Factory constructor to create a UserModel from Firestore DocumentSnapshot.
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: doc.id,
      username: data['username'] as String? ?? '',
      email: data['email'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts the model to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

/// Service to handle Firestore operations for user profiles.
class UserService {
  final FirebaseFirestore _firestore;

  static final UserService instance = UserService._internal();

  UserService._internal() : _firestore = FirebaseFirestore.instance;

  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

  /// Creates or updates a user profile in the 'users' collection.
  Future<void> saveUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    await _usersCollection.doc(uid).set({
      'username': username.trim(),
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Fetches a user profile by UID.
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromDocument(doc);
  }

  /// Stream of user profile updates for real-time changes.
  Stream<UserModel?> streamUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromDocument(doc);
    });
  }

  /// Updates specific fields of the user profile.
  Future<void> updateUserProfile({
    required String uid,
    String? username,
    String? email,
  }) async {
    final Map<String, dynamic> data = {};
    if (username != null) data['username'] = username.trim();
    if (email != null) data['email'] = email.trim();

    if (data.isNotEmpty) {
      await _usersCollection.doc(uid).update(data);
    }
  }
}
