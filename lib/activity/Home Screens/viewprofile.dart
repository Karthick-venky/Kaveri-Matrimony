// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_unnecessary_containers, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../Models/KulaModel.dart';
import '../../export.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ApiUtils.dart';
import '../../Models/view profile model.dart';

class viewProfile extends StatefulWidget {
  final String memberId;

  const viewProfile({super.key, required this.memberId});

  @override
  State<viewProfile> createState() => _viewProfileState();
}

class _viewProfileState extends State<viewProfile> {
  int a = 0;
  int b = 0;
  late Future<List<ViewProfile>> _viewProfileFuture;
  List<dynamic> inresteIdList = [];
  String ownmember_id = "";
  String final_image1 = "";

 List<KulaModel> kulas = [];

  @override
  void initState() {
    super.initState();
    _viewProfileFuture = _fetchViewProfileData();
    fetchintrestedData();
    fetchKulas();
  }

  void fetchKulas() async {
    print("fetchKulas called");
    kulas = await ApiUtils.fetchKulaList();
    // Set the selectedKula if it's null or not part of the items
    // if (selectedKula == null || !kulas.contains(selectedKula)) {
    //   selectedKula = kulas.isNotEmpty ? kulas[0] : null;
    // }
    setState(() {});
    print("fetchKulas completed");
  }

  Future<void> fetchintrestedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ownmember_id = prefs.getString("id")!;

