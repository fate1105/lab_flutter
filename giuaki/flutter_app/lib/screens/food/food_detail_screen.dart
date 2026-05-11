import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/cart_service.dart';
import '../../widgets/custom_app_bar.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({Key? key}) : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '${m[1]}.')} đ';
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nhận thông tin món ăn từ đối số truyền sang
    final food = ModalRoute.of(context)!.settings.arguments as FoodItem;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: food.name,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh món ăn cỡ lớn với hiệu ứng Hero liên kết mượt mà từ màn hình trước
            Hero(
              tag: 'food_img_${food.id}',
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  food.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 80),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên món ăn và giá bán nổi bật
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _formatPrice(food.price),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Đánh giá giả lập (làm cho giao diện sinh động và cao cấp)
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const Icon(Icons.star_half_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '4.8',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(120+ đánh giá)',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Tiêu đề phần mô tả
                  const Text(
                    'Mô Tả Chi Tiết Món Ăn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Nội dung mô tả chi tiết món ăn
                  Text(
                    food.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Phần chọn Số Lượng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số lượng đặt mua',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Bộ tăng/giảm số lượng
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[50],
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _decrementQuantity,
                              icon: const Icon(Icons.remove, size: 18),
                              color: Colors.black87,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _incrementQuantity,
                              icon: const Icon(Icons.add, size: 18),
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Nút "Thêm Vào Giỏ Hàng" cỡ lớn ở dưới cùng
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Thêm vào giỏ hàng với số lượng đã chọn
                        CartService().addToCart(food, quantity: _quantity);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã thêm $_quantity x "${food.name}" vào giỏ hàng!'),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1,
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 22),
                      label: const Text(
                        'THÊM VÀO GIỎ HÀNG',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
