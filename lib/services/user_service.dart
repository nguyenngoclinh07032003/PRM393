import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Model dữ liệu user từ Firestore
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final int avatarColorIndex;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarColorIndex,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      avatarColorIndex: map['avatarColorIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'avatarColorIndex': avatarColorIndex,
  };
}

class UserService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Lấy thông tin user hiện tại từ Firestore
  static Future<UserModel?> getCurrentUser() async {
    if (_uid == null) return null;
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  /// Cập nhật thông tin user
  static Future<bool> updateUser({
    required String name,
    required String email,
    required String phone,
    required String address,
    required int avatarColorIndex,
  }) async {
    if (_uid == null) return false;
    try {
      await _db.collection('users').doc(_uid).update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'avatarColorIndex': avatarColorIndex,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
