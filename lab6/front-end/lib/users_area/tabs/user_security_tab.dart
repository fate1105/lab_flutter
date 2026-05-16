import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/accounts/login.dart';
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/change_password_model.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/shared/confirmation_dialog.dart';
import 'package:user_management/shared/error_dialog.dart';
import 'package:user_management/shared/submit_button.dart';
import 'package:user_management/shared/text_fields.dart';

class UserSecurityTab extends StatefulWidget {
  const UserSecurityTab({super.key});

  @override
  State<UserSecurityTab> createState() => _UserSecurityTabState();
}

class _UserSecurityTabState extends State<UserSecurityTab> {
  late String _userEmail;
  bool _isLoading = false;

  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userEmail = fetchEmailFromToken(context: context);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // ==================== CALL APIs ====================

  Future<void> _changeUserPassword() async {
    if (TokenHandler().getToken().isEmpty) {
      if (_passwordFormKey.currentState!.validate()) {
        _showSuccessSnack("Đổi mật khẩu thành công (Mock)! Vui lòng đăng nhập lại.");
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        });
      }
      return;
    }

    if (_passwordFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final changePassword = ChangePasswordModel(
          email: _userEmail,
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        var result = await http.put(
          Uri.parse(ApiEndpoints.userChangePassword),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${TokenHandler().getToken()}',
          },
          body: json.encode(changePassword.toJson()),
        );

        if (result.statusCode >= 200 && result.statusCode <= 299) {
          _showSuccessSnack("Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
          TokenHandler().clearToken();
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          _showError(result.statusCode, result.body);
        }
      } catch (e) {
        _showCustomError("Lỗi", "Không thể thay đổi mật khẩu");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteUserAccount() async {
    if (TokenHandler().getToken().isEmpty) {
      _showSuccessSnack("Xóa tài khoản thành công (Mock)!");
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await http.delete(
        Uri.parse(ApiEndpoints.userDeleteProfile),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode(_userEmail),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        _showSuccessSnack("Tài khoản của bạn đã được xóa thành công.");
        TokenHandler().clearToken();
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        });
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể xóa tài khoản");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ==================== HELPERS ====================

  void _showError(int statusCode, String responseBody) {
    String errorMsg = "Đã xảy ra lỗi.";
    try {
      var errorBody = jsonDecode(responseBody);
      errorMsg = errorBody['message'] ?? errorBody['title'] ?? "Đã xảy ra lỗi.";
    } catch (_) {}
    _showCustomError("Lỗi ($statusCode)", errorMsg);
  }

  void _showCustomError(String title, String description) {
    if (!mounted) return;
    errorDialog(context: context, statusCode: 0, description: "$title: $description", color: AppColors.danger);
  }

  void _showSuccessSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Đổi mật khẩu
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _passwordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Thay Đổi Mật Khẩu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Divider(height: 20),
                        passwordTextField(passwordController: _currentPasswordController, label: "Mật khẩu hiện tại"),
                        const SizedBox(height: 10),
                        passwordTextField(passwordController: _newPasswordController, label: "Mật khẩu mới"),
                        const SizedBox(height: 20),
                        submitButton(
                          context: context,
                          backgroundColor: AppColors.userPage,
                          textColor: Colors.white,
                          title: "Cập nhật mật khẩu",
                          method: _changeUserPassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Danger Zone: Xóa tài khoản
              Card(
                color: Colors.red.shade50.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red.shade100, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Vùng Nguy Hiểm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                      const SizedBox(height: 8),
                      const Text(
                        "Một khi tài khoản của bạn bị xóa, toàn bộ dữ liệu sẽ biến mất vĩnh viễn và không thể khôi phục.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Divider(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          bool? confirmed = await showConfirmationDialog(
                            context: context,
                            title: "Cảnh Báo Xóa",
                            content: "Bạn có chắc muốn xóa vĩnh viễn tài khoản của mình? Hành động này không thể hoàn tác.",
                            color: AppColors.userPage,
                          );
                          if (confirmed == true) {
                            _deleteUserAccount();
                          }
                        },
                        child: const Text("Yêu Cầu Xóa Tài Khoản", style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Đăng xuất
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Đăng Xuất", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  TokenHandler().clearToken();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: AppColors.userPage)),
      ],
    );
  }
}
