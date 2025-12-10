import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../activity/wishlistScreen/WishListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../other_files/common_snackbar.dart';
import '../../other_files/global.dart';
import '../../other_files/loading.dart';
import '../../other_files/profile_service.dart';
import '../BottomBar/bottombar.dart';
import 'package:http/http.dart' as http;
import '../Home Screens/homepage.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Emp> wishList = [];

  String member_id = "";

  @override
  void initState() {
    super.initState();
    fetchWishList();
  }

  Future<WishListModel> fetchWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    member_id = prefs.getString("id")!;

    log("fetchWishList member id = $member_id");

    final apiUrl = '${GlobalVariables.baseUrl}appadmin/api/wishlist?member_id=$member_id';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var mm=  WishListModel.fromJson(json.decode(response.body));
      setState(() {
        wishList =mm.emp!;
      });
      return mm;
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
      fetchWishList();
    } else {
      CommonSnackBar.show(context, message: result["msg"] ?? "Failed", backgroundColor: Colors.red,);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.appBarColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("WISHLIST", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
      ),
      bottomNavigationBar: const BottomBar(index: 4),
      body: wishList.isEmpty ?
      Center(child: Text('No data Available'),) :
      ListView.builder(
        itemCount: wishList.length,
          itemBuilder: (_, index) {
            final item = wishList[index];
            final finalImage = extractFirstImage(item.profileImage ?? "");
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 6,)],
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

                        /// DETAILS
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// NAME + ID
                                Row(
                                  children: [
                                    Expanded(child: Text(item.name ?? "", style: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red,),),),
                                    Text(item.memberId ?? "", style: GoogleFonts.openSans(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold,),),
                                  ],
                                ),
                                SizedBox(height: 3),
                                /// COUNTRY + MARITAL STATUS
                                Row(
                                  children: [
                                    Expanded(child: Text(item.countryofliving ?? "", style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),),),
                                    Text(item.maritalStatus == "Unmarried" ? "" : "மறுமணம்", style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                /// Reusable Field Rows
                                info("Education", item.educationDetails ?? "", color: const Color(0xFFFE0808),),
                                info("Occupation", item.occupationDetails ?? "", color: Color(0xFFFE0808)),
                                info("Income", (item.income?.toString().isNotEmpty == true && item.income.toString() != "Nil") ? item.income.toString() : "Not Given", color: Color(0xFFFE0808)),
                                info("Dob-Age", "${item.dob} (${item.age})", color: Color(0xFF368EFB)),
                                info("Height", item.height ?? "", color: Color(0xFFFE0808)),
                                info("Father Kula", "${item.kulaTname} / ${item.kulaEname}", color: Color(0xFF368EFB)),
                                info("Mother Kula", "${item.motherkulaTname} / ${item.motherkulaEname}", color: Color(0xFF368EFB)),
                                info("Moonsign", item.moonsign ?? "", color: Color(0xFFFE0808)),
                                info("Star", item.star ?? "", color: Color(0xFFFE0808)),
                                info("Lagnam", item.lagnam ?? "", color: Color(0xFFFE0808)),
                                info("Dosam", "${item.dosam ?? ""} ${item.ddosam ?? ""}", color: Colors.green),
                                info("City", item.city ?? "", color: Color(0xFF368EFB)),
                                info("District", item.district ?? "", color: Color(0xFF368EFB)),
                                info("State", item.state ?? "", color: Color(0xFF368EFB)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(),

                    /// BUTTON
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.submitBtnColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                          minimumSize: const Size(150, 35),
                        ),
                        onPressed: () {
                          removeWishlist(member_id: member_id, profile_id: item.id!,);
                        },
                        child: const Text("Remove From Wishlist", style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Widget info(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
            style: GoogleFonts.nunitoSans(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
          ),
          Expanded(
            child: Text(value.isEmpty ? "-" : value,   softWrap: true,
              style: GoogleFonts.nunitoSans(fontSize: 14, color: color, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
            ),
          ),
        ],
      ),
    );
  }

  String extractFirstImage(String img) {
    if (img.isEmpty) return "";
    int i = img.indexOf(",");
    return i == -1 ? img : img.substring(0, i);
  }


  Future<void> removeWishlist({required String member_id, required String profile_id,}) async {
    final apiUrl = '${GlobalVariables.baseUrl}appadmin/api/remove_wishlist';

    final Map<String, dynamic> body = {
      'member_id': member_id,
      'profile_id': profile_id
    };
    log("$member_id-$profile_id");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wishlist Remove Successfully"), duration: Duration(seconds: 2),),);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(
          wishlistmemberid: member_id, interestedmemberid: member_id,)));
      } else {
        log('Error: ${response.statusCode}'); // Handle error response
      }
    } catch (e) {
      log('Exception: $e'); // Handle exceptions
    }
  }
}