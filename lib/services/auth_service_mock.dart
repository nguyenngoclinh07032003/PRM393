// Mock Auth Service để test app mà không cần Firebase
import 'dart:async';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? userId;

  AuthResult({
    required this.success,
    this.errorMessage,
    this.userId,
  });
}

class AuthServiceMock {
  static final Map<String, Map<String, String>> _users = {};
  static String? _currentUserId;

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_users.containsKey(email)) {
      return AuthResult(
        success: false,
        errorMessage: 'Email đã được sử dụng',
      );
    }

    _users[email] = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'userId': 'user_${_users.length + 1}',
    };

    return AuthResult(
      success: true,
      userId: _users[email]!['userId'],
    );
  }

  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!_users.containsKey(email)) {
      return AuthResult(
        success: false,
        errorMessage: 'Email không tồn tại',
      );
    }

    if (_users[email]!['password'] != password) {
      return AuthResult(
        success: false,
        errorMessage: 'Mật khẩu không đúng',
      );
    }

    _currentUserId = _users[email]!['userId'];
    return AuthResult(
      success: true,
      userId: _currentUserId,
    );
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserId = null;
  }

  static Future<AuthResult> resetPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!_users.containsKey(email)) {
      return AuthResult(
        success: false,
        errorMessage: 'Email không tồn tại',
      );
    }

    return AuthResult(success: true);
  }

  static String? getCurrentUserId() => _currentUserId;
  
  static Map<String, String>? getCurrentUserData() {
    if (_currentUserId == null) return null;
    for (var userData in _users.values) {
      if (userData['userId'] == _currentUserId) {
        return userData;
      }
    }
    return null;
  }
}
