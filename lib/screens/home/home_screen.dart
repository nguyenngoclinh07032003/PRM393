import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../providers/app_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/format.dart';
import '../../widgets/common_widgets.dart';
import '../cart/cart_screen.dart';
import '../product/product_detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Key toàn cục để các màn hình khác có thể điều khiển tab
final homeScreenKey = GlobalKey<_HomeScreenState>();

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isSearching = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: normalAnimation,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Dùng để chuyển tab từ bên ngoài (ví dụ: từ OrderSuccessScreen)
  void goToTab(int index) {
    setState(() => _selectedIndex = index);
  }

  final _categories = ['Tất cả', 'Thời trang', 'Điện tử', 'Phụ kiện', 'Giày dép'];

  List<Product> get _filteredProducts {
    var filtered = products.toList();

    // Filter by category
    if (_selectedCategory > 0) {
      final category = _categories[_selectedCategory];
      filtered = filtered.where((p) => p.category == category).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final pages = [
      _homeBody(),
      const CartScreen(showBackButton: false),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [cardShadow],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: CountBadge(
                count: cart.totalItems,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: CountBadge(
                count: cart.totalItems,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Giỏ hàng',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeBody() {
    final filteredProducts = _filteredProducts;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 20),

                // Search bar
                _buildSearchBar(),
                const SizedBox(height: 20),

                // Banner
                _buildPromoBanner(),
                const SizedBox(height: 20),

                // Categories
                _buildCategories(),
                const SizedBox(height: 20),

                // Section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Kết quả tìm kiếm (${filteredProducts.length})'
                          : 'Sản phẩm nổi bật',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textDark,
                      ),
                    ),
                    if (_searchQuery.isEmpty)
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Products grid
                filteredProducts.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'Không tìm thấy sản phẩm',
                        subtitle: 'Thử tìm kiếm với từ khóa khác',
                      )
                    : _buildProductGrid(filteredProducts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final app = AppProvider.of(context);
    return Row(
      children: [
        Hero(
          tag: 'user_avatar',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [lightShadow],
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: app.avatarColor,
              child: Text(
                app.userName.isNotEmpty ? app.userName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Xin chào,',
                style: TextStyle(color: textGray, fontSize: 13),
              ),
              Text(
                app.userName.isNotEmpty ? app.userName : 'Bạn',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textDark,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ScaleButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Chưa có thông báo mới'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [lightShadow],
            ),
            child: const Icon(Icons.notifications_outlined, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: normalAnimation,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _isSearching = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm...',
          hintStyle: const TextStyle(color: textGray),
          prefixIcon: const Icon(Icons.search, color: primaryColor),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear, color: textGray),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _isSearching = false;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return ScaleButton(
      onPressed: () {},
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 130,
          maxHeight: 150,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🔥 HOT DEAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Giảm giá đặc biệt',
              style: TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              'Lên đến 50%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            const Text(
              'Cho các sản phẩm nổi bật hôm nay',
              style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (_, index) {
          final selected = _selectedCategory == index;
          return ScaleButton(
            onPressed: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: quickAnimation,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      )
                    : null,
                color: selected ? null : cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: selected ? [lightShadow] : [],
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: selected ? Colors.white : textDark,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, index) => _buildProductCard(products[index]),
    );
  }

  Widget _buildProductCard(Product product) {
    final app = AppProvider.of(context);
    final isFav = app.isFavorite(product);

    return Hero(
      tag: 'product_${product.name}',
      child: Material(
        color: Colors.transparent,
        child: ScaleButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: product.color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Icon(
                          product.icon,
                          size: 70,
                          color: primaryColor.withOpacity(0.8),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: ScaleButton(
                          onPressed: () => app.toggleFavorite(product),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [lightShadow],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : textGray,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          const Text(
                            '4.8',
                            style: TextStyle(fontSize: 11, color: textGray),
                          ),
                          const Spacer(),
                          Text(
                            formatPrice(product.price),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
