import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/culture_category_screen.dart';
import 'screens/food/food_list_screen.dart';
import 'screens/food/food_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/cart/payment_success_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Culinary World',
      debugShowCheckedModeBanner: false,
      
      // Thiết kế Theme màu sắc sang trọng, ấm cúng chủ đạo màu cam ẩm thực
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.grey[50],
        
        // Cấu hình phông chữ mặc định hiện đại và mượt mà
        fontFamily: 'Roboto',
        
        // Tùy biến nút bấm (Button Theme) bo tròn đồng điệu
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        // Tùy biến input text field (Input Decoration Theme)
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      
      // Khai báo màn hình khởi đầu (Trang Đăng Nhập)
      initialRoute: '/',
      
      // Khai báo các đường dẫn Định tuyến (Routes)
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => CultureCategoryScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/food-list': (context) => const FoodListScreen(),
        '/food-detail': (context) => const FoodDetailScreen(),
        '/cart': (context) => const CartScreen(),
        '/payment-success': (context) => const PaymentSuccessScreen(),
      },
    );
  }
}
