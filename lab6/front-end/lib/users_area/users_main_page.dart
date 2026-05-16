import 'package:flutter/material.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/services/role_check.dart';
import 'package:user_management/shared/custom_appbar.dart';
import 'package:user_management/users_area/tabs/user_profile_tab.dart';
import 'package:user_management/users_area/tabs/user_security_tab.dart';

class UsersMainPage extends StatefulWidget {
  const UsersMainPage({super.key});

  @override
  State<UsersMainPage> createState() => _UsersMainPageState();
}

class _UsersMainPageState extends State<UsersMainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    RoleCheck().checkUserRole(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabTitles = ["Trang Cá Nhân", "Bảo Mật & Cài Đặt"];

    return Scaffold(
      backgroundColor: AppColors.userLight,
      appBar: CustomAppbar(
        title: tabTitles[_currentIndex],
        color: _currentIndex == 1 ? AppColors.userSecondary : AppColors.userPage,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          UserProfileTab(),
          UserSecurityTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.userPage,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined),
              activeIcon: Icon(Icons.account_box, color: AppColors.userPage),
              label: 'Cá nhân',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security_outlined),
              activeIcon: Icon(Icons.security, color: AppColors.userPage),
              label: 'Bảo mật',
            ),
          ],
        ),
      ),
    );
  }
}
