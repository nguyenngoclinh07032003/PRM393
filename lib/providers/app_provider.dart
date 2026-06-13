import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/user_service.dart';
import '../services/order_service.dart';
import '../services/favorite_service.dart';

class AppNotifier extends ChangeNotifier {
  // ── Thông tin người dùng ──
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  int _avatarColorIndex = 0;

  static const List<Color> avatarColors = [
    Color(0xFF6A11CB),
    Color(0xFF2575FC),
    Color(0xFFE91E63),
    Color(0xFF00897B),
    Color(0xFFFF6D00),
    Color(0xFF5D4037),
  ];

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  Color get avatarColor => avatarColors[_avatarColorIndex];
  int get avatarColorIndex => _avatarColorIndex;

  // ── Địa chỉ giao hàng ──
  String _recipientName = '';
  String _phone = '';
  String _address = '';

  String get recipientName => _recipientName;
  String get phone => _phone;
  String get address => _address;
  String get fullAddress => '$_recipientName • $_phone\n$_address';

  // ── Đơn hàng ──
  final List<OrderRecord> _orders = [];
  List<OrderRecord> get orders => List.unmodifiable(_orders);

  // ── Yêu thích ──
  final List<Product> _favorites = [];
  List<Product> get favorites => List.unmodifiable(_favorites);

  // ─────────────────────────────────────────────────────────────────────────
  // Tải dữ liệu từ Firestore sau khi đăng nhập
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> loadFromFirestore(List<Product> allProducts) async {
    // Thông tin user
    final user = await UserService.getCurrentUser();
    if (user != null) {
      _userName = user.name;
      _userEmail = user.email;
      _userPhone = user.phone;
      _address = user.address;
      _avatarColorIndex = user.avatarColorIndex;
      _recipientName = user.name;
      _phone = user.phone;
    }

    // Đơn hàng — build CartItem từ tên sản phẩm
    final productMap = {for (final p in allProducts) p.name: p};
    _orders.clear();
    final fetchedOrders = await OrderService.getOrders((rawItems) {
      return rawItems
          .where((m) => productMap.containsKey(m['productName']))
          .map((m) => CartItem(
                product: productMap[m['productName']]!,
                size: m['size'] as String,
                quantity: m['quantity'] as int,
              ))
          .toList();
    });
    _orders.addAll(fetchedOrders);

    // Yêu thích
    final favNames = await FavoriteService.getFavorites();
    _favorites.clear();
    _favorites.addAll(
      favNames.where(productMap.containsKey).map((n) => productMap[n]!),
    );

    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cài đặt thông tin user (gọi khi đăng ký)
  // ─────────────────────────────────────────────────────────────────────────

  void setUserInfo({
    required String name,
    required String email,
    String phone = '',
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    if (_recipientName.isEmpty) _recipientName = name;
    if (_phone.isEmpty) _phone = phone;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cập nhật thông tin user (gọi từ SettingsScreen) — lưu Firestore
  // ─────────────────────────────────────────────────────────────────────────

  Future<bool> updateUserInfo({
    required String name,
    required String email,
    required String phone,
    required String address,
    int? avatarColorIndex,
  }) async {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _recipientName = name;
    _phone = phone;
    _address = address;
    if (avatarColorIndex != null) _avatarColorIndex = avatarColorIndex;
    notifyListeners();

    // Lưu lên Firestore
    return UserService.updateUser(
      name: name,
      email: email,
      phone: phone,
      address: address,
      avatarColorIndex: avatarColorIndex ?? _avatarColorIndex,
    );
  }

  // Cập nhật địa chỉ giao hàng riêng
  Future<void> updateAddress({
    required String name,
    required String phone,
    required String address,
  }) async {
    _recipientName = name;
    _phone = phone;
    _address = address;
    notifyListeners();
    await UserService.updateUser(
      name: _userName,
      email: _userEmail,
      phone: phone,
      address: address,
      avatarColorIndex: _avatarColorIndex,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Đơn hàng — lưu Firestore
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> addOrder(OrderRecord order) async {
    _orders.insert(0, order);
    notifyListeners();
    await OrderService.saveOrder(order);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Yêu thích — đồng bộ Firestore
  // ─────────────────────────────────────────────────────────────────────────

  bool isFavorite(Product product) =>
      _favorites.any((p) => p.name == product.name);

  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product)) {
      _favorites.removeWhere((p) => p.name == product.name);
      notifyListeners();
      await FavoriteService.removeFavorite(product.name);
    } else {
      _favorites.add(product);
      notifyListeners();
      await FavoriteService.addFavorite(product.name);
    }
  }

  // Reset khi đăng xuất
  void clear() {
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _recipientName = '';
    _phone = '';
    _address = '';
    _avatarColorIndex = 0;
    _orders.clear();
    _favorites.clear();
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
