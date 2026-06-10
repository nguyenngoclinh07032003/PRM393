import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final IconData icon;
  final Color color;

  Product({
    required this.name,
    required this.price,
    required this.icon,
    required this.color,
  });
}

final List<Product> products = [
  Product(
    name: 'Móc phơi đồ',
    price: 59000,
    icon: Icons.checkroom,
    color: Colors.blue.shade100,
  ),
  Product(
    name: 'Tai nghe Bluetooth',
    price: 590000,
    icon: Icons.headphones,
    color: Colors.purple.shade100,
  ),
  Product(
    name: 'Đồng hồ thông minh',
    price: 1290000,
    icon: Icons.watch,
    color: Colors.orange.shade100,
  ),
  Product(
    name: 'Túi xách thời trang',
    price: 450000,
    icon: Icons.shopping_bag,
    color: Colors.pink.shade100,
  ),
  Product(
    name: 'Giày sneaker',
    price: 850000,
    icon: Icons.directions_walk,
    color: Colors.green.shade100,
  ),
  Product(
    name: 'Kính mát',
    price: 250000,
    icon: Icons.remove_red_eye,
    color: Colors.cyan.shade100,
  ),
];
