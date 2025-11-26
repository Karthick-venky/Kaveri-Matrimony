import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Screens/registration.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/Home Screens/homepage.dart';
import '../activity/forgotpasswprd.dart';



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
  static const String baseURL =
      'http://kaverykannadadevangakulamatrimony.com/appadmin/api/';
  static const String loginEndpoint = 'member_login';

  Future<void> login(String phoneNumber, String password) async {
    if(_phoneNumber.text=="")
    {
      showCustomBar("Please Enter Mobile Number", Colors.red);
    }
    else if(_password.text=="")
    {
      showCustomBar("Please Enter Password", Colors.red);
    }
    else
      {
        const String apiUrl = '$baseURL$loginEndpoint';

        final Map<String, String> requestData = {
          'mobile': _phoneNumber.text,
          'password': _password.text,
        };
        try {
          final http.Response response = await http.post(
            Uri.parse(apiUrl),
            body: requestData,
          );
          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);
            if (data['status']) {

              final profileImage = data['emp']['profile_image'];
              final finalImage;
              if(profileImage!="")
              {
                int semicolonIndex = profileImage.indexOf(",");
                if (semicolonIndex != -1) {
                  finalImage = profileImage.substring(0, semicolonIndex);
                }
                else
                {
                  finalImage = profileImage;
                }
              }
              else
              {
                finalImage = "";
              }
              log('data : ${data['emp']}');

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('id', data['emp']['id']);
              await prefs.setString('member_id', data['emp']['member_id']);
              await prefs.setString('name', data['emp']['name']);
              await prefs.setString('email', data['emp']['email']);
              await prefs.setString('mobile', data['emp']['mobile']);
              await prefs.setString('gender', data['emp']['gender']);
              await prefs.setString('profile_image',finalImage);
              await   prefs.setBool('loginStatus', true);
              String memberId = data['emp']['id'];
              print(memberId);
              showCustomBar("Login SuccessFully", Colors.green);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeScreen(wishlistmemberid:memberId,interestedmemberid:memberId,)));

            } else {
              showCustomBar("Invalid Mobile Number or Password", Colors.red);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const loginScreen()));
            }
          } else {
            showCustomBar("Failed to Login.Please try again", Colors.red);
          }
        } catch (e) {
          print("Exception :$e");
          showCustomBar("Failed to Login.Please try again", Colors.red);
        }
      }
  }

  void showCustomBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
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
                    login(_phoneNumber.text, _password.text);
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
