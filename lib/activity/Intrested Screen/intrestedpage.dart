import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../other_files/common_snackbar.dart';
import '../../other_files/global.dart';
import '../../other_files/loading.dart';
import '../../other_files/profile_service.dart';
import '../BottomBar/bottombar.dart';
import '../Home Screens/viewprofile.dart';

class InterestedScreen extends StatefulWidget {
  const InterestedScreen({super.key});

  @override
  State<InterestedScreen> createState() => _InterestedScreenState();
}

class _InterestedScreenState extends State<InterestedScreen> {
  List<dynamic> intrestList = [];

  String member_id = "";

  @override
  void initState() {
    super.initState();
    fetchInterestList();
  }

  Future<void> fetchInterestList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    member_id = prefs.getString("id")!;
    log('fetchInterestList member_id: $member_id');

    final apiUrl = '${GlobalVariables.baseUrl}appadmin/api/interest_request?member_id=$member_id';
    log("fetchInterestList apiUrl = $apiUrl");
    final response = await http.get(Uri.parse(apiUrl));
    log('fetchInterestList response.body :${response.body}');

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      log('fetchInterestList jsonData :$jsonData');

      setState(() {
        intrestList = jsonData['Result'];
        log('fetchInterestList : $intrestList');
      });
    } else {
      throw Exception('Failed to load employee data. Status code: ${response.statusCode}');
    }
  }

  Future<void> hideProfile({required String loginMemberId, required String profileId,}) async {
    MyCustomLoading.start(context);
    final result = await ProfileService.hideProfile(loginMemberId: loginMemberId, profileId: profileId,);

    if (!mounted) return;

    if (result["status"] == true) {
      CommonSnackBar.show(context, message: result["msg"], backgroundColor: Colors.green,);
      fetchInterestList();
    } else {
      CommonSnackBar.show(context, message: result["msg"] ?? "Failed", backgroundColor: Colors.red,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white,),
        backgroundColor: const Color(0xFFB30000),
        title: const Text("INTERESTED PROFILE", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomBar(index: 3),
      body: intrestList.isEmpty ?
      Center(child: Text('No data Available'),) :
      ListView.builder(
        itemCount: intrestList.length,
        itemBuilder: (_, index) {
          final intresting = intrestList[index];
          final profileImage = (intresting['profile_image'] ?? '').toString().trim();
          final finalImage = profileImage.contains(',') ? profileImage.split(',').first : profileImage;
          return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 6,),],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// IMAGE
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 90, height: 150,
                          child: finalImage.isEmpty ? Image.asset("assets/user_images.png") : Image.network("${GlobalVariables.baseUrl}profile_image/$finalImage", fit: BoxFit.cover,),
                        ),
                      ),
                    ),

                    /// TEXT CONTENT
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Name + Member ID
                            Row(
                              children: [
                                Expanded(child: Text(intresting['name'] ?? "", style: GoogleFonts.openSans(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.red,),),),
                                Text(intresting['member_id'] ?? "", style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue,),),
                              ],
                            ),

                            SizedBox(height: 3),

                            /// Country + Marital Status
                            Row(
                              children: [
                                Expanded(
                                  child: Text(intresting['countryofliving'] ?? "",
                                    style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
                                  ),
                                ),
                                Text(intresting['marital_status'] == "Unmarried" ? "" : "மறுமணம்",
                                  style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
                                ),
                              ],
                            ),

                            SizedBox(height: 5),

                            /// Reusable Field Rows
                            infoRow("Education", intresting['education_details'], color: Colors.red),
                            infoRow("Occupation", intresting['occupation_details'], color: Colors.red),
                            infoRow("Income", "${intresting['income'] ?? '-'} ${intresting['per'] ?? ''}", color: Colors.red),
                            infoRow("Dob-Age", "${intresting['dob'] ?? '-'} (${intresting['age']})", color: Colors.blue),
                            infoRow("Height", intresting['height'], color: Colors.red),
                            infoRow("Father kula", "${intresting['kula_tname'] ?? '-'} ${intresting['kula_ename'] ?? ''}", color: Colors.blue),
                            infoRow("Mother kula", "${intresting['motherkula_tname'] ?? '-'} ${intresting['motherkula_ename'] ?? ''}", color: Colors.blue),
                            infoRow("MoonSign", intresting['moonsign'] ?? '-', color: Colors.red),
                            infoRow("Star", intresting['star'] ?? '-', color: Colors.red),

                            if (intresting['patham'] != "")
                              infoRow("Patham", intresting['patham'] ?? '-', color: Colors.red),

                            infoRow("Lagnam", intresting['lagnam'] ?? '-', color: Colors.red),
                            infoRow("Dosam", "${intresting['dosam'] ?? '-'} ${intresting['ddosam'] ?? ''}", color: Colors.green),
                            infoRow("City", intresting['city'] ?? '-', color: Colors.blue),
                            infoRow("District", intresting['district'] ?? '-', color: Colors.blue),
                            infoRow("State", intresting['state'] ?? '-', color: Colors.blue),

                            // SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Divider(),

                /// Buttons Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.submitBtnColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                      minimumSize: Size(150, 35),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => viewProfile(memberId: intresting['id']),),);
                    },
                    child: const Text("View Profile", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }

  Widget infoRow(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),),
          Expanded(
            child: Text(value.isEmpty ? "-" : value, softWrap: true,
              style: GoogleFonts.nunitoSans(fontSize: 14, color: color, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),),
          ),
        ],
      ),
    );
  }

  Widget simpleInfo(String label, String value, {Color color = Colors.black}) {
    return Row(
      children: [
        Text('$label: ', style: GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),),
        Text(value.isEmpty ? "-" : value, style: GoogleFonts.nunitoSans(fontSize: 14, color: color, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),),
      ],
    );
  }

}