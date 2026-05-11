import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class CultureCategory {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final IconData icon;

  CultureCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
  });
}

class CultureCategoryScreen extends StatelessWidget {
  CultureCategoryScreen({Key? key}) : super(key: key);

  // Danh mục văn hóa ẩm thực với hình ảnh chất lượng cao
  final List<CultureCategory> categories = [
    CultureCategory(
      id: 'pizza',
      name: 'Pizza & Món Ý',
      description: 'Đế giòn mỏng xốp nướng lò củi kiểu Ý đích thực',
      imageUrl: 'assets/images/pizza.png',
      icon: Icons.local_pizza_rounded,
    ),
    CultureCategory(
      id: 'chinese',
      name: 'Món ăn Trung Hoa',
      description: 'Hòa quyện sắc hương vị đậm đà truyền thống',
      imageUrl: 'assets/images/chinese.png',
      icon: Icons.ramen_dining_rounded,
    ),
    CultureCategory(
      id: 'mexican',
      name: 'Ẩm thực Mexico',
      description: 'Tacos cay nồng, giòn tan đậm sắc màu',
      imageUrl: 'assets/images/mexican.png',
      icon: Icons.set_meal_rounded,
    ),
    CultureCategory(
      id: 'indian',
      name: 'Cơm & Món Ấn Độ',
      description: 'Cơm Biryani dẻo thơm và nước sốt Masala đặc trưng',
      imageUrl: 'assets/images/south-indian.png',
      icon: Icons.rice_bowl_rounded,
    ),
    CultureCategory(
      id: 'beverages',
      name: 'Thức uống giải khát',
      description: 'Trà sữa matcha và các loại sinh tố mát lạnh sảng khoái',
      imageUrl: 'assets/images/beverages.png',
      icon: Icons.local_drink_rounded,
    ),
    CultureCategory(
      id: 'desserts',
      name: 'Bánh ngọt & Tráng miệng',
      description: 'Bánh vòng donut ngọt ngào béo thơm hấp dẫn',
      imageUrl: 'assets/images/desserts.png',
      icon: Icons.cake_rounded,
    ),
    CultureCategory(
      id: 'ice_cream',
      name: 'Kem lạnh thơm ngon',
      description: 'Ly kem dâu tây mát rượi xua tan cơn khát ngày hè',
      imageUrl: 'assets/images/ice-creams.png',
      icon: Icons.icecream_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Tiêu đề Appbar tùy biến, không hiển thị nút back vì đây là trang chủ
      appBar: const CustomAppBar(
        title: 'Thế Giới Ẩm Thực',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner chào mừng ấn tượng
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[800]!, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hôm nay bạn muốn ăn gì?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Khám phá tinh hoa ẩm thực từ các nền văn hóa đặc sắc trên thế giới',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 24.0, bottom: 12.0),
              child: Text(
                'Nền Văn Hóa Ẩm Thực',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Grid hiển thị các danh mục văn hóa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  childAspectRatio: 0.85, // tỉ lệ khung hình
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return InkWell(
                    onTap: () {
                      // Chuyển sang màn hình danh sách món ăn, truyền thông tin văn hóa đã chọn
                      Navigator.pushNamed(
                        context,
                        '/food-list',
                        arguments: {'cultureId': cat.id, 'cultureName': cat.name},
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Hình ảnh nền
                             Positioned.fill(
                              child: Image.asset(
                                cat.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 40),
                                ),
                              ),
                            ),
                            // Lớp phủ tối (gradient overlay) để chữ hiển thị rõ ràng hơn
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.85),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            // Biểu tượng văn hóa góc trên
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  cat.icon,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            // Chữ thông tin bên dưới card
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cat.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
