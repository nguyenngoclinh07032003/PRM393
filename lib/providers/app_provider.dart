import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart';

class AppNotifier extends ChangeNotifier {
  // ── Thông tin người dùng ──
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  // Màu avatar đại diện (thay cho ảnh thật khi chưa có image_picker)
  int _avatarColorIndex = 0;

  static const List<Color> avatarColors = [
    Color(0xFF6A11CB), // tím (mặc định)
    Color(0xFF2575FC), // xanh dương
    Color(0xFFE91E63), // hồng
    Color(0xFF00897B), // xanh lá
    Color(0xFFFF6D00), // cam
    Color(0xFF5D4037), // nâu
  ];

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  Color get avatarColor => avatarColors[_avatarColorIndex];
  int get avatarColorIndex => _avatarColorIndex;

  void setUserInfo({
    required String name,
    required String email,
    String phone = '',
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    // Đồng bộ tên và SĐT vào địa chỉ giao hàng nếu chưa có
    if (_recipientName.isEmpty || _recipientName == 'Nguyễn Văn A') {
      _recipientName = name;
    }
    if (_phone.isEmpty || _phone == '0912 345 678') {
      _phone = phone.isNotEmpty ? phone : _phone;
    }
    notifyListeners();
  }

  void updateUserInfo({
    required String name,
    required String email,
    required String phone,
    required String address,
    int? avatarColorIndex,
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _recipientName = name;
    _phone = phone;
    _address = address;
    if (avatarColorIndex != null) {
      _avatarColorIndex = avatarColorIndex;
    }
    notifyListeners();
  }

  // ── Địa chỉ giao hàng ──
  String _recipientName = '';
  String _phone = '';
  String _address = '';

  String get recipientName => _recipientName;
  String get phone => _phone;
  String get address => _address;
  String get fullAddress => '$_recipientName • $_phone\n$_address';

  void updateAddress({
    required String name,
    required String phone,
    required String address,
  }) {
    _recipientName = name;
    _phone = phone;
    _address = address;
    notifyListeners();
  }

  // ── Đơn hàng ──
  final List<OrderRecord> _orders = [];
  List<OrderRecord> get orders => List.unmodifiable(_orders);

  void addOrder(OrderRecord order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  // ── Yêu thích ──
  final List<Product> _favorites = [];
  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Product product) =>
      _favorites.any((p) => p.name == product.name);

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((p) => p.name == product.name);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}

class AppProvider extends InheritedNotifier<AppNotifier> {
  const AppProvider({
    super.key,
    required AppNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider không tìm thấy trong widget tree');
    return provider!.notifier!;
  }
}
