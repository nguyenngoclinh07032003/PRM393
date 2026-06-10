import 'package:flutter/material.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final bool showBackButton;
  const CartScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final items = cart.items;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Giỏ hàng (${cart.totalItems})'),
        centerTitle: true,
        leading: showBackButton
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))
            : null,
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Giỏ hàng trống', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...List.generate(items.length, (i) => _buildCartItem(context, cart, i)),
                _promoCard(),
                _totalCard(cart),
              ],
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Thanh toán', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartNotifier cart, int index) {
    final item = cart.items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: item.product.color, borderRadius: BorderRadius.circular(10)),
            child: Icon(item.product.icon, color: primaryColor, size: 36),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Size: ${item.size}', style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                const SizedBox(height: 6),
                Text(formatPrice(item.product.price), style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(onTap: () => cart.decreaseQuantity(index), child: const Icon(Icons.remove_circle_outline, size: 20)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text('${item.quantity}')),
                  GestureDetector(onTap: () => cart.increaseQuantity(index), child: const Icon(Icons.add_circle_outline, size: 20)),
                ],
              ),
              IconButton(onPressed: () => cart.removeItem(index), icon: const Icon(Icons.delete_outline, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _promoCard() => Container(
    margin: const EdgeInsets.only(top: 6, bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: const Row(
      children: [
        Icon(Icons.confirmation_num_outlined, color: primaryColor),
        SizedBox(width: 10),
        Expanded(child: Text('Mã giảm giá')),
        Text('Áp dụng ›', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _totalCard(CartNotifier cart) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        _totalRow('Tạm tính', formatPrice(cart.totalPrice)),
        const SizedBox(height: 8),
        _totalRow('Phí vận chuyển', formatPrice(cart.shippingFee)),
        const Divider(height: 24),
        _totalRow('Tổng cộng', formatPrice(cart.totalPrice + cart.shippingFee), bold: true),
      ],
    ),
  );

  Widget _totalRow(String left, String right, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(left, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text(right, style: TextStyle(color: bold ? primaryColor : Colors.black, fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 17 : 14)),
    ],
  );
}
