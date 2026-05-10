import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          showSuccessDialog("Account registered successfully! Click OK to sign in.");
        } else {
          showErrorDialog(jsonResponse['message'] ?? 'Registration failed.');
        }
      } catch (e) {
        showErrorDialog("Cannot connect to backend server. Make sure it is running!");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
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
                Icon(Icons.person_add_outlined, size: 80, color: Colors.blueAccent),
                SizedBox(height: 16),
                Text(
                  "Create Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                Text(
                  "Join the Spring Boot To-Do App",
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
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter or generate password",
                    errorText: _isNotValidate && passwordController.text.isEmpty ? "Password is required" : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy, size: 18),
                          onPressed: () {
                            if (passwordController.text.isNotEmpty) {
                              Clipboard.setData(ClipboardData(text: passwordController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Password copied to clipboard!")),
                              );
                            }
                          },
                          tooltip: "Copy Password",
                        ),
                        IconButton(
                          icon: Icon(Icons.vpn_key_outlined, size: 18),
                          onPressed: () {
                            String passGen = generatePassword();
                            passwordController.text = passGen;
                            setState(() {});
                          },
                          tooltip: "Generate Password",
                        ),
                      ],
                    ),
                  ),
                ).py8(),
                
                SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: registerUser,
                    child: Text("REGISTER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ).py16(),
                
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already registered? ", style: TextStyle(color: Colors.grey[600])),
                      Text("Sign In", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*';

  String password = '';
  int passLength = 12;
  String seed = upper + lower + numbers + symbols;
  List<String> list = seed.split('').toList();
  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}