import 'package:flutter/material.dart';
import 'product.dart';

/// Một item trong giỏ hàng
class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    this.quantity = 1,
  });
}

/// State giỏ hàng — dùng ChangeNotifier để notify toàn app
class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, e) => sum + e.quantity);

  int get totalPrice =>
      _items.fold(0, (sum, e) => sum + e.product.price * e.quantity);

  int get shippingFee => _items.isEmpty ? 0 : 30000;

  /// Thêm sản phẩm vào giỏ. Nếu cùng sản phẩm + size → tăng số lượng.
  void addItem(Product product, String size, int quantity) {
    final index = _items.indexWhere(
      (e) => e.product.name == product.name && e.size == size,
    );
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, size: size, quantity: quantity));
    }
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

/// InheritedNotifier để truyền CartNotifier xuống cây widget
class CartProvider extends InheritedNotifier<CartNotifier> {
  const CartProvider({
    super.key,
    required CartNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CartNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider không tìm thấy trong widget tree');
    return provider!.notifier!;
  }
}
