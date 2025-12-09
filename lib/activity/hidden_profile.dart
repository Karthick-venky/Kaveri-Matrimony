import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../other_files/common_snackbar.dart';
import '../other_files/global.dart';
import '../other_files/loading.dart';
import '../other_files/profile_service.dart';
import 'Home Screens/viewprofile.dart';
import 'common_dialog.dart';


class HiddenProfileScreen extends StatefulWidget {
  const HiddenProfileScreen({super.key});

  @override
  State<HiddenProfileScreen> createState() => _HiddenProfileScreenState();
}

class _HiddenProfileScreenState extends State<HiddenProfileScreen> {
  List<dynamic> hiddenList = [];

  String memberId = "";

  @override
  void initState() {
    super.initState();
    fetchHiddenList();
  }

  Future<void> hideProfile({required String loginMemberId, required String profileId,}) async {
    MyCustomLoading.start(context);
    final result = await ProfileService.hideProfile(loginMemberId: loginMemberId, profileId: profileId,);

    if (!mounted) return;

    if (result["status"] == true) {
      CommonSnackBar.show(context, message: result["msg"], backgroundColor: Colors.green,);
      fetchHiddenList();
    } else {
      CommonSnackBar.show(context, message: result["msg"] ?? "Failed", backgroundColor: Colors.red,);
    }
  }


  Future<void> fetchHiddenList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      memberId = prefs.getString("id") ?? "";

      if (memberId.isEmpty) {
        log("❌ No member_id found in SharedPreferences");
        return;
      }

      final apiUrl = '${GlobalVariables.baseUrl}appadmin/api/hiddenprofilelist';

      log("🌐 [POST] URL: $apiUrl");
      log("📌 [POST] member_id: $memberId");

      MyCustomLoading.start(context);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"member_id": memberId},
      );

      log("📥 [STATUS]: ${response.statusCode}");
      log("📥 [RAW RESPONSE]: ${response.body}");

      MyCustomLoading.stop();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        log("📦 [DECODED JSON]: $data");

        setState(() {
          hiddenList = data['Result'] ?? [];
        });

        log("📍 Updated Hidden List: $hiddenList");
      } else {
        throw Exception("Failed to load data. Status: ${response.statusCode}");
      }
    } catch (e) {
      MyCustomLoading.stop();
      log("❌ [ERROR in fetchHiddenList]: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final textColor = Colors.red;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColors.appBarColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text("HIDDEN PROFILE", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
        ),
        body: hiddenList.isEmpty ? Center(child: Text('No data Available'),) :
        ListView.builder(
          itemCount: hiddenList.length,
          itemBuilder: (_, index) {
            final intresting = hiddenList[index];
            log("intresting : $intresting");
            final profileImage = intresting['profile_image'];
            var finalImage = "";
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
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
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
                                child: finalImage == "" ?
                                Image.asset("assets/user_images.png") :
                                Image.network('${GlobalVariables.baseUrl}profile_image/$finalImage', fit: BoxFit.cover,
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
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      intresting['name'] ?? "",
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: textColor
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
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      intresting['countryofliving'] ?? "",
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 16,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    intresting['marital_status'] == "Unmarried" ? "" : "மறுமணம்",
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
                                  SizedBox(
                                    width: width / 2.2,
                                    child: Text(
                                      intresting['education_details']??'-',
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        color: textColor,
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
                                  SizedBox(
                                    width: width / 2,
                                    child: Text(
                                      intresting['occupation_details'] ?? "-",
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        color: textColor,
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
                                  Text(
                                    intresting['income'] ?? "-",
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 6,
                                    child: Text(
                                      intresting['per'] ?? "",
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        color: textColor,
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
                                      color: textColor,),
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
                                      color: textColor,),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    'MoonSign: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        200,
                                    child: Text(
                                      intresting['moonsign']??'-',
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Star: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        200,
                                    child: Text(
                                      intresting['star']??'-',
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        color: textColor,
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
                                      Text(
                                        'Patham: ',
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width - 200,
                                        child: Text(
                                          intresting['patham']??'-',
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 14,
                                            color: textColor,
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
                                  Text(
                                    'Lagnam: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 200,
                                    child: Text(
                                      intresting['lagnam']??'-',
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        color: textColor,
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
                                  Text(
                                    'Dosam: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
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
                                  SizedBox(
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
                                  Text(
                                    'City: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
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
                                  Text(
                                    'District: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
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
                                  Text(
                                    'State: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
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
                                backgroundColor: MyColors.submitBtnColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                                minimumSize: Size(120, 35),
                              ),
                              onPressed: () async {
                                final shouldHide = await showCommonDialog(
                                  context: context,
                                  title: "Un-Hide this Profile?",
                                  message: "Are you sure you want to Un-Hide this Profile?",
                                  confirmText: "Un-Hide",
                                  confirmColor: Colors.red,
                                );

                                log("shouldHide $shouldHide");

                                if (shouldHide == true) {
                                  await hideProfile(
                                    loginMemberId: memberId,
                                    profileId: intresting['id'],
                                  );
                                }
                              },
                              child: Text(
                                "Un-Hide",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.submitBtnColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                                minimumSize: Size(150, 35),
                              ),
                              onPressed: () {
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
            );
          },
        ),
      ),
    );
  }
}
