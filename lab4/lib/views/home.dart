import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_services.dart';
import '../controllers/crud_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh bạ"), actions: [
        IconButton(onPressed: () => AuthService().logout().then((v) => Navigator.pushReplacementNamed(context, "/login")), icon: const Icon(Icons.logout))
      ]),
      body: Column(
        children: [
          TextField(controller: _searchController, decoration: const InputDecoration(hintText: "Tìm kiếm..."), onChanged: (v) => setState(() {})),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: CRUDService().getContacts(searchQuery: _searchController.text),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(doc["name"]),
                      subtitle: Text(doc["phone"]),
                      trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => Navigator.pushNamed(context, "/update", arguments: {"data": doc.data(), "id": doc.id})),
                      onLongPress: () => CRUDService().deleteContact(doc.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pushNamed(context, "/add"), child: const Icon(Icons.add)),
    );
  }
}
