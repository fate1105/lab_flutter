import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/change_role_model.dart';
import 'package:user_management/models/register_model.dart';
import 'package:user_management/models/user_model.dart';
import 'package:user_management/shared/confirmation_dialog.dart';
import 'package:user_management/shared/error_dialog.dart';
import 'package:user_management/shared/text_fields.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // ==================== CALL APIs ====================

  Future<void> _fetchUsers() async {


    setState(() => _isLoading = true);
    try {
      final result = await http.get(
        Uri.parse(ApiEndpoints.adminUsersCrud),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(result.body);
        setState(() {
          _users = jsonData.map((user) => UserModel.fromJson(user)).toList();
        });
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi mạng", "Không thể kết nối máy chủ");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(String id) async {
    setState(() => _isLoading = true);
    try {
      final result = await http.delete(
        Uri.parse(ApiEndpoints.adminUsersCrud),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode(id),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        _showSuccessSnack("Xóa người dùng thành công");
        _fetchUsers();
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể xóa người dùng");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitAddUser(String email, String password, String phone) async {
    setState(() => _isLoading = true);
    try {
      final registerData = RegisterModel(
        email: email,
        password: password,
        phoneNumber: phone,
      );

      var result = await http.post(
        Uri.parse(ApiEndpoints.adminUsersCrud),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode(registerData.toJson()),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        Navigator.pop(context);
        _showSuccessSnack("Thêm người dùng mới thành công!");
        _fetchUsers();
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể thêm người dùng");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitAssignRole(String userEmail, String newRole) async {
    setState(() => _isLoading = true);
    try {
      final changeRole = ChangeRoleModel(
        userEmail: userEmail,
        newRole: newRole,
      );

      final result = await http.post(
        Uri.parse(ApiEndpoints.adminChangeUserRole),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: json.encode(changeRole.toJson()),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        Navigator.pop(context);
        _showSuccessSnack("Thay đổi vai trò thành công!");
        _fetchUsers();
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể thay đổi vai trò");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ==================== WIDGET SHEETS & DIALOGS ====================

  void _openAddUserSheet() {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Thêm Người Dùng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  emailTextField(emailController: emailController),
                  const SizedBox(height: 10),
                  passwordTextField(passwordController: passwordController),
                  const SizedBox(height: 10),
                  phoneNumberField(phoneNumberController: phoneController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.adminPage,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _submitAddUser(emailController.text, passwordController.text, phoneController.text);
                      }
                    },
                    child: const Text("Tạo Tài Khoản", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openChangeRoleSheet(UserModel user) {
    String selectedRole = (user.role != null && user.role!.isNotEmpty) ? user.role!.first : "User";
    final rolesList = ["Admin", "User", "Manager", "Editor"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Thay Đổi Vai Trò: ${user.email}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: "Chọn vai trò mới",
                      border: OutlineInputBorder(),
                    ),
                    items: rolesList.map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          selectedRole = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.adminPage,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => _submitAssignRole(user.email, selectedRole),
                    child: const Text("Xác Nhận Đổi Quyền", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
    final filteredUsers = _users.where((u) {
      final email = u.email.toLowerCase();
      final phone = (u.phoneNumber ?? "").toLowerCase();
      final query = _searchQuery.toLowerCase();
      return email.contains(query) || phone.contains(query);
    }).toList();

    return Stack(
      children: [
        Column(
          children: [
            // Ô tìm kiếm đơn giản
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Tìm kiếm người dùng...",
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            // Danh sách người dùng
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchUsers,
                child: filteredUsers.isEmpty
                    ? const Center(child: Text("Không tìm thấy người dùng nào"))
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, idx) {
                          final user = filteredUsers[idx];
                          final roleStr = (user.role != null && user.role!.isNotEmpty) ? user.role!.join(', ') : 'User';
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.adminLight,
                                child: Text(user.email.isNotEmpty ? user.email[0].toUpperCase() : "?"),
                              ),
                              title: Text(user.email, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("SĐT: ${user.phoneNumber ?? 'Chưa cập nhật'} • Quyền: $roleStr"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.shield_outlined, color: Colors.blue),
                                    tooltip: "Đổi quyền",
                                    onPressed: () => _openChangeRoleSheet(user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    tooltip: "Xóa tài khoản",
                                    onPressed: () async {
                                      final confirm = await showConfirmationDialog(
                                        context: context,
                                        title: "Xác Nhận Xóa",
                                        content: "Bạn có chắc chắn muốn xóa tài khoản ${user.email}?",
                                        color: AppColors.adminPage,
                                      );
                                      if (confirm == true) {
                                        _deleteUser(user.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: AppColors.adminPage)),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.adminPage,
            onPressed: _openAddUserSheet,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        )
      ],
    );
  }
}
