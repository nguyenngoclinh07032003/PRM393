import 'package:flutter/material.dart';
import '../../utils/format.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  int _step = 1;

  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(4, (_) => FocusNode());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  int _resendCountdown = 0;

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(v.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  Future<void> _sendOtp() async {
    if (!_emailFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _step = 2;
      _resendCountdown = 60;
    });
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCountdown--);
      return _resendCountdown > 0;
    });
  }

  Future<void> _verifyOtp() async {
    if (!_otpFormKey.currentState!.validate()) return;
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ mã OTP'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _step = 3;
    });
  }

  Future<void> _resetPassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt lại mật khẩu thành công!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
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
          onPressed: () {
            if (_step > 1) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _step == 1 ? 'Quên mật khẩu' : _step == 2 ? 'Xác thực OTP' : 'Đặt lại mật khẩu',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 32),
              if (_step == 1) _buildStep1(),
              if (_step == 2) _buildStep2(),
              if (_step == 3) _buildStep3(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (i) {
        final stepNum = i + 1;
        final isActive = stepNum <= _step;
        final isDone = stepNum < _step;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: i == 0
                    ? const SizedBox()
                    : Container(height: 2, color: isActive ? primaryColor : Colors.grey.shade300),
              ),
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? primaryColor : Colors.grey.shade300),
                alignment: Alignment.center,
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text('$stepNum', style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              Expanded(
                child: i == 2
                    ? const SizedBox()
                    : Container(height: 2, color: stepNum < _step ? primaryColor : Colors.grey.shade300),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          const Icon(Icons.lock_reset, size: 72, color: primaryColor),
          const SizedBox(height: 16),
          const Text('Nhập email của bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
          const SizedBox(height: 8),
          const Text('Chúng tôi sẽ gửi mã OTP để xác thực', style: TextStyle(fontSize: 13, color: Color(0xFF888888)), textAlign: TextAlign.center),
          const SizedBox(height: 28),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.mail_outline),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          _submitButton('Gửi mã OTP', _isLoading ? null : _sendOtp),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          const Icon(Icons.message_outlined, size: 72, color: primaryColor),
          const SizedBox(height: 16),
          const Text('Nhập mã OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
          const SizedBox(height: 8),
          Text('Mã đã được gửi đến\n${_emailController.text.trim()}', style: const TextStyle(fontSize: 13, color: Color(0xFF888888)), textAlign: TextAlign.center),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                width: 56, height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: TextFormField(
                  controller: _otpControllers[i],
                  focusNode: _otpFocusNodes[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryColor, width: 2)),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && i < 3) {
                      _otpFocusNodes[i + 1].requestFocus();
                    } else if (val.isEmpty && i > 0) {
                      _otpFocusNodes[i - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Không nhận được mã? ', style: TextStyle(color: Color(0xFF888888), fontSize: 13)),
              _resendCountdown > 0
                  ? Text('Gửi lại ($_resendCountdown s)', style: const TextStyle(color: Colors.grey, fontSize: 13))
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _resendCountdown = 60;
                          for (final c in _otpControllers) {
                            c.clear();
                          }
                        });
                        _startCountdown();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi lại mã OTP')));
                      },
                      child: const Text('Gửi lại', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
            ],
          ),
          const SizedBox(height: 28),
          _submitButton('Xác nhận', _isLoading ? null : _verifyOtp),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: [
          const Icon(Icons.lock_open_outlined, size: 72, color: primaryColor),
          const SizedBox(height: 16),
          const Text('Đặt mật khẩu mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
          const SizedBox(height: 8),
          const Text('Mật khẩu mới phải có ít nhất 6 ký tự', style: TextStyle(fontSize: 13, color: Color(0xFF888888)), textAlign: TextAlign.center),
          const SizedBox(height: 28),
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới';
              if (v.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Mật khẩu mới',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
              if (v != _newPasswordController.text) return 'Mật khẩu xác nhận không khớp';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu mới',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 28),
          _submitButton('Xác nhận', _isLoading ? null : _resetPassword),
        ],
      ),
    );
  }

  Widget _submitButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _isLoading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
