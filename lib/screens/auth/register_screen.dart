import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/format.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập họ tên';
    if (v.trim().length < 2) return 'Họ tên phải có ít nhất 2 ký tự';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(v.trim())) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (v != _passwordController.text) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!RegExp(r'^0\d{9}$').hasMatch(v.trim())) {
      return 'Số điện thoại không hợp lệ (VD: 0912345678)';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với điều khoản sử dụng'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isLoading = true);

    final result = await AuthService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Đăng ký thất bại'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Lưu thông tin user vào AppProvider (local state)
    AppProvider.of(context).setUserInfo(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập.'), backgroundColor: Colors.green),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person_add, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                const Text('Tạo tài khoản', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
                const SizedBox(height: 4),
                const Text('Điền thông tin để đăng ký', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
                const SizedBox(height: 28),
                _buildField(controller: _nameController, label: 'Họ và tên', icon: Icons.person_outline, validator: _validateName, caps: TextCapitalization.words),
                const SizedBox(height: 12),
                _buildField(controller: _emailController, label: 'Email', icon: Icons.mail_outline, keyboard: TextInputType.emailAddress, validator: _validateEmail),
                const SizedBox(height: 12),
                _buildField(controller: _phoneController, label: 'Số điện thoại', icon: Icons.phone_outlined, keyboard: TextInputType.phone, validator: _validatePhone),
                const SizedBox(height: 12),
                _buildPasswordField(controller: _passwordController, label: 'Mật khẩu', obscure: _obscurePassword, validator: _validatePassword, onToggle: () => setState(() => _obscurePassword = !_obscurePassword)),
                const SizedBox(height: 12),
                _buildPasswordField(controller: _confirmPasswordController, label: 'Xác nhận mật khẩu', obscure: _obscureConfirm, validator: _validateConfirm, onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(value: _agreeTerms, activeColor: primaryColor, onChanged: (v) => setState(() => _agreeTerms = v ?? false)),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                        child: const Text.rich(TextSpan(
                          text: 'Tôi đồng ý với ',
                          style: TextStyle(fontSize: 13),
                          children: [
                            TextSpan(text: 'Điều khoản sử dụng', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                            TextSpan(text: ' và '),
                            TextSpan(text: 'Chính sách bảo mật', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text('Đăng ký', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Đã có tài khoản? ', style: TextStyle(color: Color(0xFF888888))),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Đăng nhập', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    TextCapitalization caps = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textCapitalization: caps,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: onToggle),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
