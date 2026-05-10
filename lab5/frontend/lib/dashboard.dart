import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  late Map<String, dynamic> jwtDecodedToken;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'] ?? 'unknown_id';
    getTodoList(userId);
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text
      };

      var response = await http.post(
        Uri.parse(addtodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print("Something went wrong");
      }
    }
  }

  void getTodoList(userId) async {
    var regBody = {"userId": userId};

    var response = await http.post(
      Uri.parse(getToDoList),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    var regBody = {"id": id};

    var response = await http.post(
      Uri.parse(deleteTodo),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getTodoList(userId);
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "ToDo (Spring Boot + MongoDB)",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: logout,
            tooltip: "Logout",
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔑 JWT TOKEN PRESENTATION & INSPECTOR (Teacher Presentation Mode)
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, color: Colors.indigo, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "JWT AUTH INSPECTOR",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.token));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Copied JWT token to clipboard!"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(Icons.copy, size: 14),
                        label: Text("Copy JWT"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 20, thickness: 1),
                  
                  // Display raw token string (Scrollable or Selectable)
                  Text(
                    "Raw JWT Token:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    height: 50,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: SelectableText(
                        widget.token,
                        style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.grey[800]),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Decoded token contents
                  Text(
                    "Decoded JWT Claims (Payload):",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Column(
                    children: jwtDecodedToken.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${entry.key}: ",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace', color: Colors.blue[900]),
                            ),
                            Expanded(
                              child: Text(
                                "${entry.value}",
                                style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.black87),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Task counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${items?.length ?? 0} Tasks",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                  ),
                ),
              ],
            ),
          ),

          // Tasks List view
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: items == null
                  ? Center(child: CircularProgressIndicator())
                  : items!.isEmpty
                      ? Center(
                          child: Text(
                            "No tasks added yet!",
                            style: TextStyle(color: Colors.grey[500], fontSize: 14),
                          ),
                        )
                      : ListView.builder(
                          itemCount: items!.length,
                          itemBuilder: (context, int index) {
                            return Slidable(
                              key: ValueKey(items![index]['_id']),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    onPressed: (BuildContext context) {
                                      deleteItem('${items![index]['_id']}');
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 1,
                                margin: EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue[50],
                                    child: Icon(Icons.task_alt, color: Colors.blueAccent, size: 20),
                                  ),
                                  title: Text(
                                    '${items![index]['title']}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '${items![index]['desc']}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  trailing: Icon(Icons.arrow_back_ios, size: 12, color: Colors.grey[400]),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        tooltip: 'Add-ToDo',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Add New Task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoTitle,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Enter task title",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ).py8(),
              TextField(
                controller: _todoDesc,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter task description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ).py8(),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      addTodo();
                    },
                    child: Text("Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
