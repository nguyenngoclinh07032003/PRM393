import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static DocumentReference? get _doc =>
      _uid != null ? _db.collection('users').doc(_uid) : null;

  /// Lấy danh sách tên sản phẩm yêu thích
  static Future<List<String>> getFavorites() async {
    if (_doc == null) return [];
    try {
      final snap = await _doc!.get();
      final data = (snap as dynamic).data() as Map<String, dynamic>?;
      if (data == null) return [];
      return List<String>.from(data['favorites'] as List? ?? []);
    } catch (_) {
      return [];
    }
  }

  /// Thêm sản phẩm vào yêu thích
  static Future<void> addFavorite(String productName) async {
    if (_doc == null) return;
    try {
      await _doc!.update({
        'favorites': FieldValue.arrayUnion([productName]),
      });
    } catch (_) {}
  }

  /// Xoá sản phẩm khỏi yêu thích
  static Future<void> removeFavorite(String productName) async {
    if (_doc == null) return;
    try {
      await _doc!.update({
        'favorites': FieldValue.arrayRemove([productName]),
      });
    } catch (_) {}
  }
}
