import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/cart_service.dart';
import '../../widgets/custom_app_bar.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  // Định dạng hiển thị tiền tệ VND đơn giản
  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    // Nhận đối số truyền vào từ Navigator
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final cultureId = args['cultureId'] ?? '';
    final cultureName = args['cultureName'] ?? 'Danh sách Món ăn';

    // Lọc danh sách món ăn theo văn hóa ẩm thực đã chọn
    final filteredFoods = mockFoodItems.where((item) => item.culture == cultureId).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Sử dụng CustomAppBar với tiêu đề tùy biến theo văn hóa đã chọn
      appBar: CustomAppBar(
        title: cultureName,
        showBackButton: true,
      ),
      body: filteredFoods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_meals_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Hiện chưa có món ăn nào cho danh mục này.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        // Chuyển sang màn hình Chi tiết món ăn
                        Navigator.pushNamed(
                          context,
                          '/food-detail',
                          arguments: food,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Ảnh món ăn với Hero animation để chuyển mượt mà
                          Hero(
                            tag: 'food_img_${food.id}',
                            child: SizedBox(
                              height: 180,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      food.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 50),
                                      ),
                                    ),
                                  ),
                                  // Nhãn giá bán nổi bật trên góc ảnh
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _formatPrice(food.price),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Nội dung thông tin món ăn
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  food.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Nút chi tiết và nút thêm nhanh vào giỏ hàng
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/food-detail',
                                          arguments: food,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.deepOrange,
                                      ),
                                      child: const Row(
                                        children: [
                                          Text('Xem chi tiết', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward, size: 16),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Thêm vào giỏ hàng ngay lập tức
                                        CartService().addToCart(food);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Đã thêm "${food.name}" vào giỏ hàng!'),
                                            backgroundColor: Colors.green,
                                            duration: const Duration(seconds: 1),
                                            action: SnackBarAction(
                                              label: 'XEM GIỎ',
                                              textColor: Colors.white,
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/cart');
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepOrange,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 1,
                                      ),
                                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                                      label: const Text(
                                        'Thêm vào giỏ',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                );
              },
            ),
    );
  }
}
