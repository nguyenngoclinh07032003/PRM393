import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/format.dart';
import '../auth/login_screen.dart';
import 'address_screen.dart';
import 'favorites_screen.dart';
import 'my_orders_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static void _handleLogout(BuildContext context) async {
    await AuthService.logout();
    if (!context.mounted) return;
    AppProvider.of(context).clear();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Cá nhân'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: app.avatarColor,
                      child: Text(
                        app.userName.isNotEmpty
                            ? app.userName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    app.userName.isNotEmpty ? app.userName : 'Khách',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    app.userEmail.isNotEmpty ? app.userEmail : 'Chưa có email',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                  ),
                  if (app.userPhone.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        app.userPhone,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                      ),
                    ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _buildStat('${app.orders.length}', 'Đơn hàng'),
                      _divider(),
                      _buildStat('${app.favorites.length}', 'Yêu thích'),
                      _divider(),
                      const _StatWidget(number: '0', label: 'Đánh giá'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Menu nhóm 1 ──
            _menuGroup(context, [
              _buildMenuItem(context, Icons.inventory_2_outlined, 'Đơn hàng của tôi',
                subtitle: '${app.orders.length} đơn',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersScreen())),
              ),
              _buildMenuItem(context, Icons.favorite_border, 'Sản phẩm yêu thích',
                subtitle: '${app.favorites.length} sản phẩm',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
              _buildMenuItem(context, Icons.location_on_outlined, 'Địa chỉ giao hàng',
                subtitle: app.address,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressScreen())),
              ),
            ]),
            const SizedBox(height: 12),

            // ── Menu nhóm 2 ──
            _menuGroup(context, [
              _buildMenuItem(context, Icons.credit_card, 'Phương thức thanh toán',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phương thức thanh toán'))),
              ),
              _buildMenuItem(context, Icons.settings_outlined, 'Cài đặt',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
              _buildMenuItem(context, Icons.power_settings_new, 'Đăng xuất',
                isLogout: true,
                onTap: () {
                  _handleLogout(context);
                },
              ),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildStat(String number, String label) => Expanded(
    child: Column(
      children: [
        Text(number, style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 10)),
      ],
    ),
  );

  static Widget _divider() => Container(height: 30, width: 1, color: Colors.grey.shade300);

  static Widget _menuGroup(BuildContext context, List<Widget> items) =>
      Container(color: Colors.white, child: Column(children: items));

  static Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    String? subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: isLogout ? Colors.red.shade50 : primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: isLogout ? Colors.red : primaryColor),
          ),
          title: Text(title, style: TextStyle(fontWeight: isLogout ? FontWeight.bold : FontWeight.normal, color: isLogout ? Colors.red : Colors.black)),
          subtitle: subtitle != null
              ? Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF888888)))
              : null,
          trailing: const Icon(Icons.chevron_right),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _StatWidget extends StatelessWidget {
  final String number;
  final String label;
  const _StatWidget({required this.number, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(number, style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 10)),
      ],
    ),
  );
}
