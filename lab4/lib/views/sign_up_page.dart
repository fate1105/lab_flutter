import 'package:flutter/material.dart';
import '../controllers/auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await AuthService().createAccountWithEmail(_emailController.text, _passwordController.text);
                if (result == "Account Created") {
                  Navigator.pushReplacementNamed(context, "/home");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                }
              },
              child: const Text("Đăng ký"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đã có tài khoản? Đăng nhập"),
            ),
          ],
        ),
      ),
    );
  }
}
