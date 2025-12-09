// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/loginScreen.dart';
import '../../other_files/api_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Edit myprofile/Add prodile edit myprofile.dart';
import '../../Edit myprofile/Addid edit myprofile.dart';
import '../../Edit myprofile/astrology edit myprofile.dart';
import '../../Edit myprofile/basic details edit my profile.dart';
import '../../Edit myprofile/education edit profile.dart';
import '../../Edit myprofile/family edit myprofile.dart';
import '../../Edit myprofile/horoscope edit myprofile.dart';
import '../../Edit myprofile/password edit my profile.dart';
import '../../Edit myprofile/personal details edit myprofile.dart';
import '../../Edit myprofile/physical edit profile.dart';
import '../../Models/GotraModel.dart';
import '../../Models/KulaModel.dart';
import '../../myprofile/moonsigns.dart';
import '../../myprofile/stars.dart';
import '../../other_files/global.dart';
import '../../other_files/loading.dart';
import '../BottomBar/bottombar.dart';
import '../common_dialog.dart';

class MyProfile extends StatefulWidget {
  final String memberId;
  final String id;

  const MyProfile({super.key, required this.memberId, required this.id});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<String> imagePaths = [];
  @override
  void initState() {
    super.initState();
    fetchGotras();
    fetchKulas();
    _fetchProfileData();
  }

  final ProfileApiService apiService = ProfileApiService();
  String member_id = "";

  List<dynamic> profileData = [];

