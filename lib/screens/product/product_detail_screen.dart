import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../providers/app_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  int selectedSize = 0;
  int quantity = 1;

  void _addToCart() {
    CartProvider.of(context).addItem(widget.product, sizes[selectedSize], quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm ${widget.product.name} vào giỏ hàng'), duration: const Duration(seconds: 2)),
    );
  }

  void _buyNow() {
    CartProvider.of(context).addItem(widget.product, sizes[selectedSize], quantity);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final app = AppProvider.of(context);
    final isFav = app.isFavorite(product);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.black),
            onPressed: () => app.toggleFavorite(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              color: product.color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(product.icon, size: 120, color: primaryColor),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == 0 ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: i == 0 ? primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 6),
                      Text('(120 đánh giá)', style: TextStyle(color: Color(0xFF888888))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(formatPrice(product.price), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(width: 10),
                      Text(formatPrice((product.price * 1.3).toInt()), style: const TextStyle(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Text('-30%', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Kích thước', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(sizes.length, (index) {
                      final selected = selectedSize == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = index),
                        child: Container(
                          width: 40, height: 40,
                          margin: const EdgeInsets.only(right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(sizes[index], style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Text('Mô tả sản phẩm', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Sản phẩm chất lượng cao, thiết kế hiện đại, phù hợp sử dụng hằng ngày. Chất liệu bền đẹp và mang lại trải nghiệm thoải mái.', style: TextStyle(color: Color(0xFF888888), height: 1.5)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => quantity++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 54, height: 50,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _buyNow,
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Mua ngay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
