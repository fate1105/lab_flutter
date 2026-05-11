import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(65.0);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final cartService = CartService();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        titleSpacing: showBackButton ? 0 : 20,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        // Nút quay lại tùy biến đẹp mắt
        leading: showBackButton && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        // Tiêu đề tùy biến
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Roboto',
          ),
        ),
        actions: [
          // Lắng nghe cả Auth và Giỏ hàng để cập nhật giao diện
          AnimatedBuilder(
            animation: Listenable.merge([authService, cartService]),
            builder: (context, _) {
              return Row(
                children: [
                  // 1. Hiển thị thông tin Khách hàng & nút Đăng xuất / Đăng nhập
                  if (authService.isLoggedIn) ...[
                    // Avatar tròn hiển thị chữ cái đầu tiên của khách hàng
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.amber[700],
                      child: Text(
                        authService.currentUser!.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tên khách hàng
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Xin chào,',
                          style: TextStyle(color: Colors.black54, fontSize: 10),
                        ),
                        Text(
                          authService.currentUser!.name,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    // Nút Đăng xuất
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                      tooltip: 'Đăng xuất',
                      onPressed: () {
                        // Gọi hàm đăng xuất
                        authService.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã đăng xuất thành công!'),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 1),
                          ),
                        );
                        // Đưa người dùng về màn hình chính
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ] else ...[
                    // Nút Đăng nhập nếu chưa đăng nhập
                    TextButton.icon(
                      icon: const Icon(Icons.login_rounded, color: Colors.deepOrange, size: 18),
                      label: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],

                  const SizedBox(width: 4),

                  // 2. Icon Giỏ hàng với Badge số lượng
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87, size: 24),
                        onPressed: () {
                          // Cho phép vào giỏ hàng xem, nhưng khi thanh toán sẽ yêu cầu đăng nhập
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                      if (cartService.totalCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cartService.totalCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
