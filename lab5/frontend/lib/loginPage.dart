import 'dart:convert';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody),
        );

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status']) {
          var myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(token: myToken)),
          );
        } else {
          showErrorDialog(jsonResponse['message'] ?? 'Invalid email or password');
        }
      } catch (e) {
        showErrorDialog('Cannot connect to backend server. Make sure it is running!');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.check_circle_outline, size: 80, color: Colors.blueAccent),
                SizedBox(height: 16),
                Text(
                  "Spring Boot To-Do",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                Text(
                  "Sign in to your account",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 32),
                
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "example@gmail.com",
                    errorText: _isNotValidate && emailController.text.isEmpty ? "Email is required" : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ).py8(),
                
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "••••••••",
                    errorText: _isNotValidate && passwordController.text.isEmpty ? "Password is required" : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ).py8(),
                
                SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loginUser,
                    child: Text("LOG IN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ).py16(),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                      Text("Sign Up", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ],
                  ).py8(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}