import 'food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
  });

  // Tính tổng tiền của mặt hàng này
  double get totalOriginalPrice => foodItem.price * quantity;
}
