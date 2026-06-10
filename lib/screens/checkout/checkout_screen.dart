import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../providers/app_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;
  bool _isLoading = false;

  final _paymentLabels = ['Ví điện tử', 'Thẻ tín dụng / ghi nợ', 'Tiền mặt khi nhận hàng'];
  final _paymentIcons = [Icons.account_balance_wallet_outlined, Icons.credit_card, Icons.money];

  Future<void> _handleCheckout(CartNotifier cart, AppNotifier app) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final order = OrderRecord(
      orderId: '#DH${DateTime.now().millisecondsSinceEpoch % 100000}',
      items: List.from(cart.items),
      totalPrice: cart.totalPrice,
      shippingFee: cart.shippingFee,
      address: app.fullAddress,
      paymentMethod: _paymentLabels[_selectedPayment],
      createdAt: DateTime.now(),
    );
    app.addOrder(order);
    cart.clearCart();
    setState(() => _isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final app = AppProvider.of(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thanh toán'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Địa chỉ giao hàng'),
          _card(child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.recipientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(app.phone, style: const TextStyle(color: Color(0xFF888888), fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(app.address, style: const TextStyle(color: Color(0xFF888888), fontSize: 13)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/address'),
                child: const Text('Sửa', style: TextStyle(color: primaryColor)),
              ),
            ],
          )),
          const SizedBox(height: 16),

          _sectionTitle('Sản phẩm (${cart.totalItems})'),
          ...cart.items.map((item) => _card(
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: item.product.color, borderRadius: BorderRadius.circular(8)),
                  child: Icon(item.product.icon, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Size: ${item.size}  ×${item.quantity}', style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
                    ],
                  ),
                ),
                Text(formatPrice(item.product.price * item.quantity), style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          )),
          const SizedBox(height: 16),

          _sectionTitle('Phương thức thanh toán'),
          _card(
            child: Column(
              children: List.generate(_paymentLabels.length, (i) {
                final selected = _selectedPayment == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPayment = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(border: i < _paymentLabels.length - 1 ? const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))) : null),
                    child: Row(
                      children: [
                        Icon(_paymentIcons[i], color: selected ? primaryColor : Colors.grey, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_paymentLabels[i], style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? primaryColor : Colors.black))),
                        Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? primaryColor : Colors.grey, size: 20),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          _sectionTitle('Chi tiết thanh toán'),
          _card(
            child: Column(
              children: [
                _row('Tạm tính', formatPrice(cart.totalPrice)),
                const SizedBox(height: 8),
                _row('Phí vận chuyển', formatPrice(cart.shippingFee)),
                const Divider(height: 20),
                _row('Tổng cộng', formatPrice(cart.totalPrice + cart.shippingFee), bold: true),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _handleCheckout(cart, app),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: _isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Text('Xác nhận thanh toán  •  ${formatPrice(cart.totalPrice + cart.shippingFee)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));
  Widget _card({required Widget child}) => Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 4), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: child);
  Widget _row(String left, String right, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(left, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text(right, style: TextStyle(color: bold ? primaryColor : Colors.black, fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14)),
    ],
  );
}
