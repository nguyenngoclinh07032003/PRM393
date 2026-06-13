import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Kết quả trả về từ các thao tác auth
class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  const AuthResult({required this.success, this.errorMessage, this.user});
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// User đang đăng nhập
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Đăng ký ─────────────────────────────────────────────────────────────

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      // Cập nhật display name
      await user.updateDisplayName(name.trim());

      // Lưu thông tin user vào Firestore
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'address': '',
        'avatarColorIndex': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return AuthResult(success: true, user: user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, errorMessage: _authError(e.code));
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Đã có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  // ─── Đăng nhập ───────────────────────────────────────────────────────────

  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult(success: true, user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, errorMessage: _authError(e.code));
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Đã có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  // ─── Đăng xuất ───────────────────────────────────────────────────────────

  static Future<void> logout() async {
    await _auth.signOut();
  }

  // ─── Reset mật khẩu qua email ────────────────────────────────────────────

  static Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, errorMessage: _authError(e.code));
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Đã có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  // ─── Thông báo lỗi tiếng Việt ────────────────────────────────────────────

  static String _authError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu, cần ít nhất 6 ký tự';
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa';
      case 'too-many-requests':
        return 'Quá nhiều lần thử. Vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra internet';
      default:
        return 'Đã có lỗi xảy ra ($code)';
    }
  }
}
