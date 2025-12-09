// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/Home Screens/myprofile.dart';
import '../activity/SearchScreen/searchpage.dart';
import '../myprofile/moonsigns.dart';
import '../myprofile/stars.dart';
import '../other_files/global.dart';

class education extends StatefulWidget {
  final String memberId;
  final String id;

  const education({super.key, required this.memberId, required this.id});

  @override
  State<education> createState() => _educationState();
}

class _educationState extends State<education> {
  TextEditingController educationdetails=TextEditingController();
  TextEditingController employedin=TextEditingController();
  TextEditingController incomecontroller=TextEditingController();
  TextEditingController percontroller=TextEditingController();
  TextEditingController Occupationdetails=TextEditingController();

  String? selectedEployeedin;
  String? selectvaluePer;
    List<Job> jobList = [];
  
    Future<void> fetchJobs() async {
    final response = await http.get(Uri.parse('${GlobalVariables.baseUrl}appadmin/api/jobs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['msg'];
      setState(() {
        jobList = jsonResponse.map((job) => Job.fromJson(job)).toList();
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }
 

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
        fetchJobs();
  }
  void showCustomBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  void updateProfile() async {
    const apiUrl = "${GlobalVariables.baseUrl}appadmin/api/education_detail_update";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;

    final userData = {
      'id': memberId,
      'employedin': employedin.text,
      'education_details': educationdetails.text,
      'income': incomecontroller.text,
      'per': percontroller.text,
      'occupation_details': Occupationdetails.text,
    };

    print(userData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );

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
                builder: (context) => MyProfile(
                  memberId: "1",
                  id: "1",
                )));
      } else {
        // Handle errors
        print("Error updating profile. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      // Handle other exceptions
      print("Error updating profile: $e");
    }
  }

  List<dynamic> profileData = [];

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;


    final url = Uri.parse('${GlobalVariables.baseUrl}appadmin/api/myprofile?member_id=$memberId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          profileData = [jsonResponse['member_details']];
          setState(() {
            selectvaluePer = profileData[0]['per'];
            educationdetails.text =profileData[0]['education_details'];
            incomecontroller.text =profileData[0]['income'];
            selectedEployeedin =profileData[0]['employedin'];
            Occupationdetails.text =profileData[0]['occupation_details'];
            employedin.text = profileData[0]['employedin'];
            percontroller.text = profileData[0]['per'];

          });
        });

      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }

  // void _updateEducationDetails() async {
  //   final updateEducationDetailsModel = UpdateEducationDetailsModel(
  //     // Replace with the actual profile ID
  //     employedIn: employedin.text,
  //     educationDetails: educationdetails.text,
  //     income: income.text,
  //     per: per.text,
  //     occupationDetails: occupation.text,
  //   );
  //
  //   final profileService = ProfileService();
  //   await profileService.updateEducationDetails(updateEducationDetailsModel);
  //
  //   // After the update, you can add any additional logic or navigation
  // }
  Nakshatra selectedNakshatra = nakshatras[0];
  MoonSign selectedMoonsign = moonSigns[0];
  // List<String> occupationOptions = [
  //   "--select an option--",
  //   "Business",
  //   "Defence",
  //   "Government",
  //   "Not Working",
  //   "Others",
  //   "Private",
  //   "Self Employed",
  // ];
  List<String> paymentFrequencyOptions = [
    "--select an option--",
    "PerMonth",
    "PerAnnual"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        backgroundColor: Colors.red,
        title: Text("Education & Occupation Details",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: educationdetails,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Education Details",labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
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
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  initialValue: selectedEployeedin,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Employed in",labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent
                            .withOpacity(0.7),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: null,
                  // This will remove the dropdown icon
                  items: jobList.map<DropdownMenuItem<String>>((Job job) {
                    return DropdownMenuItem(
                     value: job.job,
                    child: Text(job.job),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    selectedEployeedin = value.toString();
                    employedin.text = value!;
                    // Handle the selected value
                    print("Selected value: $value");
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: incomecontroller,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Income",labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
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
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return null;
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  initialValue: selectvaluePer,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Per",labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent
                            .withOpacity(0.7),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: null,
                  // This will remove the dropdown icon
                  items:
                  paymentFrequencyOptions.map((String option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    percontroller.text= value!;
                    // Handle the selected value
                    print("Selected value: $value");
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: Occupationdetails,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Occupation Details",labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
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
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed:(){

                  updateProfile();
                },
                  // _updateEducationDetails,

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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
