import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/accounts/login.dart';

String fetchEmailFromToken({required BuildContext context}) {
  if (TokenHandler().getToken().isEmpty) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
    return "";
  }

  final decodedToken = JwtDecoder.decode(TokenHandler().getToken());
  String email = decodedToken['email'] ?? decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ?? "demo_test@gmail.com";

  return email;
}