    final apiUrl =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/interest_request?member_id=$ownmember_id';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      setState(() {
        List<dynamic> intrestList = jsonData['Result'];
        for (int i = 0; i < intrestList.length; i++) {
          inresteIdList.add(intrestList[i]['id']);
        }
        print(inresteIdList.toString());
      });
    } else {
      throw Exception(
          'Failed to load employee data. Status code: ${response.statusCode}');
    }
  }

  Future<List<ViewProfile>> _fetchViewProfileData() async {
    final viewProfileApiService = ViewProfileApiService(
        baseUrl: 'http://kaverykannadadevangakulamatrimony.com/appadmin');
    return viewProfileApiService.getViewProfile(widget.memberId);
  }

  @override
  Widget build(BuildContext context) {
    // String dynamicMemberId = widget.member_id;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB30000),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        title: const Text("View Profile",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 6, // Number of tabs
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
                tabs: [
                  Tab(text: "Basic"),
                  Tab(text: "Personal"),
                  Tab(text: "Education"),
                  Tab(text: "Astrological"),
                  Tab(text: "Physical"),
                  Tab(text: "Family"),
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
          
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<List<ViewProfile>>(
                    future: _viewProfileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No view profile data found.'));
                      } else {
                        final firstProfile = snapshot.data!
                            .first; // Assuming there's at least one profile

                        final profileImage = firstProfile.profile_image;
                        final String finalImage;

                        if (profileImage != "") {
                          int semicolonIndex = profileImage.indexOf(",");
                          if (semicolonIndex != -1) {
                            finalImage =
                                profileImage.substring(0, semicolonIndex);
                            final_image1 = profileImage.substring(semicolonIndex+1);
                          } else {
                            finalImage = profileImage;
                          }
                        } else {
                          finalImage = "";
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(height: 16.0),
                                                Container(
                                                  height: MediaQuery.of(context).size.height - 500,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: finalImage == ""
                                                      ? Image.asset("assets/user_images.png")
                                                      :
                                                  PhotoView(
                                                    imageProvider: NetworkImage('https://kaverykannadadevangakulamatrimony.com/profile_image/${finalImage}'),
                                                  ),

                                                ),
                                                SizedBox(height: 16.0),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFf9fd00),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                      ),
                                                      minimumSize: const Size(100, 50),
                                                     // onPrimary: Colors.black
                                                  ),
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: finalImage == ""
                                        ? Image.asset("assets/user_images.png")
                                        : Image.network(
                                      'https://kaverykannadadevangakulamatrimony.com/profile_image/${finalImage}',
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              'https://kaverykannadadevangakulamatrimony.com/profile_image/${finalImage}',
                                              height: 150,
                                              width: 150,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                final_image1!=""?
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(height: 16.0),
                                                Container(
                                                  height: MediaQuery.of(context).size.height - 500,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: finalImage == ""
                                                      ? Image.asset("assets/user_images.png")
                                                      :
                                                  PhotoView(
                                                    imageProvider: NetworkImage('https://kaverykannadadevangakulamatrimony.com/profile_image/${final_image1}'),
                                                  ),

                                                ),
                                                SizedBox(height: 16.0),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFFf9fd00),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    minimumSize: const Size(100, 50),
                                                    //onPrimary: Colors.black
                                                  ),
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: final_image1 == ""
                                        ? Image.asset("assets/user_images.png")
                                        : Image.network(
                                      'https://kaverykannadadevangakulamatrimony.com/profile_image/${final_image1}',
                                    ),
                                  ),
                                ):Container()
                              ],),
                              SizedBox(height: 20),
                              SingleChildScrollView(
                                child: Card(
                                  elevation: 8.0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            color: const Color(0xff006400),
                                            child: Center(
                                              child: Text(
                                                "Basic Details",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 130,
                                                  child: Text(
                                                    'NAME',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${firstProfile.name}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 130,
                                                  child: Text(
                                                      "FATHER'S NAME",style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      '${firstProfile.fatherName}',style: TextStyle(color: Colors.red,
                                                      fontWeight:FontWeight.w400 ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    "MOTHER'S NAME",style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "${firstProfile.motherName}",style: TextStyle(color: Colors.red,
                                                      fontWeight:FontWeight.w400 ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'GENDER',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${firstProfile.gender}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'PROFILE CREATED BY',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${firstProfile.profileFor}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'GOTRA',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "${firstProfile.gotra_ename} / ${firstProfile.gotra_tname}",style: TextStyle(color: Colors.red,
                                                      fontWeight:FontWeight.w400 ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'KULA',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "${firstProfile.kula_tname} / ${firstProfile.kula_ename}",style: TextStyle(color: Colors.red,
                                                      fontWeight:FontWeight.w400 )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'DATE OF BIRTH',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${firstProfile.dateofbirth}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'COUNTRY OF LIVING IN',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${firstProfile.countryOfLiving}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'MARITAL STATUS',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    "${firstProfile.maritalStatus}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ),
                                          firstProfile.maritalStatus!="Unmarried"?Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'CHILDERN',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${firstProfile.children}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ):Container(),
                                          firstProfile.maritalStatus!="Unmarried"?Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'CHILDERN LIVING STATUS',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${firstProfile.livingStatus}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ):Container(),
                                          Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'DOSAM',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${firstProfile.dosam}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ),
                                          firstProfile.ddosam!=""?Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'DOSAM DETAILS',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${firstProfile.ddosam}",style: TextStyle(color: Colors.red,
                                                    fontWeight:FontWeight.w400 ),),
                                              ],
                                            ),
                                          ):Container(),
                                          firstProfile.dosamdetails!=""?Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width:130,
                                                  child: Text(
                                                    'DOSAM DETAILS',style: TextStyle(color: Colors.black,
                                                      fontWeight:FontWeight.w500 ),),
                                                ),
                                                Container(
                                                  width: 10,
                                                  child: Text(
                                                    ': ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${firstProfile.dosamdetails}",style: TextStyle(color: Colors.red,
                                                      fontWeight:FontWeight.w400 ),),
                                                ),
                                              ],
                                            ),
                                          ):Container(),
                                        ],
                                      ),
                                      // Add more rows for other details
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<ViewProfile>>(
                    future: _viewProfileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No view profile data found.'));
                      } else {
                        final firstProfile = snapshot.data!
                            .first; // Assuming there's at least one profile
                            log("main data : ${firstProfile}");
                            
                            final  fKula =firstProfile.preffered_kulla ;
                             List<String> kullaIds = fKula.split(',');
                             List<String> englishNames = [];
                             List<String> tamilNames = [];


                                for (String id in kullaIds) {
      KulaModel? matchingKula = kulas.firstWhere(
        (kula) => kula.id == id,
        orElse: () => KulaModel(id: '', englishName: '', tamilName: ''),
      );

      if (matchingKula.id.isNotEmpty) {
        englishNames.add(matchingKula.englishName);
        tamilNames.add(matchingKula.tamilName);
      }
    }

                        return Container(
                          child: Center(
                            child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (_, index) {
                                 
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 8.0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    color:
                                                        const Color(0xFF006400),
                                                    child: const Center(
                                                      child: Text(
                                                        "Personal Details",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "FATHER'S EDUCATION",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.fatherEducation}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "FATHER'S OCCUPATION",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                                "${firstProfile.fOccupation}",style: TextStyle(color: Colors.red,
                                                                fontWeight:FontWeight.w400 ),)),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "MOTHER'S EDUCATION",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.mEducation}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "MOTHER'S OCCUPATION",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.mOccupation}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),
                                                            overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "MOTHER'S GOTRA",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.mothergotra_ename} / ${firstProfile.mothergotra_tname}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "MOTHER'S KULA",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.motherkula_tname} / ${firstProfile.motherkula_ename}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "BROTHER'S",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.bro}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "SISTER'S",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.sis}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "CITIZENSHIP",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.citizenship_name}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "RESIDENT STATUS",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.residentstatus}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(  
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "RESIDENT STATE",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            firstProfile.state_name.toString() ,style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(  
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "RESIDENT DISTRICT",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            firstProfile.district_name.toString() ,style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "RESIDENT CITY",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.city}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "PROFILE DESCRIPTION",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.pdesc}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "ABOUT LIFE PARTNER",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.lifepartner}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "PREFFERED KULA",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${ englishNames.join(', ')}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<ViewProfile>>(
                    future: _viewProfileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No view profile data found.'));
                      } else {
                        final firstProfile = snapshot.data!
                            .first; // Assuming there's at least one profile

                        return Container(
                          child: Center(
                            child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 8.0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    color:
                                                        const Color(0xff006400),
                                                    child: const Center(
                                                      child: Text(
                                                        "Education & Occupation Details",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "EMPLOYED IN",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.employedin}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "INCOME",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.income}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "PER",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${firstProfile.per}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "OCCUATION DETAILS",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.occupation_details}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            "EDUCATION DETAILS",style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              "${firstProfile.education_details}",style: TextStyle(color: Colors.red,
                                                              fontWeight:FontWeight.w400 ),),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<ViewProfile>>(
                    future: _viewProfileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No view profile data found.'));
                      } else {
                        final firstProfile = snapshot.data!
                            .first; // Assuming there's at least one profile

                        return Container(
                          child: Center(
                            child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        inresteIdList.contains(widget.memberId)
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.green,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20,
                                                          left: 10,
                                                          right: 10),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "உங்கள் விருப்பம் சமர்ப்பிக்கப்பட்டது. ",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "விரைவில் ஜாதகம் மற்றும் குடும்ப விபரங்கள் உங்கள் பதிவு எண்ணில் தெரிவிக்கப்படும் நன்றி !",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.green,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20),
                                                  child: Column(
                                                    children: [
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "If you want to get ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                right: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Astrological Details",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Please Click  ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20),
                                                        child: Icon(
                                                          Icons.download,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              // a = 1;
                                                              // b = 0;

                                                              sendIntrestStatus(
                                                                member_id:
                                                                    ownmember_id,
                                                                profile_id: widget
                                                                    .memberId,
                                                              );
                                                            });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFFB30000),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            minimumSize:
                                                                Size(150, 50),
                                                          ),
                                                          child: Text(
                                                            "INTREST",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<ViewProfile>>(
                    future: _viewProfileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No view profile data found.'));
                      } else {
                        final firstProfile = snapshot.data!
                            .first; // Assuming there's at least one profile

                        return Container(
                          child: Center(
                            child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 8.0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    color:
                                                        const Color(0xff006400),
                                                    child: const Center(
                                                      child: Text(
                                                        "Physical Attributes & Details",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'HEIGHT',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.height}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'WEIGHT',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.weight}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'BODY TYPE',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.bodytype}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'COMPLEXION',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.complexion}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'PHYSICAL STATUS',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.physically}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                   Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'FOOD',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text("${firstProfile.food}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<ViewProfile>>(
                    future: _viewProfileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No view profile data found.'));
                      } else {
                        final firstProfile = snapshot.data!
                            .first; // Assuming there's at least one profile

                        return Container(
                          child: Center(
                            child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 8.0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    color:
                                                        const Color(0xff006400),
                                                    child: const Center(
                                                      child: Text(
                                                        "Family Details",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'FAMILY VALUE',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.familyvalue}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'FAMILY STATUS',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.familystatus}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(18.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text(
                                                            'FAMILY TYPE',style: TextStyle(color: Colors.black,
                                                              fontWeight:FontWeight.w500 ),),
                                                        ),
                                                        Container(
                                                          width: 10,
                                                          child: Text(
                                                            ': ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            "${firstProfile.familytype}",style: TextStyle(color: Colors.red,
                                                            fontWeight:FontWeight.w400 ),),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    },
                  ),
          
                ],
              ),
            ),
      
          ],
        ),
      ),
    );
  }

  Future<void> sendIntrestStatus({
    required String member_id,
    required String profile_id,
  }) async {
    const apiUrl =
        'https://kaverykannadadevangakulamatrimony.com/appadmin/api/add_interest';

    final Map<String, dynamic> body = {
      'member_id': member_id,
      'profile_id': profile_id
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => intrestedScreen()));
        print(response.body);
        fetchintrestedData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Intrest Added Successfully"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Error: ${response.statusCode}'); // Handle error response
      }
    } catch (e) {
      print('Exception: $e'); // Handle exceptions
    }
  }
}






