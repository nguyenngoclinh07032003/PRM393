import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'providers/app_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/address_screen.dart';

// File này được tạo tự động bởi flutterfire configure
// Chạy: flutterfire configure --project=prm393-9f30f
// để tạo file lib/firebase_options.dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Ecommerce());
}

class Ecommerce extends StatelessWidget {
  const Ecommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      notifier: AppNotifier(),
      child: CartProvider(
        notifier: CartNotifier(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-commerce',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF6A11CB),
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
          routes: {
            '/address': (_) => const AddressScreen(),
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(Icons.shopping_bag, color: Colors.white, size: 52),
              ),
              SizedBox(height: 20),
              Text('Shop App',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              SizedBox(height: 8),
              Text('Mua sắm thông minh',
                  style: TextStyle(fontSize: 14, color: Color(0xCCFFFFFF))),
              SizedBox(height: 80),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
