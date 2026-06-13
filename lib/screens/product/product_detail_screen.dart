import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/product.dart';
import '../../providers/app_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import '../../widgets/common_widgets.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  int selectedSize = 0;
  int quantity = 1;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    HapticFeedback.mediumImpact();
    CartProvider.of(context)
        .addItem(widget.product, sizes[selectedSize], quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Đã thêm ${widget.product.name} vào giỏ hàng'),
            ),
          ],
        ),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _buyNow() {
    HapticFeedback.mediumImpact();
    CartProvider.of(context)
        .addItem(widget.product, sizes[selectedSize], quantity);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
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
        leading: ScaleButton(
          onPressed: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [lightShadow],
            ),
            child: const Icon(Icons.arrow_back, color: textDark),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ScaleButton(
              onPressed: () => app.toggleFavorite(product),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [lightShadow],
                ),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : textDark,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Hero(
              tag: 'product_${product.name}',
              child: Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: product.color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(product.icon, size: 140, color: primaryColor),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (i) => AnimatedContainer(
                          duration: quickAnimation,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == 0 ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == 0 ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Rating
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  '4.8',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '(120 đánh giá)',
                            style: TextStyle(color: textGray),
                          ),
                          const Spacer(),
                          Icon(Icons.local_shipping_outlined,
                              color: successColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Miễn phí ship',
                            style: TextStyle(
                              color: successColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Price
                      AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Giá bán',
                                  style: TextStyle(
                                    color: textGray,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatPrice(product.price),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatPrice((product.price * 1.3).toInt()),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textGray,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [errorColor, Colors.orange],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '🔥 -30%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Size Selection
                      const Text(
                        'Kích thước',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(sizes.length, (index) {
                          final selected = selectedSize == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ScaleButton(
                              onPressed: () =>
                                  setState(() => selectedSize = index),
                              child: AnimatedContainer(
                                duration: quickAnimation,
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: selected
                                      ? const LinearGradient(
                                          colors: [primaryColor, secondaryColor],
                                        )
                                      : null,
                                  color: selected ? null : cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? Colors.transparent
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  boxShadow: selected ? [lightShadow] : [],
                                ),
                                child: Text(
                                  sizes[index],
                                  style: TextStyle(
                                    color: selected ? Colors.white : textDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        'Mô tả sản phẩm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Sản phẩm chất lượng cao, thiết kế hiện đại, phù hợp sử dụng hằng ngày. Chất liệu bền đẹp và mang lại trải nghiệm thoải mái. Được nhiều khách hàng tin tưởng và lựa chọn.',
                          style: TextStyle(
                            color: textGray,
                            height: 1.6,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quantity
                      AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Số lượng:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ScaleButton(
                                    onPressed: quantity > 1
                                        ? () => setState(() => quantity--)
                                        : () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.remove,
                                        color: quantity > 1
                                            ? primaryColor
                                            : textGray,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  ScaleButton(
                                    onPressed: () => setState(() => quantity++),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [cardShadow],
        ),
        child: SafeArea(
          child: Row(
            children: [
              ScaleButton(
                onPressed: _addToCart,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  text: 'Mua ngay',
                  height: 54,
                  onPressed: _buyNow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
