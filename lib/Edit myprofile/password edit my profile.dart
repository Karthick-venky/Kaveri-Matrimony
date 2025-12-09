import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

import '../activity/Home Screens/myprofile.dart';
import '../other_files/global.dart';

class Password extends StatefulWidget {
  final String memberId;
  final String id;
  final String oldpass;

  const Password({super.key, required this.memberId, required this.id,required this.oldpass});


  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


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

  Future<void> changePassword() async {
    // Validate if any field is empty
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Validate if new password and confirm password match
    if (newPasswordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "New password and confirm password do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    if (oldPasswordController.text != widget.oldpass) {
      Fluttertoast.showToast(
        msg: "old password are not correct",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Make API request
    String apiUrl = "${GlobalVariables.baseUrl}appadmin/api/changepassword";
    Map<String, String> body = {
      "member_id": widget.memberId,  // Replace with the actual member_id
      "old_password": oldPasswordController.text,
      "new_password": newPasswordController.text,
      "conform_password": confirmPasswordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);
        if(response.statusCode==200){
          showCustomBar("Successfully",Colors.green);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyProfile(
                    memberId: "1",
                    id: "1",
                  )));
        }else{
        }

      } else {

      }
    } catch (e) {

    }
  }
  void togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
  bool _isObscured = true;
  bool isLoading = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_fetchProfileData();
  }
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.red,
      title: const Text(
          "Change your Password"
      ),
        ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding:  EdgeInsets.only(top:height/25.2),
              child: Center(
                child:
                Padding(
                  padding:  const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: oldPasswordController,
                    obscureText: _isObscured,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                          size: 25,
                          color: const Color(0xffCCC9C9),
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.withOpacity(
                              0.7), // Set your border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
labelText: "Current Password",labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                      border: InputBorder.none,
                    ),

                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:  const EdgeInsets.only(top:0),
              child: Center(
                child:
                Padding(
                  padding:  const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: newPasswordController,
                    obscureText: _isObscured,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                          size: 25,
                          color: const Color(0xffCCC9C9),
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.withOpacity(
                              0.7), // Set your border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "New Password",labelStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                      border: InputBorder.none,
                    ),

                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:  const EdgeInsets.only(top:0),
              child: Center(
                child:
                Padding(
                  padding:  const EdgeInsets.all(8),
                  child: TextFormField(
                    controller:confirmPasswordController,
                    obscureText: _isObscured,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                          size: 25,
                          color: const Color(0xffCCC9C9),
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.withOpacity(
                              0.7), // Set your border color
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "Re-Type Password",labelStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                      border: InputBorder.none,
                    ),

                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: changePassword,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.red,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set your text color
                ),
                minimumSize: const Size(150, 50),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Update",style: TextStyle(
                  color: Colors.black,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
