import 'package:flutter/material.dart';
import '../controllers/crud_services.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({super.key});
  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String docID = "";

  @override
  void didChangeDependencies() {
    final Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      _nameController.text = args["data"]["name"];
      _phoneController.text = args["data"]["phone"];
      _emailController.text = args["data"]["email"];
      docID = args["id"];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sửa liên hệ")),
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
                CRUDService().updateContact(_nameController.text, _phoneController.text, _emailController.text, docID);
                Navigator.pop(context);
              },
              child: const Text("Cập nhật"),
            ),
          ],
        ),
      ),
    );
  }
}
