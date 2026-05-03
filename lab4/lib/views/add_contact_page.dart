import 'package:flutter/material.dart';
import '../controllers/crud_services.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});
  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm liên hệ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Tên")),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Số điện thoại")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                CRUDService().addNewContacts(_nameController.text, _phoneController.text, _emailController.text);
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }
}
