import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6A11CB);
const Color secondaryColor = Color(0xFF2575FC);
const Color bgColor = Color(0xFFF8F8F8);

String formatPrice(int price) {
  final text = price.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    final posFromRight = text.length - i;
    buffer.write(text[i]);
    if (posFromRight > 1 && posFromRight % 3 == 1) buffer.write('.');
  }
  return '${buffer.toString()}đ';
}
