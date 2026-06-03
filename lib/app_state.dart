import 'package:flutter/material.dart';
import 'product.dart';
import 'cart_provider.dart';

// ─── Model: Đơn hàng đã đặt ──────────────────────────────────────────────────

class OrderRecord {
  final String orderId;
  final List<CartItem> items;
  final int totalPrice;
  final int shippingFee;
  final String address;
  final String paymentMethod;
  final DateTime createdAt;

  OrderRecord({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.shippingFee,
    required this.address,
    required this.paymentMethod,
    required this.createdAt,
  });

  int get grandTotal => totalPrice + shippingFee;
}

// ─── AppNotifier: quản lý orders, favorites, address ─────────────────────────

class AppNotifier extends ChangeNotifier {
  // ── Địa chỉ giao hàng ──
  String _recipientName = 'Nguyễn Văn A';
  String _phone = '0912 345 678';
  String _address = '123 Đường ABC, Quận 1, TP.HCM';

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
    _orders.insert(0, order); // mới nhất lên đầu
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

// ─── AppProvider: InheritedNotifier ──────────────────────────────────────────

class AppProvider extends InheritedNotifier<AppNotifier> {
  const AppProvider({
    super.key,
    required AppNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider không tìm thấy trong widget tree');
    return provider!.notifier!;
  }
}