  String final_image = "";
  String final_image1 = "";

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    member_id = prefs.getString("id")!.toString();
    print('VICKUY >>>>>${member_id}');
    final url = Uri.parse('${GlobalVariables.baseUrl}appadmin/api/myprofile?member_id=${member_id.toString()}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        log('jsonResponse : ${jsonResponse} ');
        log('======================================== ');
        log('jsonResponse : ${jsonResponse['member_details']} ');

        setState(() {
          profileData = [jsonResponse['member_details']];

          log('profileData:${profileData}');
          print(profileData);

           String profile_image = profileData[0]['profile_image']??"";
          if (profile_image != "") {
            int semicolonIndex = profile_image.indexOf(",");
            if (semicolonIndex != -1) {
              final_image = profile_image.substring(0, semicolonIndex);
              final_image1 = profile_image.substring(semicolonIndex + 1);
            } else {
              final_image = profile_image;
            }
          } else {
            final_image = "";
          }
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }

  Future<void> _deleteProfileData(String reason) async {
    log("Deleting account for reason: $reason");
    try {
      final prefs = await SharedPreferences.getInstance();
      final memberId = prefs.getString("id");

      if (memberId == null || memberId.isEmpty) {
        log("❌ No member_id found in SharedPreferences");
        return;
      }

      log("📄 member_id: $memberId");

      final url = Uri.parse('${GlobalVariables.baseUrl}appadmin/api/deleterequest?member_id=$memberId&reason=$reason',);

      log("🌐 [POST] URL: $url");
      MyCustomLoading.start(context);

      final response = await http.post(url, headers: {"Content-Type": "application/json"},);

      MyCustomLoading.stop();

      log("📥 [Response Code] ${response.statusCode}");
      log("📥 [Response Body] ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is! Map<String, dynamic>) {
          log("❌ Invalid JSON format (not a Map)");
          return;
        }

        final msg = jsonResponse["msg"]?.toString() ?? "Request submitted.";

        /// SHOW SUCCESS POPUP
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Delete Request Submitted!"),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close dialog

                  // /// Redirect to login and clear all backstack
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const loginScreen()),);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        log("❌ Failed (Status ${response.statusCode})");
      }
    } catch (e) {
      MyCustomLoading.stop();
      log("❌ [Error] $e");
    }
  }
  TextEditingController gotraController = TextEditingController();
  TextEditingController kulaController = TextEditingController();
  TextEditingController profileForController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController countryOfLivingController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<KulaModel> kulas = [];
  List<GotraModel> gotras = [];
  List<String> profileCreatedByOptions = [
    "--select an option--",
    "Friends",
    "Parents",
    "Relatives",
    "Self",
    "Siblings",
  ];
  List<String> maritalStatusOptions = [
    "--select an option--",
    "Unmarried",
    "Widow/Widower",
    "Divorced",
    "Separator",
    "Others",
  ];
  List<String> visaOptions = [
    "--select an option--",
    "Permanent Resident",
    "Work Permit",
    "Student Visa",
    "Temporary Visa"
  ];
  List<String> occupationOptions = [
    "--select an option--",
    "Business",
    "Defence",
    "Government",
    "Not Working",
    "Others",
    "Private",
    "Self Employed",
  ];
  List<String> paymentFrequencyOptions = [
    "--select an option--",
    "Per Month",
    "Per Annual"
  ];
  List<String> bodyTypeOptions = ["Slim", "Average", "Athletic", "Heavy"];
  List<String> complexionOptions = [
    "Fair",
    "Very Fair",
    "Wheatish",
    "Wheatish Medium",
    "Wheatish Brown",
    "Dark",
  ];
  List<String> socioEconomicStatusOptions = [
    "Middle Class",
    "Upper Middle Class",
    "Rich",
    "Affluent",
  ];
  List<String> familyValuesOptions = [
    "Orthodox",
    "Traditional",
    "Moderate",
    "Liberal",
  ];
  String residentOptions = "--select an option--";
  List<String> genderOptions = ["--select an option--", "Male", "Female"];
  String selectedGender = "--select an option--";
  String selectedProfileCreatedBy = "--select an option--";
  String selectedMaritalStatus = "--select an option--";

  Nakshatra selectedNakshatra = nakshatras[0];
  MoonSign selectedMoonsign = moonSigns[0];
  // Height selectedHeight = heights[0];

  GotraModel? selectedGotra;
  KulaModel? selectedKula;

  void fetchGotras() async {
    print("fetchGotras called");
    gotras = await ApiUtils.fetchGotraList();
    if (selectedGotra == null || !gotras.contains(selectedGotra)) {
      selectedGotra = gotras.isNotEmpty ? gotras[0] : null;
    }
    setState(() {});
    print("fetchGotras completed");
  }

  void fetchKulas() async {
    print("fetchKulas called");
    kulas = await ApiUtils.fetchKulaList();
    // Set the selectedKula if it's null or not part of the items
    if (selectedKula == null || !kulas.contains(selectedKula)) {
      selectedKula = kulas.isNotEmpty ? kulas[0] : null;
    }
    setState(() {});
    print("fetchKulas completed");
  }

  Uint8List? _image;
  File? selectedIMage;

  final List<String> reasons = [
    "Select reason",
    "Found a match",
    "Not getting expected matches",
    "Using another matrimony app",
    "Not interested any more",
    "Others",
  ];

  String selectedReason = "Select reason";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        backgroundColor: const Color(0xFFB30000),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomBar(index: 2),
      body: DefaultTabController(
        length: 10, // Number of tabs
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints.expand(height: 50),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.amber,
              ),
              child: TabBar(
                tabs: const [
                  Tab(text: "Basic"),
                  Tab(text: "Personal"),
                  Tab(text: "Education"),
                  Tab(text: "Astrological"),
                  Tab(text: "Physical"),
                  Tab(text: "Family"),
                  Tab(text: "Add profile"),
                  Tab(text: "Add Id"),
                  Tab(text: "Horoscope"),
                  Tab(text: "Settings"),
                ],
                indicatorWeight: 3,
                labelColor: Color(0xFFDF0A0A),
                unselectedLabelColor: Colors.black,
                indicatorColor: Color(0xFFDF0A0A),
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ), // Color of the underline indicator
              ),
            ),
            //todo
            Expanded(
              child: TabBarView(
                children: [
                  profileData.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width / 18.0),
                                    child: Text(
                                      "Basic Details",
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: width / 18),
                                    child: InkWell(
                                      onTap: () {
                                        print(member_id);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    basicdetails(
                                                      memberId: member_id,
                                                      id: member_id,
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black12,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      'Name',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 3.6),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData.isNotEmpty
                                            ? profileData[0]['name']??""
                                            : "",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),overflow: TextOverflow.ellipsis, // Shows ...
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Father Name",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: width / 8),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['father_name']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Mother Name",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: width / 9),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['mother_name']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Gender",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: width / 4),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['gender']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(height);
                                        print(width);
                                      },
                                      child: Text(
                                        "Profile Created By",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 90),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['profile_for']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Gotra",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 3.46153),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      profileData[0]['gotra_ename'] == null
                                          ? ""
                                          : "${profileData[0]['gotra_ename']??""} / ${profileData[0]['gotra_tname']??""}" ,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Kula",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 3.0508),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['kula_tname'] == null
                                            ? ""
                                            : "${profileData[0]['kula_tname']??""}  / ${profileData[0]['kula_ename']??""}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Date of Birth",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 6.20689),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['dateofbirth']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //!
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "State",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 3.5),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['state_name']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "District",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width / 3.5),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['district_name']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //!
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Country of Living In",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 45),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['countryofliving'] == null
                                          ? ""
                                          : profileData[0]['countryofliving']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Marital Status",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 7.5),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['marital_status']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              profileData[0]['marital_status'] != "Unmarried"
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 18),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Number Of Childern",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 36,
                                          ),
                                          Text(
                                            profileData[0]['children'] == null
                                                ? ""
                                                : profileData[0]['children']??"",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              profileData[0]['marital_status'] != "Unmarried"
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 18),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Childern Living Status",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 36,
                                          ),
                                          Text(
                                            profileData[0]['livingstatus'] ==
                                                    null
                                                ? ""
                                                : profileData[0]['livingstatus']??"",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width / 18.0),
                                    child: Text(
                                      "Personal Details",
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: width / 18),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    personaldetails(
                                                      memberId: member_id,
                                                      id: member_id,
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black12,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Father Education",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 27.69),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['fathereducation']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Father Occupation",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 360),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['foccupation']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Mother  Education",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['meducation']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Father Native",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 8.372),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['father_native']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(height);
                                        print(width);
                                      },
                                      child: Text(
                                        "Mother Native",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['mother_native']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Mother Kula",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 6.545),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${profileData[0]['motherkula_tname']??""} / ${profileData[0]['motherkula_ename']??""}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Mother Gotra",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 60),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${profileData[0]['mothergotra_ename']??""}  /  ${profileData[0]['mothergotra_tname']??""}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Phonenumber",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 55),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['mobile']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Alternate Mobile No",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width / 45),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['alter_mobile']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Landline No",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 70),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['landline_no']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Brother",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 105),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        profileData[0]['bro']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Sisters",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 110),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['sis']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Citizenship",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 80),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Text(
                                      profileData[0]['citizenship_name']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Resident Status",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 47),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        profileData[0]['residentstatus']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: height / 75.6,
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.only(left: width / 18),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         "State",
                              //         style: TextStyle(
                              //           color: Colors.black,
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(left: 125),
                              //         child: Text(
                              //           ":",
                              //           style: TextStyle(
                              //             color: Colors.black,
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: width / 36,
                              //       ),
                              //       Text(
                              //         profileData[0]['state'] ?? '',
                              //         style: GoogleFonts.poppins(
                              //           color: Colors.grey,
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "City",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 135),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    Expanded(
                                      child: Text(
                                        profileData[0]['city']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Residing Address",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 35),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        profileData[0]['raddress']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Profile Description",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 26),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        profileData[0]['pdesc']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "About Life partner",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        profileData[0]['lifepartner']??"",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 18),
                                child: Row(
                                  children: [
                                    Text(
                                      "Preffered Kula",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 60),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 36,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        // Checking if the 'preffered_kulla' is a list
                                        (profileData[0]['preffered_kulla_name'] 
                                                is List)
                                            ? profileData[0]['preffered_kulla_name'] 
                                                .join(
                                                    ', ') // Convert list to string
                                            : profileData[0]['preffered_kulla_name'] ?? ''
                                                .toString(), // Fallback for non-list values
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 75.6,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Education Details &\nOccupation Details",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => education(
                                                    memberId: widget.memberId,
                                                    id: widget.id,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Education Details",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 50),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Expanded(
                                    child: Text(
                                      profileData[0]['education_details']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Employed In",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 90),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['employedin']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Income",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 130),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      profileData[0]['income']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Per",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 165),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['per']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print(height);
                                      print(width);
                                    },
                                    child: Text(
                                      "Occupation Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      profileData[0]['occupation_details']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                          ],
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Astrology Details",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Astrological_Details(
                                                    memberId: member_id,
                                                    id: member_id,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Place of Birth",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 10),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Expanded(
                                    child: Text(
                                      profileData[0]['birth']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Time of Birth",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 9),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['timefor']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Star",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width / 3.2727272727272),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      profileData[0]['star']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Moonsign",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 6),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      profileData[0]['moonsign']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Lagnam",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 5),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      profileData[0]['lagnam']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Horoscope\nMatch",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 7),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['horoscope']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Dosam",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 4.5),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['dosam']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Patham",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 6),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      profileData[0]['patham'] ?? "",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 75.6,
                            ),
                            profileData[0]['ddosam'] != ""
                                ? Padding(
                                    padding: EdgeInsets.only(left: width / 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Dosam Details",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 25),
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 25,
                                        ),
                                        Text(
                                          profileData[0]['ddosam']??"",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            profileData[0]['dosamdetails'] != ""
                                ? Padding(
                                    padding: EdgeInsets.only(left: width / 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Dosam Details",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 25),
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 36,
                                        ),
                                        Text(
                                          profileData[0]['dosamdetails']??"",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: height / 75.6,
                            ),
                          ],
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Physical Details",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => physical(
                                                    memberId: member_id,
                                                    id: member_id,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Height",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 4),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['height']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Weight",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width / 4.235),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['weight']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Body Type",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 6),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    profileData[0]['bodytype']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Complexion",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 8),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['complexion']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print(height);
                                      print(width);
                                    },
                                    child: Text(
                                      "Physical Status ",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 24),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      profileData[0]['physically']??"",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            profileData[0]['physically'] != "Normal"
                                ?Padding(
  padding: EdgeInsets.only(left: width / 18),
  child: Row(
    children: [
      InkWell(
        onTap: () {
          print(height);
          print(width);
        },
        child: Text(
          "Physically Challenged\nDetails",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: width / 24),
        child: Text(
          ":",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      SizedBox(
        width: width / 36,
      ),
      // Use Expanded to let the text take up the remaining space
      Expanded(
        child: Text(
          profileData[0]['phy_details'] ?? "",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          softWrap: true, // Ensures text wraps onto the next line
          overflow: TextOverflow.visible, // Manages overflow properly
        ),
      ),
    ],
  ),
)

                                : Container(),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Habits",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print(height);
                                      print(width);
                                    },
                                    child: Text(
                                      "Food ",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 3.6),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['food']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Family Details",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => family(
                                                    memberId: member_id,
                                                    id: member_id,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Family details",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 10),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['familystatus']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Family Value",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 8.2),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['familyvalue']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Family Type",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 7),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    profileData[0]['familytype']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height / 37.8,
                            ),
                          ],
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height / 75.6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 18.0),
                                    child: Text(
                                      " Profile Image",
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: width / 18),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => PickImage(
                                                      memberId: member_id,
                                                      id: member_id,
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black12,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: final_image == ""
                                    ? Image.asset("assets/user_images.png")
                                    : Image.network(
                                        '${GlobalVariables.baseUrl}profile_image/${final_image}',
                                        height: 300,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                '${GlobalVariables.baseUrl}profile_image/${final_image}',
                                                height: 300,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                              ),
                              final_image1 != ""
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: final_image1 == ""
                                          ? Image.asset("assets/user_images.png")
                                          : Image.network(
                                              '${GlobalVariables.baseUrl}profile_image/${final_image1}',
                                              height: 200,
                                              errorBuilder: (BuildContext context,
                                                  Object exception,
                                                  StackTrace? stackTrace) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      '${GlobalVariables.baseUrl}profile_image/${final_image1}',
                                                      height: 200,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                    )
                                  : Container()
                            ],
                          ),
                      )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Your Id",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Addid(
                                                    memberId: member_id,
                                                    id: member_id,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: Image.network(
                                '${GlobalVariables.baseUrl}aadhar_image/${profileData[0]['aadhar_image']}',
                                width: 300, // Set the width as needed
                                height: 200, // Set the height as needed
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        '${GlobalVariables.baseUrl}aadhar_image/${profileData[0]['aadhar_image']}',
                                        height: 400,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    "Your Horoscope",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Horoscope(
                                                    memberId: member_id,
                                                    id: member_id,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: Image.network('${GlobalVariables.baseUrl}horoscope_image/${profileData[0]['horoscope_image']}',
                                width: 250, // Set the width as needed
                                height: 300, // Set the height as needed
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network('${GlobalVariables.baseUrl}horoscope_image/${profileData[0]['horoscope_image']}', height: 400,),
                                    ],
                                  );
                                }, // Adjust the fit as needed
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  profileData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 75.6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width / 18.0),
                                  child: Text(
                                    " Password",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width / 18),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Password(
                                                  memberId: member_id,
                                                  id: member_id,
                                                  oldpass: profileData[0]
                                                      ['pwd'])));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 18),
                              child: Row(
                                children: [
                                  Text(
                                    "Your Current Password",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 36,
                                  ),
                                  Text(
                                    profileData[0]['pwd']??"",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height / 10),
                            // Delete My Account
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: width / 18),
                              child: Text("Delete My Account", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.textColor),),
                            ),
                            Divider(thickness: 2, color: Colors.black12),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedReason,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: TextStyle(
                                    color: MyColors.textColor,
                                    fontSize: 15,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: MyColors.textColor, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: MyColors.textColor, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),

                                style: TextStyle(color: MyColors.textColor, fontSize: 15,),
                                menuMaxHeight: 350,
                                items: reasons.map((reason) {
                                  return DropdownMenuItem(
                                    value: reason,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(reason, style: TextStyle(color: MyColors.textColor,),),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedReason = value ?? "";
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            // Delete My Account
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedReason == "Select reason" ? Colors.grey : MyColors.submitBtnColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                                  minimumSize: const Size(150, 35),
                                ),
                                onPressed: () async {
                                  final shouldDelete = await showCommonDialog(
                                    context: context,
                                    title: "Delete My Account",
                                    message: "Are you sure you want to Delete Your Account?",
                                    confirmText: "Delete",
                                    confirmColor: Colors.red,
                                  );
                                  log("shouldDelete $shouldDelete");
                                  if (shouldDelete == true) {
                                    _deleteProfileData(selectedReason);
                                  }
                                },
                                child: const Text("Delete My Account", style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            //todo
          ],
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//Gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop(); //close the model sheet
  }

//Camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }
}
