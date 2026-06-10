import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../utils/format.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderRecord order;
  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120, height: 120,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEEF7EE)),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
              ),
              const SizedBox(height: 28),
              const Text('Đặt hàng thành công!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
              const SizedBox(height: 10),
              const Text('Cảm ơn bạn đã mua hàng.\nĐơn hàng của bạn đang được xử lý.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Color(0xFF888888), height: 1.6)),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    _infoRow(Icons.confirmation_number_outlined, 'Mã đơn hàng', order.orderId),
                    const Divider(height: 20),
                    _infoRow(Icons.local_shipping_outlined, 'Dự kiến giao hàng', '3 - 5 ngày làm việc'),
                    const Divider(height: 20),
                    _infoRow(Icons.payment_outlined, 'Thanh toán', order.paymentMethod),
                    const Divider(height: 20),
                    _infoRow(Icons.location_on_outlined, 'Địa chỉ', order.address),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Về trang chủ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Xem đơn hàng', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: primaryColor, size: 20),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    ],
  );
}
