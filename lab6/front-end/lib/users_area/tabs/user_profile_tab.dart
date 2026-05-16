import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/user_model.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/shared/error_dialog.dart';

class UserProfileTab extends StatefulWidget {
  const UserProfileTab({super.key});

  @override
  State<UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> {
  late String _userEmail;
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isPhoneEditing = false;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userEmail = fetchEmailFromToken(context: context);
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // ==================== CALL APIs ====================

  Future<void> _fetchUserProfile() async {
    if (TokenHandler().getToken().isEmpty) {
      setState(() {
        _currentUser = const UserModel(
          id: "usr_999",
          email: "user_demo@gmail.com",
          phoneNumber: "0123456789",
          role: ["User"],
        );
        _phoneController.text = _currentUser?.phoneNumber ?? "";
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await http.post(
        Uri.parse(ApiEndpoints.userInfoReadUpdate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode(_userEmail),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        final jsonData = json.decode(result.body);
        setState(() {
          _currentUser = UserModel.fromJson(jsonData);
          _phoneController.text = _currentUser?.phoneNumber ?? "";
        });
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi kết nối", "Không thể lấy thông tin tài khoản");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserProfile() async {
    if (TokenHandler().getToken().isEmpty) {
      setState(() {
        _currentUser = UserModel(
          id: _currentUser?.id ?? "usr_999",
          email: _userEmail,
          phoneNumber: _phoneController.text,
          role: _currentUser?.role,
        );
        _isPhoneEditing = false;
      });
      _showSuccessSnack("Cập nhật số điện thoại thành công! (Mock)");
      return;
    }

    setState(() => _isLoading = true);
    try {
      var result = await http.put(
        Uri.parse(ApiEndpoints.userInfoReadUpdate),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode({
          "email": _userEmail,
          "phoneNumber": _phoneController.text,
        }),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        setState(() {
          _isPhoneEditing = false;
        });
        _showSuccessSnack("Cập nhật số điện thoại thành công!");
        _fetchUserProfile();
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể cập nhật số điện thoại");
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
    if (_isLoading && _currentUser == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.userPage));
    }

    final hasRole = _currentUser?.role != null && _currentUser!.role!.isNotEmpty;
    final roleString = hasRole ? _currentUser!.role!.join(', ') : 'Chưa gán quyền';

    return RefreshIndicator(
      onRefresh: _fetchUserProfile,
      color: AppColors.userPage,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thẻ Thông tin cá nhân gọn nhẹ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Mã tài khoản", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(_currentUser?.id ?? "usr_999", style: const TextStyle(fontSize: 14, fontFamily: 'monospace')),
                    const SizedBox(height: 16),
                    const Text("Địa chỉ Email", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(_userEmail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Text("Quyền hạn", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(roleString, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.userPage)),
                    const SizedBox(height: 16),
                    const Text("Số điện thoại", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    _isPhoneEditing
                        ? Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.check, color: AppColors.success),
                                onPressed: _updateUserProfile,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: AppColors.danger),
                                onPressed: () {
                                  setState(() {
                                    _phoneController.text = _currentUser?.phoneNumber ?? "";
                                    _isPhoneEditing = false;
                                  });
                                },
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _currentUser?.phoneNumber == null || _currentUser!.phoneNumber!.isEmpty
                                    ? "Chưa đăng ký số điện thoại"
                                    : _currentUser!.phoneNumber!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.userPage),
                                onPressed: () {
                                  setState(() {
                                    _isPhoneEditing = true;
                                  });
                                },
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
