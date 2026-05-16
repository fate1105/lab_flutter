import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/accounts/login.dart';
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/change_password_model.dart';
import 'package:user_management/models/user_model.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/shared/error_dialog.dart';
import 'package:user_management/shared/submit_button.dart';
import 'package:user_management/shared/text_fields.dart';

class AdminProfileTab extends StatefulWidget {
  const AdminProfileTab({super.key});

  @override
  State<AdminProfileTab> createState() => _AdminProfileTabState();
}

class _AdminProfileTabState extends State<AdminProfileTab> {
  late String _adminEmail;
  String _adminPhone = "";
  bool _isLoading = false;
  bool _isAdminPhoneEditing = false;

  final TextEditingController _adminPhoneController = TextEditingController();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _adminEmail = fetchEmailFromToken(context: context);
    _fetchAdminProfile();
  }

  @override
  void dispose() {
    _adminPhoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // ==================== CALL APIs ====================

  Future<void> _fetchAdminProfile() async {
    setState(() => _isLoading = true);
    try {
      var result = await http.post(
        Uri.parse(ApiEndpoints.adminInfoGetAndUpdate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: json.encode(_adminEmail),
      );
      if (result.statusCode >= 200 && result.statusCode <= 299) {
        final jsonData = json.decode(result.body);
        final user = UserModel.fromJson(jsonData);
        setState(() {
          _adminPhone = user.phoneNumber ?? "";
          _adminPhoneController.text = _adminPhone;
        });
      }
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAdminPhone() async {
    setState(() => _isLoading = true);
    try {
      var result = await http.put(
        Uri.parse(ApiEndpoints.adminInfoGetAndUpdate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode({
          "email": _adminEmail,
          "phoneNumber": _adminPhoneController.text,
        }),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        setState(() {
          _adminPhone = _adminPhoneController.text;
          _isAdminPhoneEditing = false;
        });
        _showSuccessSnack("Cập nhật số điện thoại thành công!");
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể cập nhật số điện thoại");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changeAdminPassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final changePassword = ChangePasswordModel(
          email: _adminEmail,
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        var result = await http.put(
          Uri.parse(ApiEndpoints.adminChangePassword),
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
              // Xem thông tin Email
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email của bạn", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(_adminEmail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      const Text("Số điện thoại", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      _isAdminPhoneEditing
                          ? Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _adminPhoneController,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check, color: AppColors.success),
                                  onPressed: _updateAdminPhone,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: AppColors.danger),
                                  onPressed: () {
                                    setState(() {
                                      _adminPhoneController.text = _adminPhone;
                                      _isAdminPhoneEditing = false;
                                    });
                                  },
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _adminPhone.isEmpty ? "Chưa thiết lập" : _adminPhone,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.adminPage),
                                  onPressed: () => setState(() => _isAdminPhoneEditing = true),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

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
                        const Divider(height: 24),
                        passwordTextField(passwordController: _currentPasswordController, label: "Mật khẩu hiện tại"),
                        const SizedBox(height: 10),
                        passwordTextField(passwordController: _newPasswordController, label: "Mật khẩu mới"),
                        const SizedBox(height: 20),
                        submitButton(
                          context: context,
                          backgroundColor: AppColors.adminPage,
                          textColor: Colors.white,
                          title: "Cập nhật mật khẩu",
                          method: _changeAdminPassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nút Đăng xuất
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Đăng xuất tài khoản", style: TextStyle(fontWeight: FontWeight.bold)),
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
          const Center(child: CircularProgressIndicator(color: AppColors.adminPage)),
      ],
    );
  }
}
