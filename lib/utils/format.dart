import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6A11CB);
const Color secondaryColor = Color(0xFF2575FC);
const Color bgColor = Color(0xFFF8F8F8);
const Color cardColor = Colors.white;
const Color textDark = Color(0xFF222222);
const Color textGray = Color(0xFF888888);
const Color errorColor = Color(0xFFE74C3C);
const Color successColor = Color(0xFF27AE60);

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

// Shadow constants for consistent elevation
const BoxShadow cardShadow = BoxShadow(
  color: Color(0x0F000000),
  blurRadius: 12,
  offset: Offset(0, 4),
);

const BoxShadow lightShadow = BoxShadow(
  color: Color(0x08000000),
  blurRadius: 8,
  offset: Offset(0, 2),
);

// Animation durations
const Duration quickAnimation = Duration(milliseconds: 200);
const Duration normalAnimation = Duration(milliseconds: 300);
const Duration slowAnimation = Duration(milliseconds: 500);
