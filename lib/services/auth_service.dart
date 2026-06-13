import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';

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

  // Mock data for testing
  static final Map<String, Map<String, dynamic>> _mockUsers = {};
  static String? _mockCurrentUserId;
  static String? _mockCurrentUserName;

  /// User đang đăng nhập
  static User? get currentUser => USE_REAL_FIREBASE ? _auth.currentUser : null;
  static Stream<User?> get authStateChanges => USE_REAL_FIREBASE 
      ? _auth.authStateChanges() 
      : Stream.value(null);

  // ─── Đăng ký ─────────────────────────────────────────────────────────────

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (!USE_REAL_FIREBASE) {
      return _mockRegister(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;
      await user.updateDisplayName(name.trim());

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
    if (!USE_REAL_FIREBASE) {
      return _mockLogin(email: email, password: password);
    }

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
    if (!USE_REAL_FIREBASE) {
      _mockCurrentUserId = null;
      _mockCurrentUserName = null;
      print('✅ MOCK: User logged out');
      return;
    }
    await _auth.signOut();
  }

  // ─── Reset mật khẩu qua email ────────────────────────────────────────────

  static Future<AuthResult> sendPasswordResetEmail(String email) async {
    if (!USE_REAL_FIREBASE) {
      return _mockResetPassword(email: email);
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, errorMessage: _authError(e.code));
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Đã có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOCK METHODS (for testing without Firebase)
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<AuthResult> _mockRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_mockUsers.containsKey(email)) {
      return const AuthResult(
        success: false,
        errorMessage: 'Email này đã được sử dụng',
      );
    }

    final userId = 'mock_user_${_mockUsers.length + 1}';
    _mockUsers[email] = {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'avatarColorIndex': 0,
    };

    print('✅ MOCK: User registered - $email (${_mockUsers.length} total users)');
    return const AuthResult(success: true);
  }

  static Future<AuthResult> _mockLogin({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!_mockUsers.containsKey(email)) {
      return const AuthResult(
        success: false,
        errorMessage: 'Không tìm thấy tài khoản với email này',
      );
    }

    if (_mockUsers[email]!['password'] != password) {
      return const AuthResult(
        success: false,
        errorMessage: 'Mật khẩu không đúng',
      );
    }

    _mockCurrentUserId = _mockUsers[email]!['userId'] as String;
    _mockCurrentUserName = _mockUsers[email]!['name'] as String;
    print('✅ MOCK: User logged in - $email (ID: $_mockCurrentUserId)');
    return const AuthResult(success: true);
  }

  static Future<AuthResult> _mockResetPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!_mockUsers.containsKey(email)) {
      return const AuthResult(
        success: false,
        errorMessage: 'Không tìm thấy tài khoản với email này',
      );
    }

    print('✅ MOCK: Password reset email sent - $email');
    return const AuthResult(success: true);
  }

  static Map<String, dynamic>? getMockUserData(String email) {
    return _mockUsers[email];
  }

  static String? getMockCurrentUserId() => _mockCurrentUserId;
  static String? getMockCurrentUserName() => _mockCurrentUserName;

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
