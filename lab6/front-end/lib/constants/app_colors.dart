import 'package:flutter/material.dart';

class AppColors {
  // Giao diện lỗi / không rõ quyền hạn
  static const Color unknownRolesPage = Color(0xFFE11D48); // Rose 600

  // Phân hệ Admin (Sử dụng tone Indigo & Violet sang trọng)
  static const Color adminPage = Color(0xFF6366F1); // Indigo 500 (Primary)
  static const Color adminSecondary = Color(0xFF8B5CF6); // Violet 500 (Accent)
  static const Color adminDark = Color(0xFF1E1B4B); // Indigo 950
  static const Color adminLight = Color(0xFFEEF2F6); // Slate 50 (Background)

  // Phân hệ User (Sử dụng tone Teal & Cyan thanh thoát)
  static const Color userPage = Color(0xFF0D9488); // Teal 600 (Primary)
  static const Color userSecondary = Color(0xFF06B6D4); // Cyan 500 (Accent)
  static const Color userDark = Color(0xFF115E59); // Teal 800
  static const Color userLight = Color(0xFFF0FDFA); // Teal 50 (Background)

  // Các màu trung tính và hỗ trợ khác
  static const Color textDark = Color(0xFF1E293B); // Slate 800
  static const Color textLight = Color(0xFF64748B); // Slate 500
  static const Color cardBg = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color danger = Color(0xFFEF4444); // Red 500
  static const Color success = Color(0xFF10B981); // Emerald 500
}
