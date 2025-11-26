import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../activity/Home Screens/myprofile.dart';

class family extends StatefulWidget {
  final String memberId;
  final String id;

  const family({super.key, required this.memberId, required this.id});
  @override
  State<family> createState() => _familyState();
}

class _familyState extends State<family> {
  TextEditingController familydetails =TextEditingController();
  TextEditingController familyvalue =TextEditingController();
  TextEditingController familytype =TextEditingController();
  String? selectedFamilyDetails;
  String? selectedFamilyValue;
  String? selectedFamilyType;


  List<String> socioEconomicStatusOptions = [
    "MiddleClass",
    "UpperMiddleClass",
    "Rich",
    "Affluent",
  ];
  List<String> familyValuesOptions = [
    "Orthodox",
    "Traditional",
    "Moderate",
    "Liberal",
  ];

  List<dynamic> profileData = [];

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;

    log('user id : $memberId');


    final url = Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/myprofile?member_id=$memberId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          profileData = [jsonResponse['member_details']];
          log('profileData : $profileData');
        
            selectedFamilyDetails = profileData[0]['familystatus'].isEmpty?socioEconomicStatusOptions[0]:profileData[0]['familystatus'];
            selectedFamilyType = profileData[0]['familytype'].isEmpty ?"Joint":profileData[0]['familytype'].isEmpty;
            selectedFamilyValue = profileData[0]['familyvalue'].isEmpty ?familyValuesOptions[0]:profileData[0]['familyvalue'];
            familydetails.text = profileData[0]['familystatus']??"";
            familyvalue.text = profileData[0]['familyvalue']??"";
            familytype.text = profileData[0]['familytype']??"";
         setState(() {   });
        });

      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProfileData();
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
  void updateProfile() async {
    const apiUrl = "http://kaverykannadadevangakulamatrimony.com/appadmin/api/family_detail_update";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;
    final userData = {
      'id': memberId,
      'familystatus': familydetails.text,
      'familyvalue': familyvalue.text,
      'familytype': familytype.text,
    };

    print(userData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

      print(userData);



      if (response.statusCode == 200) {
        // Successfully updated profile
        print("Profile updated successfully");
        print("Response body: ${response.body}");
        print(userData);
        showCustomBar("Profile updated successfully",Colors.green);
        print(response.body);
        print(response.statusCode);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyProfile(
                  memberId: "1",
                  id: "1",
                )));

      } else {
        // Handle errors
        print("Error updating profile. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        backgroundColor: Colors.red,
        title: const Text(
          "Family Details",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedFamilyDetails,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Select Family Details",
                  labelText: "Family Details",
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items: socioEconomicStatusOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFamilyDetails = value.toString();
                    familydetails.text = selectedFamilyDetails!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedFamilyValue,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Family Value",
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items: familyValuesOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFamilyValue = value.toString();
                    familyvalue.text =selectedFamilyValue! ;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedFamilyType,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Family Type",
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items:   const [
                        DropdownMenuItem(
                          value: "Joint",
                          child: Text("Joint"),
                        ),
                        DropdownMenuItem(
                          value: "Nuclear",
                          child: Text("Nuclear"),
                        ),
                      ],
                onChanged: (value) {
                  setState(() {
                    selectedFamilyType = value.toString();
                    familytype.text = selectedFamilyType!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                updateProfile();
              },
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
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
