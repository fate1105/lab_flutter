import 'package:flutter/material.dart';
import '../controllers/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await AuthService().loginWithEmail(_emailController.text, _passwordController.text);
                if (result == "Login Successful") {
                  Navigator.pushReplacementNamed(context, "/home");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                }
              },
              child: const Text("Đăng nhập"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/signup"),
              child: const Text("Chưa có tài khoản? Đăng ký"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await AuthService().continueWithGoogle();
                if (result == "Google Login Successful") Navigator.pushReplacementNamed(context, "/home");
              },
              child: const Text("Đăng nhập với Google"),
            ),
          ],
        ),
      ),
    );
  }
}