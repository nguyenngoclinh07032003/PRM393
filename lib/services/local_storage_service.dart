import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service quản lý local storage (lưu trữ data trên máy)
/// Dùng cho Mock mode để data không bị mất khi restart app
class LocalStorageService {
  static const String _usersKey = 'mock_users';
  static const String _currentUserKey = 'current_user_email';

  // ═══════════════════════════════════════════════════════════════════════════
  // USERS MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Lưu user mới vào local storage
  static Future<bool> saveUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Lấy danh sách users hiện tại
      final users = await getAllUsers();
      
      // Kiểm tra email đã tồn tại chưa
      if (users.containsKey(email)) {
        return false; // Email đã được sử dụng
      }
      
      // Thêm user mới
      users[email] = {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'address': '123 Đường ABC, Quận 1, TP.HCM',
        'avatarColorIndex': 0,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      // Lưu lại vào storage
      await prefs.setString(_usersKey, jsonEncode(users));
      
      print('💾 LOCAL: User saved - $email');
      return true;
    } catch (e) {
      print('❌ Error saving user: $e');
      return false;
    }
  }

  /// Lấy tất cả users từ local storage
  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson == null || usersJson.isEmpty) {
        return {};
      }
      
      return Map<String, dynamic>.from(jsonDecode(usersJson));
    } catch (e) {
      print('❌ Error getting users: $e');
      return {};
    }
  }

  /// Kiểm tra user có tồn tại không
  static Future<bool> userExists(String email) async {
    final users = await getAllUsers();
    return users.containsKey(email);
  }

  /// Xác thực user (login)
  static Future<Map<String, dynamic>?> authenticateUser({
    required String email,
    required String password,
  }) async {
    final users = await getAllUsers();
    
    if (!users.containsKey(email)) {
      return null; // User không tồn tại
    }
    
    final user = users[email] as Map<String, dynamic>;
    
    if (user['password'] != password) {
      return null; // Sai mật khẩu
    }
    
    // Lưu current user
    await setCurrentUser(email);
    
    print('💾 LOCAL: User authenticated - $email');
    return user;
  }

  /// Lấy thông tin user theo email
  static Future<Map<String, dynamic>?> getUser(String email) async {
    final users = await getAllUsers();
    
    if (!users.containsKey(email)) {
      return null;
    }
    
    return users[email] as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CURRENT USER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Lưu email của user đang đăng nhập
  static Future<void> setCurrentUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, email);
  }

  /// Lấy email của user đang đăng nhập
  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  /// Lấy thông tin đầy đủ của user đang đăng nhập
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final email = await getCurrentUserEmail();
    
    if (email == null) {
      return null;
    }
    
    return await getUser(email);
  }

  /// Đăng xuất (xóa current user)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    print('💾 LOCAL: User logged out');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Xóa tất cả data (reset app)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('💾 LOCAL: All data cleared');
  }

  /// In tất cả users (debug)
  static Future<void> debugPrintAllUsers() async {
    final users = await getAllUsers();
    print('💾 LOCAL: Total users: ${users.length}');
    users.forEach((email, data) {
      print('  - $email: ${data['name']}');
    });
  }

  /// Đếm số lượng users
  static Future<int> getUserCount() async {
    final users = await getAllUsers();
    return users.length;
  }

  /// Update user info
  static Future<bool> updateUser({
    required String email,
    String? name,
    String? phone,
    String? address,
    int? avatarColorIndex,
  }) async {
    try {
      final users = await getAllUsers();
      
      if (!users.containsKey(email)) {
        return false;
      }
      
      final user = users[email] as Map<String, dynamic>;
      
      if (name != null) user['name'] = name;
      if (phone != null) user['phone'] = phone;
      if (address != null) user['address'] = address;
      if (avatarColorIndex != null) user['avatarColorIndex'] = avatarColorIndex;
      
      users[email] = user;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usersKey, jsonEncode(users));
      
      print('💾 LOCAL: User updated - $email');
      return true;
    } catch (e) {
      print('❌ Error updating user: $e');
      return false;
    }
  }
}
