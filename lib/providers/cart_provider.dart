import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (sum, e) => sum + e.quantity);
  int get totalPrice => _items.fold(0, (sum, e) => sum + e.product.price * e.quantity);
  int get shippingFee => _items.isEmpty ? 0 : 30000;

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

class CartProvider extends InheritedNotifier<CartNotifier> {
  const CartProvider({
    super.key,
    required CartNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CartNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider không tìm thấy trong widget tree');
    return provider!.notifier!;
  }
}
