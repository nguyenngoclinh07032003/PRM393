import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../providers/app_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import '../checkout/checkout_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = AppProvider.of(context).favorites;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Yêu thích (${favorites.length})'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 72, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Chưa có sản phẩm yêu thích', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (_, i) => _FavoriteRow(product: favorites[i]),
            ),
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  final Product product;
  const _FavoriteRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    final cart = CartProvider.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(color: product.color, borderRadius: BorderRadius.circular(10)),
                child: Icon(product.icon, size: 48, color: primaryColor),
              ),
              Positioned(
                top: 4, right: 4,
                child: GestureDetector(
                  onTap: () => app.toggleFavorite(product),
                  child: Container(
                    width: 24, height: 24,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(Icons.favorite, color: Colors.red, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(formatPrice(product.price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(width: 8),
                    Text(formatPrice((product.price * 1.3).toInt()), style: const TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity, height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.addItem(product, 'M', 1);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Thanh toán', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
