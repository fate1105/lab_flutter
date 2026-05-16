import 'package:flutter/material.dart';
import 'package:user_management/admin_area/tabs/admin_profile_tab.dart';
import 'package:user_management/admin_area/tabs/admin_roles_tab.dart';
import 'package:user_management/admin_area/tabs/admin_users_tab.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/services/role_check.dart';
import 'package:user_management/shared/custom_appbar.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    RoleCheck().checkAdminRole(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabTitles = ["Quản Lý Người Dùng", "Danh Sách Vai Trò", "Hồ Sơ Admin"];

    return Scaffold(
      backgroundColor: AppColors.adminLight,
      appBar: CustomAppbar(
        title: tabTitles[_currentIndex],
        color: _currentIndex == 2 ? AppColors.adminSecondary : AppColors.adminPage,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          AdminUsersTab(),
          AdminRolesTab(),
          AdminProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.adminPage,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people, color: _currentIndex == 2 ? AppColors.adminSecondary : AppColors.adminPage),
              label: 'Người dùng',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shield_outlined),
              activeIcon: Icon(Icons.shield, color: _currentIndex == 2 ? AppColors.adminSecondary : AppColors.adminPage),
              label: 'Vai trò',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, color: _currentIndex == 2 ? AppColors.adminSecondary : AppColors.adminPage),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
    );
  }
}
