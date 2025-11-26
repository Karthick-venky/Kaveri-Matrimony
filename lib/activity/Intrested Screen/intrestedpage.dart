// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomBar/bottombar.dart';
import '../Home Screens/viewprofile.dart';

class intrestedScreen extends StatefulWidget {
  const intrestedScreen({super.key});

  @override
  State<intrestedScreen> createState() => _intrestedScreenState();
}

class _intrestedScreenState extends State<intrestedScreen> {
  List<dynamic> intrestList = [];

  String member_id = "";

  @override
  void initState() {
    super.initState();
    fetchIntrestList();
  }

  Future<void> fetchIntrestList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    member_id = prefs.getString("id")!;
    log('member_id: $member_id');

    final apiUrl = 'http://kaverykannadadevangakulamatrimony.com/appadmin/api/interest_request?member_id=$member_id';
    print(apiUrl);
    final response = await http.get(Uri.parse(apiUrl));
    log('jsonDataone :${response.body}');

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      log('jsonDataone :$jsonData');

      setState(() {
        intrestList = jsonData['Result'];
        log('intrestList : $intrestList');
      });
    } else {
      throw Exception(
          'Failed to load employee data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the back icon here
          ),
          backgroundColor: const Color(0xFFB30000),
          title: const Text(
            "INTERESTED PROFILE",
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomBar(index: 3),
        body: intrestList.isEmpty
            ? Center(
                child: Text('No data Available'),
              )
            : ListView.builder(
                itemCount: intrestList.length,
                itemBuilder: (_, index) {
                  final intresting = intrestList[index];
                  log("intresting : $intresting");
                  final profileImage = intresting['profile_image'];
                  final finalImage;
                  if (profileImage != "") {
                    int semicolonIndex = profileImage.indexOf(",");
                    if (semicolonIndex != -1) {
                      finalImage = profileImage.substring(0, semicolonIndex);
                    } else {
                      finalImage = profileImage;
                    }
                  } else {
                    finalImage = "";
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>  viewProfile(member_id: "${user}"),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 66.1, left: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: finalImage == ""
                                            ? Image.asset(
                                            "assets/user_images.png")
                                            : Image.network('https://kaverykannadadevangakulamatrimony.com/profile_image/$finalImage',
                                                fit: BoxFit.cover,
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Text(
                                              intresting['name'] ?? "",
                                              style: GoogleFonts.openSans(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            intresting['member_id'] ?? "",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Text(
                                              intresting['countryofliving'] ==
                                                      null
                                                  ? ""
                                                  : intresting[
                                                      'countryofliving'],
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 16,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            intresting['marital_status'] ==
                                                    "Unmarried"
                                                ? ""
                                                : "மறுமணம்",
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      //todo education
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Education: ',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Container(
                                            width: width / 2.2,
                                            child: Text(
                                              intresting['education_details']??'-',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFFFE0808),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //todo occupation
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Occupation: ',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Container(
                                            width: width / 2,
                                            child: Text(
                                              intresting[
                                                      'occupation_details'] ??
                                                  "-",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFFFE0808),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //todo income

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Income: ',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              intresting['income'] ?? "-",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFFFE0808),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width / 6,
                                            child: Text(
                                              intresting['per'] ?? "",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFFFE0808),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Row(
                                      //   children: [
                                      //     Container(
                                      //       child: Text(
                                      //         intresting['marital_status']=="Unmarried"?"":"மறுமணம்",
                                      //         style: GoogleFonts.nunitoSans(
                                      //           fontSize: 14,
                                      //           color: Colors.green,
                                      //           fontWeight: FontWeight.bold,
                                      //           fontStyle: FontStyle.italic,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dob-Age: ',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            intresting['dob'] ?? "-",
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFFFE0808)),
                                          ),
                                          Text(
                                            '  (${intresting['age']})',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF368EFB)),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            'Height: ',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            intresting['height'] ?? "-",
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFFFE0808)),
                                          )
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Father kula: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              '${intresting['kula_tname']??'-'}',
                                              // intresting['kula_tname'].toString()??""
                                              //     "/"
                                              //     intresting['kula_ename'].toString()??"",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFF368EFB),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width / 6,
                                            child: Text( " "+
                                              intresting['kula_ename'] ??
                                                  "",
                                              // intresting['kula_tname'].toString()??""
                                              //     "/"
                                              //     intresting['kula_ename'].toString()??"",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFF368EFB),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Mother kula: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              '${intresting['motherkula_tname']??"-"}',
                                              // intresting['kula_tname'].toString()??""
                                              //     "/"
                                              //     intresting['kula_ename'].toString()??"",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFF368EFB),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width / 6,
                                            child: Text(" "+
                                              intresting['motherkula_ename']??"",
                                              // intresting['kula_tname'].toString()??""
                                              //     "/"
                                              //     intresting['kula_ename'].toString()??"",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFF368EFB),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'MoonSign: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                200,
                                            child: Text(
                                              intresting['moonsign']??'-',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Star: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                200,
                                            child: Text(
                                              intresting['star']??'-',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      intresting['patham'] == "" ? SizedBox():
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Patham: ',
                                                  style: GoogleFonts.nunitoSans(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    200,
                                                child: Text(
                                                  intresting['patham']??'-',
                                                  style: GoogleFonts.nunitoSans(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ),


                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Lagnam: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width -
                                                200,
                                            child: Text(
                                              intresting['lagnam']??'-',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Dosam: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 40,
                                            child: Text(
                                              intresting['dosam'] ?? "-",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Text(
                                              intresting['ddosam'] ?? "",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'City: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            intresting['city'] ??"-",
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF368EFB)),
                                          ),
                                        ],
                                      ),
                                      //todo district
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'District: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            intresting['district'] ?? "-",
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF368EFB)),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'State: ',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            intresting['state']??'-',
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF368EFB)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFDF0A0A),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        minimumSize: Size(150, 35),
                                      ),
                                      onPressed: () {
                                        // sendIntrestStatus(
                                        //   member_id: member_id,
                                        //   profile_id: intresting['id'],
                                        // );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => viewProfile(
                                              memberId: intresting['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "View Profile",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
