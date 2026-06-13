import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Lưu đơn hàng mới lên Firestore
  static Future<bool> saveOrder(OrderRecord order) async {
    if (_uid == null) return false;
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('orders')
          .doc(order.orderId)
          .set({
        'orderId': order.orderId,
        'totalPrice': order.totalPrice,
        'shippingFee': order.shippingFee,
        'address': order.address,
        'paymentMethod': order.paymentMethod,
        'createdAt': order.createdAt.toIso8601String(),
        'items': order.items
            .map((item) => {
                  'productName': item.product.name,
                  'productPrice': item.product.price,
                  'size': item.size,
                  'quantity': item.quantity,
                })
            .toList(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Lấy danh sách đơn hàng từ Firestore
  static Future<List<OrderRecord>> getOrders(List<CartItem> Function(List<Map<String, dynamic>>) itemBuilder) async {
    if (_uid == null) return [];
    try {
      final snap = await _db
          .collection('users')
          .doc(_uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map((doc) {
        final data = doc.data();
        final rawItems = List<Map<String, dynamic>>.from(data['items'] as List);
        return OrderRecord(
          orderId: data['orderId'] as String,
          items: itemBuilder(rawItems),
          totalPrice: data['totalPrice'] as int,
          shippingFee: data['shippingFee'] as int,
          address: data['address'] as String,
          paymentMethod: data['paymentMethod'] as String,
          createdAt: DateTime.parse(data['createdAt'] as String),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
