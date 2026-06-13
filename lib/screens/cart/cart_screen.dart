import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import '../../widgets/common_widgets.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final bool showBackButton;
  const CartScreen({super.key, this.showBackButton = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: normalAnimation,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final items = cart.items;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Giỏ hàng${items.isNotEmpty ? ' (${cart.totalItems})' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: items.isNotEmpty
            ? [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xóa tất cả?'),
                        content: const Text(
                          'Bạn có chắc muốn xóa tất cả sản phẩm trong giỏ hàng?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              cart.clearCart();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Xóa tất cả',
                              style: TextStyle(color: errorColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Xóa tất cả',
                    style: TextStyle(color: errorColor),
                  ),
                ),
              ]
            : null,
      ),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Giỏ hàng trống',
              subtitle: 'Hãy thêm sản phẩm yêu thích vào giỏ hàng nhé!',
            )
          : FadeTransition(
              opacity: _controller,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...List.generate(
                    items.length,
                    (i) => _buildCartItem(context, cart, i),
                  ),
                  const SizedBox(height: 8),
                  _promoCard(),
                  const SizedBox(height: 16),
                  _totalCard(cart),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [cardShadow],
              ),
              child: SafeArea(
                child: GradientButton(
                  text: 'Thanh toán (${formatPrice(cart.totalPrice + cart.shippingFee)})',
                  height: 54,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartNotifier cart, int index) {
    final item = cart.items[index];

    return Dismissible(
      key: Key('cart_item_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        cart.removeItem(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa ${item.product.name}'),
            action: SnackBarAction(
              label: 'Hoàn tác',
              onPressed: () {
                // TODO: Implement undo functionality
              },
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.red, Colors.redAccent],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text(
              'Xóa',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: item.product.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.product.icon,
                color: primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(width: 14),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Size: ${item.size}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: textGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatPrice(item.product.price),
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ScaleButton(
                        onPressed: () => cart.decreaseQuantity(index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.remove,
                            size: 18,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      ScaleButton(
                        onPressed: () => cart.increaseQuantity(index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ScaleButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xóa sản phẩm?'),
                        content: Text(
                          'Bạn có chắc muốn xóa ${item.product.name} khỏi giỏ hàng?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              cart.removeItem(index);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Xóa',
                              style: TextStyle(color: errorColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: errorColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoCard() {
    return ScaleButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nhập mã giảm giá',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nhập mã...',
                    prefixIcon: const Icon(Icons.confirmation_num_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GradientButton(
                  text: 'Áp dụng',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mã giảm giá không hợp lệ'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.confirmation_num_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mã giảm giá',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Áp dụng mã để được giảm giá',
                    style: TextStyle(fontSize: 12, color: textGray),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: textGray),
          ],
        ),
      ),
    );
  }

  Widget _totalCard(CartNotifier cart) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng đơn hàng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _totalRow('Tạm tính', formatPrice(cart.totalPrice)),
          const SizedBox(height: 10),
          _totalRow('Phí vận chuyển', formatPrice(cart.shippingFee)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _totalRow(
            'Tổng cộng',
            formatPrice(cart.totalPrice + cart.shippingFee),
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String left, String right, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: bold ? textDark : textGray,
            fontSize: bold ? 16 : 14,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            color: bold ? primaryColor : textDark,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            fontSize: bold ? 18 : 15,
          ),
        ),
      ],
    );
  }
}
