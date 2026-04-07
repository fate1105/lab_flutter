import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormApp extends StatefulWidget {
  const FormApp({super.key});

  @override
  State<FormApp> createState() => _FormAppState();
}

class _FormAppState extends State<FormApp> {
  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Application')),
      body: SingleChildScrollView( // tránh overflow
        child: Column(
          children: <Widget>[
            const Icon(Icons.account_circle, size: 100, color: Colors.blue),

            CustomTextField(
              label: 'First Name',
              controller: firstNameController,
            ),
            CustomTextField(
              label: 'Last Name',
              controller: lastNameController,
            ),

            const CustomTextField(
              label: 'Email',
              suffixText: '@mlritm.ac.in',
            ),
            const CustomTextField(
              prefixText: '+91 ',
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),

            const Divider(indent: 8, endIndent: 8),

            const CustomTextField(label: 'Username'),
            const CustomTextField(label: 'Password', obscureText: true),
            const CustomTextField(label: 'Confirm Password', obscureText: true),

            ElevatedButton(
              onPressed: () {
                String fullName = '${firstNameController.text} ${lastNameController.text}'.trim();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Registration Successful"),
                    content: Text("Welcome, $fullName"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? suffixText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.suffixText,
    this.prefixText,
    this.keyboardType,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffixText,
          prefixText: prefixText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}