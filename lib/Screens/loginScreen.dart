import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/other_files/global.dart';
import '../../Screens/registration.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/Home Screens/homepage.dart';
import '../activity/common_dialog.dart';
import '../activity/forgotpasswprd.dart';
import '../other_files/loading.dart';



class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool isloading = false;
  bool _isobscured = true;
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  Future<void> login() async {
    final mobile = _phoneNumber.text.trim();
    final password = _password.text.trim();

    // 🔹 Basic Validation
    if (mobile.isEmpty) {
      showCustomBar("Please enter mobile number", Colors.red);
      return;
    }
    if (password.isEmpty) {
      showCustomBar("Please enter password", Colors.red);
      return;
    }

    final url = Uri.parse('${GlobalVariables.baseUrl}appadmin/api/member_login');
    log("login URL : $url");
    final requestBody = {
      'mobile': mobile,
      'password': password,
    };
    // 🔹 Print request body
    log("Request Body: $requestBody");

    try {
      MyCustomLoading.start(context);

      final response = await http.post(url, body: requestBody);

      log("login response : ${response.body}");
      log("login status   : ${response.statusCode}");

      if (response.statusCode != 200) {
        _fail("Login failed. Try again.");
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] != true) {
        String msg = data['msg'];
        MyCustomLoading.stop();
        await showCommonDialog(
          context: context,
          title: "Alert!",
          message: msg??"For more information contact admin",
          confirmText: "Ok",
          showCancelBtn: false,
          confirmColor: Colors.red,
        );
        return;
      }

      final emp = data['emp'];

      // 🔹 Save User Data
      final prefs = await SharedPreferences.getInstance();
      final profileImage = emp['profile_image'];
      final firstImage = profileImage.isNotEmpty ? profileImage.split(',')[0] : "";

      await prefs.setString('id', emp['id']);
      await prefs.setString('member_id', emp['member_id']);
      await prefs.setString('name', emp['name']);
      await prefs.setString('email', emp['email']);
      await prefs.setString('mobile', emp['mobile']);
      await prefs.setString('gender', emp['gender']);
      await prefs.setString('profile_image', firstImage);
      await prefs.setBool('loginStatus', true);

      MyCustomLoading.stop();
      showCustomBar("Login successful", Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            wishlistmemberid: emp['id'],
            interestedmemberid: emp['id'],
          ),
        ),
      );
    } catch (e) {
      _fail("Something went wrong.");
      log("Login Exception: $e");
    }
  }

  void _fail(String msg) {
    MyCustomLoading.stop();
    showCustomBar(msg, Colors.red);
  }

  void showCustomBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message, style: const TextStyle(fontSize: 16.0, color: Colors.white),),),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
      ),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      _isobscured = !_isobscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 24,color: Colors.red),
                    ),
                    Text(
                      "Welcome to Sign in to Your\nPerfect Match.",
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ],
                ),
              )),
              Lottie.asset("assets/json/matrimony.json"),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: TextFormField(
                  controller: _phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone no",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: TextFormField(
                  controller: _password,
                  obscureText: _isobscured,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isobscured = !_isobscured;
                        });
                      },
                      icon: Icon(
                        _isobscured ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
               Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont't have an account?",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const register_Page()));
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
