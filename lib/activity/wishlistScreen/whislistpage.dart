import 'dart:convert';

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

class wishlistScreen extends StatefulWidget {
  const wishlistScreen({super.key});

  @override
  State<wishlistScreen> createState() => _wishlistScreenState();
}

class _wishlistScreenState extends State<wishlistScreen> {
  List<Emp> wishList = [];

  String member_id = "";

  @override
  void initState() {
    super.initState();
    fetchwishList();
  }

  Future<WishListModel> fetchwishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    member_id = prefs.getString("id")!;

    print("wishmemebr$member_id");

    final apiUrl =
        '${GlobalVariables.baseUrl}appadmin/api/wishlist?member_id=$member_id';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var mm=  WishListModel.fromJson(json.decode(response.body));

      //  log('jsonData :${jsonData}');
      setState(() {
        wishList =mm.emp!;
      });
      return mm;
    } else {
      throw Exception(
          'Failed to load employee data. Status code: ${response.statusCode}');
    }
  }

  Future<void> hideProfile({required String loginMemberId, required String profileId,}) async {
    MyCustomLoading.start(context);
    final result = await ProfileService.hideProfile(loginMemberId: loginMemberId, profileId: profileId,);

    if (!mounted) return;

    if (result["status"] == true) {
      CommonSnackBar.show(context, message: result["msg"], backgroundColor: Colors.green,);
      fetchwishList();
    } else {
      CommonSnackBar.show(context, message: result["msg"] ?? "Failed", backgroundColor: Colors.red,);
    }
  }


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.appBarColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("WISHLIST", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
      ),
      bottomNavigationBar: const BottomBar(index: 4),
      body: ListView.builder(
        itemCount: wishList.length,
        itemBuilder: (_, index) {
          final profileImage = wishList[index].profileImage!;
          final String finalImage;
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
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 2.0), blurRadius: 6.0,),],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top:  66, left:  10,right: 10),
                          child: Container(
                            width: 100,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: finalImage == ""
                                ? Image.asset(
                                "assets/user_images.png")
                                : Image.network(
                              '${GlobalVariables.baseUrl}profile_image/$finalImage',
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext
                              context,
                                  Object exception,
                                  StackTrace? stackTrace) {
                                return Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Image.network(
                                      '${GlobalVariables.baseUrl}profile_image/$finalImage',
                                      width: 80,
                                      height: 150,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Flexible(flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    wishList[index].name!,
                                    style: GoogleFonts.openSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),

                                Flexible(
                                  child: Text(
                                    wishList[index].memberId!,
                                    style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                             SizedBox(height: height / 156.6,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    '${wishList[index].countryofliving}',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 16,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Text(
                                  wishList[index].maritalStatus ==
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
                             SizedBox(height: height / 156.6,),
                            Row(
                              children: [
                                Text(
                                  'Education: ',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    wishList[index].educationDetails!,
                                    overflow: TextOverflow.visible,

                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFFFE0808),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(height: height / 156.6,),

                            // todo: occupation
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //  mainAxisAlignment: Main,
                              children: [
                                Text(
                                  'Occupation: ',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),


                                Flexible(
                                  child: Text(
                                    '${wishList[index].occupationDetails}',
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: const Color(0xFFFE0808),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,

                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height / 156.6,),
                            // todo: income

                            Row(
                              children: [
                                Text(
                                  'Income: ',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child:
                                  Text(
                                    wishList[index].income.toString().isNotEmpty && wishList[index].income.toString() !="Nil"
                                        ? wishList[index].income.toString()
                                        : 'Not Given',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFFFE0808),),
                                  ),
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),

                            // todo: dob - age
                            Row(
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
                                  '${wishList[index].dob}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFFFE0808),),
                                ),
                                Text(
                                  '(${wishList[index].age})',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF368EFB)),
                                ),
                              ],
                            ),
                             SizedBox(height: height / 156.6,),
                            // todo: height
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
                                  '${wishList[index].height}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    // color: Color(0xFFD1097B)
                                    color: const Color(0xFFFE0808),
                                  ),
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),
                            const Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Father kula: ',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    ' ${wishList[index].kulaTname} / ${wishList[index].kulaEname}',
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: const Color(0xFF368EFB),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),

                                  ),
                                ),
                              ],
                            ),
                             SizedBox(height: height / 156.6,),
                            // todo mother kula
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mother Kula: ',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    ' ${wishList[index].motherkulaTname} / ${wishList[index].motherkulaEname}',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: const Color(0xFF368EFB),

                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,

                                    ),
                                    overflow: TextOverflow.visible,

                                  ),
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(flex: 1,
                                  child: Text(
                                    'Moonsign: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Flexible(flex: 1,
                                  child: Text(
                                    '${wishList[index].moonsign}',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: const Color(0xFFFE0808),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                      250,
                                  child: Text(
                                    '${wishList[index].star}',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: const Color(0xFFFE0808),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                  width: MediaQuery.of(context)
                                      .size
                                      .width -
                                      250,
                                  child: Text(
                                    '${wishList[index].lagnam}',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: const Color(0xFFFE0808),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dosam: ',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Text(
                                  ' ${wishList[index].dosam}',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Text(
                                  '${wishList[index].ddosam}',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),

                            //todo city, district, state
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                  " ${wishList[index].city}",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF368EFB)),
                                )
                              ],
                            ),
                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(flex: 1,
                                  child: Text(
                                    'District: ',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Flexible(flex: 1,
                                  child: Text(
                                    " ${wishList[index].district}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFF368EFB)),
                                  ),
                                ),
                              ],
                            ),

                             SizedBox(height: height / 156.6,),
                            Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "${wishList[index].state}",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF368EFB)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: MyColors.submitBtnColor,
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                        //     minimumSize: Size(120, 35),
                        //   ),
                        //   onPressed: () async {
                        //     final shouldHide = await showCommonDialog(
                        //       context: context,
                        //       title: "Hide this Profile?",
                        //       message: "Are you sure you want to Hide this Profile?",
                        //       confirmText: "Hide",
                        //       confirmColor: Colors.red,
                        //     );
                        //
                        //     log("shouldHide $shouldHide");
                        //
                        //     if (shouldHide == true) {
                        //       await hideProfile(
                        //         loginMemberId: member_id,
                        //         profileId: wishList[index].id ?? "",
                        //       );
                        //     }
                        //   },
                        //   child: Text("Hide", style: TextStyle(color: Colors.white),),
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.submitBtnColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                            minimumSize: const Size(150, 35),
                          ),
                          onPressed: () {
                            RemoveWishlist(
                              member_id: member_id,
                              profile_id: wishList[index].id!,
                            );
                          },
                          child: const Text("Remove From Wishlist", style: TextStyle(color: Colors.white),),
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
    );
  }

  Future<void> RemoveWishlist({
    required String member_id,
    required String profile_id,
  }) async {
    final apiUrl = '${GlobalVariables.baseUrl}appadmin/api/remove_wishlist';

    final Map<String, dynamic> body = {
      'member_id': member_id,
      'profile_id': profile_id
    };
    print("$member_id-$profile_id");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wishlist Remove Successfully"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      wishlistmemberid: member_id,
                      interestedmemberid: member_id,
                    )));
      } else {
        print('Error: ${response.statusCode}'); // Handle error response
      }
    } catch (e) {
      print('Exception: $e'); // Handle exceptions
    }
  }
}
