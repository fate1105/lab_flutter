import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class AuthService extends ChangeNotifier {
  // Đóng gói AuthService dưới dạng Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Trạng thái người dùng hiện tại (null nghĩa là chưa đăng nhập)
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Giả lập cơ sở dữ liệu người dùng cục bộ cho mục đích thuyết trình
  final List<Map<String, String>> _registeredUsers = [
    {
      'name': 'Nguyễn Văn A',
      'email': 'student@example.com',
      'password': '123',
      'phone': '0987654321',
    }
  ];

  // Đăng nhập
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // giả lập độ trễ mạng
    
    for (var user in _registeredUsers) {
      if (user['email'] == email && user['password'] == password) {
        _currentUser = UserProfile(
          name: user['name']!,
          email: user['email']!,
          phone: user['phone']!,
        );
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Đăng ký tài khoản mới
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Kiểm tra trùng email
    for (var user in _registeredUsers) {
      if (user['email'] == email) {
        return false; // Email đã tồn tại
      }
    }

    // Thêm vào "database" giả lập
    _registeredUsers.add({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });

    // Tự động đăng nhập sau khi đăng ký thành công
    _currentUser = UserProfile(name: name, email: email, phone: phone);
    notifyListeners();
    return true;
  }

  // Đăng xuất
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Quên mật khẩu
  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Kiểm tra xem email có tồn tại không
    bool exists = _registeredUsers.any((user) => user['email'] == email);
    // Để dễ thuyết trình, dù email nào nhập vào cũng sẽ cho thành công (hoặc kiểm tra nếu muốn nghiêm ngặt)
    return exists;
  }
}
