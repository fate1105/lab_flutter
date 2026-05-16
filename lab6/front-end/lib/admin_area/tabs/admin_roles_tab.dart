import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/role_model.dart';
import 'package:user_management/shared/confirmation_dialog.dart';
import 'package:user_management/shared/error_dialog.dart';

class AdminRolesTab extends StatefulWidget {
  const AdminRolesTab({super.key});

  @override
  State<AdminRolesTab> createState() => _AdminRolesTabState();
}

class _AdminRolesTabState extends State<AdminRolesTab> {
  List<RoleModel> _roles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  // ==================== CALL APIs ====================

  Future<void> _fetchRoles() async {
    setState(() => _isLoading = true);
    try {
      final result = await http.get(
        Uri.parse(ApiEndpoints.adminRolesCrud),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(result.body);
        setState(() {
          _roles = jsonData.map((role) => RoleModel.fromJson(role)).toList();
        });
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể tải danh sách quyền");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRole(String id) async {
    setState(() => _isLoading = true);
    try {
      final result = await http.delete(
        Uri.parse(ApiEndpoints.adminRolesCrud),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode(id),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        _showSuccessSnack("Xóa vai trò thành công");
        _fetchRoles();
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể xóa vai trò");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitAddRole(String roleName) async {
    setState(() => _isLoading = true);
    try {
      var result = await http.post(
        Uri.parse(ApiEndpoints.adminRolesCrud),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${TokenHandler().getToken()}',
        },
        body: jsonEncode(roleName),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        Navigator.pop(context);
        _showSuccessSnack("Thêm vai trò mới thành công!");
        _fetchRoles();
      } else {
        _showError(result.statusCode, result.body);
      }
    } catch (e) {
      _showCustomError("Lỗi", "Không thể thêm vai trò");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ==================== WIDGETS ====================

  void _openAddRoleSheet() {
    final formKey = GlobalKey<FormState>();
    final roleNameController = TextEditingController();

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Thêm Vai Trò Mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                TextFormField(
                  controller: roleNameController,
                  decoration: const InputDecoration(
                    labelText: "Tên vai trò",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập tên vai trò";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.adminSecondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _submitAddRole(roleNameController.text.trim());
                    }
                  },
                  child: const Text("Tạo Vai Trò", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
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
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _fetchRoles,
          child: _roles.isEmpty
              ? const Center(child: Text("Không có vai trò nào"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _roles.length,
                  itemBuilder: (context, idx) {
                    final role = _roles[idx];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.shield, color: AppColors.adminPage),
                        title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("ID: ${role.id}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showConfirmationDialog(
                              context: context,
                              title: "Xóa Vai Trò",
                              content: "Bạn có chắc chắn muốn xóa vai trò ${role.name}?",
                              color: AppColors.adminPage,
                            );
                            if (confirm == true) {
                              _deleteRole(role.id);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: AppColors.adminPage)),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.adminSecondary,
            onPressed: _openAddRoleSheet,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        )
      ],
    );
  }
}
