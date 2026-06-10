import 'cart_item.dart';

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
