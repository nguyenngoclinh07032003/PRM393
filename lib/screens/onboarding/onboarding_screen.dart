import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/format.dart';
import '../../widgets/common_widgets.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.shopping_bag_outlined,
      title: 'Khám phá sản phẩm',
      description: 'Hàng ngàn sản phẩm chất lượng với giá tốt nhất thị trường',
      color: primaryColor,
    ),
    OnboardingData(
      icon: Icons.local_shipping_outlined,
      title: 'Giao hàng nhanh chóng',
      description: 'Miễn phí vận chuyển cho đơn hàng trên 500.000đ',
      color: secondaryColor,
    ),
    OnboardingData(
      icon: Icons.verified_user_outlined,
      title: 'Thanh toán an toàn',
      description: 'Nhiều phương thức thanh toán, bảo mật tuyệt đối',
      color: successColor,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    HapticFeedback.lightImpact();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _pages[_currentPage].color.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ScaleButton(
                    onPressed: _finishOnboarding,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: textGray.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Bỏ qua',
                        style: TextStyle(
                          color: textGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: quickAnimation,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: _currentPage == index
                          ? const LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            )
                          : null,
                      color: _currentPage == index
                          ? null
                          : textGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: ScaleButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'Quay lại',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      flex: _currentPage == 0 ? 1 : 1,
                      child: GradientButton(
                        text: _currentPage == _pages.length - 1
                            ? 'Bắt đầu'
                            : 'Tiếp tục',
                        height: 56,
                        onPressed: _goToNextPage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        data.color.withValues(alpha: 0.2),
                        data.color.withValues(alpha: 0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.icon,
                    size: 80,
                    color: data.color,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 16,
              color: textGray,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
