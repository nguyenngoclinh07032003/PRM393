import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final IconData icon;
  final Color color;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.icon,
    required this.color,
    this.category = 'Tất cả',
  });
}

final List<Product> products = [
  Product(
    name: 'Móc phơi đồ',
    price: 59000,
    icon: Icons.checkroom,
    color: Colors.blue.shade100,
    category: 'Phụ kiện',
  ),
  Product(
    name: 'Tai nghe Bluetooth',
    price: 590000,
    icon: Icons.headphones,
    color: Colors.purple.shade100,
    category: 'Điện tử',
  ),
  Product(
    name: 'Đồng hồ thông minh',
    price: 1290000,
    icon: Icons.watch,
    color: Colors.orange.shade100,
    category: 'Điện tử',
  ),
  Product(
    name: 'Túi xách thời trang',
    price: 450000,
    icon: Icons.shopping_bag,
    color: Colors.pink.shade100,
    category: 'Thời trang',
  ),
  Product(
    name: 'Giày sneaker',
    price: 850000,
    icon: Icons.directions_walk,
    color: Colors.green.shade100,
    category: 'Giày dép',
  ),
  Product(
    name: 'Kính mát',
    price: 250000,
    icon: Icons.remove_red_eye,
    color: Colors.cyan.shade100,
    category: 'Phụ kiện',
  ),
];
