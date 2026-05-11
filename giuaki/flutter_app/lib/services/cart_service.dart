import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  // Singleton
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // Danh sách món ăn trong giỏ hàng
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  // Tính tổng số lượng sản phẩm trong giỏ hàng (hiển thị trên badge của giỏ hàng)
  int get totalCount {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  // Tính tổng số tiền giỏ hàng
  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      total += item.totalOriginalPrice;
    }
    return total;
  }

  // Thêm món ăn vào giỏ hàng
  void addToCart(FoodItem foodItem, {int quantity = 1}) {
    // Kiểm tra xem món ăn đã có trong giỏ hàng chưa
    int existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItem.id);

    if (existingIndex >= 0) {
      // Nếu đã có, cộng thêm số lượng
      _items[existingIndex].quantity += quantity;
    } else {
      // Nếu chưa có, thêm mới vào danh sách
      _items.add(CartItem(foodItem: foodItem, quantity: quantity));
    }
    notifyListeners();
  }

  // Cập nhật số lượng của một mặt hàng cụ thể (+1 hoặc -1)
  void updateQuantity(String foodItemId, int delta) {
    int index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      _items[index].quantity += delta;
      
      // Nếu số lượng nhỏ hơn hoặc bằng 0, xóa khỏi giỏ hàng
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Xóa hoàn toàn một mặt hàng khỏi giỏ hàng
  void removeFromCart(String foodItemId) {
    _items.removeWhere((item) => item.foodItem.id == foodItemId);
    notifyListeners();
  }

  // Xóa sạch giỏ hàng (sau khi thanh toán thành công hoặc reset)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Xử lý thanh toán giả lập
  Future<bool> processPayment() async {
    if (_items.isEmpty) return false;
    
    await Future.delayed(const Duration(milliseconds: 1000)); // Giả lập xử lý thanh toán ngân hàng/ví điện tử
    
    // Sau khi thanh toán thành công thì dọn dẹp giỏ hàng
    clearCart();
    return true;
  }
}
