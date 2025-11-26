// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../activity/Home%20Screens/viewprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiUtils.dart';
import '../../Models/interested profile model.dart';
import '../../Models/matched profile model.dart';
import '../../Models/wishlist item models.dart';
import '../../Screens/loginScreen.dart';
import '../BottomBar/bottombar.dart';

import '../Intrested Screen/intrestedpage.dart';
import '../SearchScreen/searchpage.dart';
import '../membershipplan.dart';
import '../wishlistScreen/whislistpage.dart';
import 'contactus.dart';
import 'myprofile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String wishlistmemberid;
  final String interestedmemberid;

  const HomeScreen(
      {super.key,
      required this.wishlistmemberid,
      required this.interestedmemberid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late final String profileimage =
      "https://kaverykannadadevangakulamatrimony.com/profile_image";

  int a = 0;
  late Future<List<ProfileModel>> _apiData;
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  // List<String> items = [];
  late Future<List<User>> _userList;
  final ApiService apiService = ApiService();
  late Future<WishlistItem> _wishlistItem;
  bool isLiked = true;

  String name = "", email = "", member_id = "", profile_image = "";

  @override
  void initState() {
    super.initState();
    fetchuserdetails();
    fetchmemberid();
    _tabController = TabController(length: 3, vsync: this);
    _apiData = fetchData();
    _userList = UserService().fetchUserList(
        widget.interestedmemberid); // Call the service method here
  }

  String ownmember_id = "";

  Future<void> fetchmemberid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ownmember_id = prefs.getString("member_id")!;
  }

  Future<void> fetchuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      profile_image = prefs.getString("profile_image")!;
      member_id = prefs.getString("id")!;
      checkactiveprofile();
      print("name" + name);
    });
  }

  Future<void> checkactiveprofile() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kaverykannadadevangakulamatrimony.com/appadmin/api/view_profile?member_id=$member_id'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final List<dynamic> empData = data['emp'];

        dynamic status = empData[0]['is_status'];
        if (status == "1") {
          showCustomBar(
              "Your Profile is Inactive For more information contact admin",
              Colors.red);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('member_id', "");
          await prefs.setString('name', "");
          await prefs.setString('email', "");
          await prefs.setString('mobile', "");
          await prefs.setBool('loginStatus', false);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const loginScreen(),
          ));
        }
      } else {
        throw Exception(
            'Failed to load view profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
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

  @override
  Future<List<ProfileModel>> fetchData() async {
    try {
      final data = await _apiService.getMatchedProfileData();
      return data.map((item) => ProfileModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  WishlistApiService _wishlistApiService = WishlistApiService(
      baseUrl: 'http://kaverykannadadevangakulamatrimony.com/appadmin');

  @override
  Widget build(BuildContext context) {
    final String =
        "https://kaverykannadadevangakulamatrimony.com/profile_image";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the back icon here
          ),
          backgroundColor: const Color(0xFFDF0A0A),
          title: Padding(
            padding: EdgeInsets.only(right: width / 13),
            child: Text("Kavery kannada Devangakula Matrimony",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white)),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => searchScreen()));
                },
                child: const Icon(Icons.search_rounded),
              ),
            ),

          ],

        ),
        drawer: SafeArea(
          child: Drawer(
            elevation: 16.0,
            width: width / 1.568,
            child: Column(
              children: [
                Stack(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        name,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      accountEmail: Text(
                        ownmember_id,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://kaverykannadadevangakulamatrimony.com/profile_image/${profile_image}')),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB00F0F),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.handshake,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: width / 26.13,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                      wishlistmemberid: member_id,
                                      interestedmemberid: member_id)));
                        },
                        child: Text(
                          "Matched Profile",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF800080),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: width / 26.133,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => intrestedScreen()));
                        },
                        child: Text(
                          "Interested Profile",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: const Color(0xFF800080),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.shoppingBag,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => wishlistScreen()));
                        },
                        child: Text(
                          "wishlist Profile",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF800080),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.user,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: width / 26.1333,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(
                                        memberId: "1",
                                        id: "1",
                                      )));
                        },
                        child: Text(
                          "My Profile ",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF800080),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.crown,
                        size: 20,
                        color: Color(0xFFB00F0F),
                      ),
                      SizedBox(
                        width: width / 26.13333,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MemebrshipPlan()));
                        },
                        child: Text(
                          "Membership plan",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF800080),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.call,
                        color: Color(0xFFB00F0F),
                      ),
                      SizedBox(
                        width: width / 26.13333,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactUS()));
                        },
                        child: Text(
                          "Contact",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF800080),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 39.15,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width / 9.8, top: height / 39.15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Color(0xFFB00F0F),
                      ),
                      SizedBox(
                        width: width / 26.13333,
                      ),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('member_id', "");
                          await prefs.setString('name', "");
                          await prefs.setString('email', "");
                          await prefs.setString('mobile', "");
                          await prefs.setBool('loginStatus', false);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const loginScreen(),
                          ));
                        },
                        child: Text(
                          "Log Out",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF800080),
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
        bottomNavigationBar: const BottomBar(index: 0),
        body: FutureBuilder<List<ProfileModel>>(
          future: _apiData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available for Tab 1.'));
            } else {
              final List<ProfileModel> profiles = snapshot.data!;
              return ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  final profile_image = profile.profile_image;
                  final final_image;
                  log('occupation :${profile.occupation}');
                  if (profile_image != "") {
                    int semicolonIndex = profile_image.indexOf(",");
                    if (semicolonIndex != -1) {
                      final_image = profile_image.substring(0, semicolonIndex);
                    } else {
                      final_image = profile_image;
                    }
                  } else {
                    final_image = "";
                  }

                  // return GestureDetector(
                  //   onTap: (){
                  //      Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                           builder: (context) => viewProfile(
                  //                             memberId: '${profile.id}',
                  //                           ),
                  //                         ),
                  //                       );
                  //   },
                  //   child: ProfileCard(
                  //     profile: profile,
                  //     finalImage: final_image,
                  //     isLiked:   profile.isLiked,
                  //     onLikePressed: (bool newState) {
                  //           print(widget.wishlistmemberid);
                  //                         sendLikeStatus(
                  //                           member_id: ownmember_id,
                  //                           is_liked: !profile.isLiked,
                  //                           profile_id: profile.id,
                  //                         );
                  //                         setState(() {
                  //                           profiles[index].isLiked =
                  //                               !profiles[index].isLiked;
                  //                         });
                  //                         ScaffoldMessenger.of(context)
                  //                             .showSnackBar(
                  //                           SnackBar(
                  //                             content: Text(profile.isLiked
                  //                                 ? 'Added to Wishlist!'
                  //                                 : 'Removed from Wishlist!'),
                  //                             duration: Duration(seconds: 2),
                  //                           ),
                  //                         );
                  //     },
                  //     onViewProfile: () {
                  //      Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                             builder: (context) => viewProfile(
                  //                               memberId: '${profile.id}',
                  //                             ),
                  //                           ),
                  //                         );
                  //     },
                  //   ),
                  // );

                  return Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
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
                           mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:  66, left:  10,right: 10),
                                    child: Container(
                                      width: 100,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: final_image == ""
                                          ? Image.asset(
                                              "assets/user_images.png")
                                          : Image.network(
                                              'https://kaverykannadadevangakulamatrimony.com/profile_image/${final_image}',
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
                                                      'https://kaverykannadadevangakulamatrimony.com/profile_image/${final_image}',
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
                                          Container(
                                            width: 150,
                                            child: Text(
                                              profile.name,
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
                                              profile.member_id,
                                              style: GoogleFonts.openSans(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: height/78.3,
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 140,
                                            child: Text(
                                              '${profile.countryofliving}',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 16,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              profile.marital_status ==
                                                      "Unmarried"
                                                  ? ""
                                                  : "மறுமணம்",
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 9,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                              profile.educationDetails,
                                              overflow: TextOverflow.visible,

                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                 color: Color(0xFFFE0808),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 156.6,
                                      ),

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
                                              '${profile.occupation}',
                                              overflow: TextOverflow.visible,
                                              maxLines: null,
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

                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                          Container(
                                            width: 120,
                                            child:
                                            Text(
                                              profile.income.toString().isNotEmpty && profile.income.toString() !="Nil"
                                                  ? '${profile.income.toString()}'
                                                  : 'Not Given',
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color(0xFFFE0808),),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),

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
                                            '${profile.dateofbirth}',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                 color: Color(0xFFFE0808),),
                                          ),
                                          Text(
                                            '(${profile.age})',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF368EFB)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                            '${profile.height}',
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                               // color: Color(0xFFD1097B)
                                               color: Color(0xFFFE0808),
                                               ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                              ' ${profile.kula_tname} / ${profile.kula_ename}',
                                              overflow: TextOverflow.visible,
                                              maxLines: null,
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
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                              ' ${profile.motherkula_tname} / ${profile.motherkula_ename}',
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 14,
                                                color: Color(0xFF368EFB),

                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,

                                              ),
                                              overflow: TextOverflow.visible,

                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                              '${profile.moonsign}',
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
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
                                      Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                                250,
                                            child: Text(
                                              '${profile.star}',
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
                                      profile.patham.isEmpty ? SizedBox():
                                          Column(
                                              children: [
                                                SizedBox(
                                                  height: height / 156.6,
                                                ),
                                                Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          250,
                                                      child: Text(
                                                        '${profile.patham}',
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
                                              ],
                                          ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),
                                      Row( crossAxisAlignment: CrossAxisAlignment.start,
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
                                                250,
                                            child: Text(
                                              '${profile.lagnam}',
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
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                            ' ${profile.dosam}',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            '${profile.ddosam}',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),

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
                                          Container(
                                            child: Text(
                                              " ${profile.city}",
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color(0xFF368EFB)),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                              " ${profile.district_name}",
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Color(0xFF368EFB)),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: height / 156.6,
                                      ),
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
                                          Container(
                                            child: Text(
                                              "${profile.state_name}",
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                 color: Color(0xFF368EFB)),
                                            ),
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
                              padding: EdgeInsets.only(left: width / 29.6),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1.2, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          print(widget.wishlistmemberid);
                                          sendLikeStatus(
                                            member_id: member_id,
                                            is_liked: !profile.isLiked,
                                            profile_id: profile.id,
                                          );
                                          setState(() {
                                            profiles[index].isLiked =
                                                !profiles[index].isLiked;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(profile.isLiked
                                                  ? 'Added to Wishlist!'
                                                  : 'Removed from Wishlist!'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          profile.isLiked
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_outline_rounded,
                                          color: profile.isLiked
                                              ? Colors.red
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 3),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFDF0A0A),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        minimumSize: const Size(150, 35),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => viewProfile(
                                              memberId: '${profile.id}',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
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
              );
            }
          },
        ));
  }

  //
  // Widget buildTabView(String tabTitle) {
  //   int a = 0;
  //   double height = MediaQuery
  //       .of(context)
  //       .size
  //       .height;
  //   double width = MediaQuery
  //       .of(context)
  //       .size
  //       .width;
  //   if (tabTitle == 'Tab 1 Content') {
  //     int a = 0;
  //     // Content for Tab 1
  //     return FutureBuilder<List<ProfileModel>>(
  //       future: _apiData,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return const Center(child: Text('No data available for Tab 1.'));
  //         } else {
  //           final List<ProfileModel> profiles = snapshot.data!;
  //           return ListView.builder(
  //             itemCount: profiles.length,
  //             itemBuilder: (context, index) {
  //               final profile = profiles[index];
  //               final String profileImageUrl = 'https://kaverykannadadevangakulamatrimony.com/profile_image/${profile
  //                   .profile_image}';
  //               return Padding(
  //                 padding: EdgeInsets.only(top: height / 65.25),
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => viewProfile(memberId: '${profile.id}', ),
  //                       ),
  //                     );
  //                   },
  //                   child: Container(
  //                     width: double.infinity,
  //                     height: 215,
  //                     decoration: const BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey,
  //                           offset: Offset(0.0, 2.0),
  //                           blurRadius: 6.0,
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Padding(
  //                               padding:
  //                               EdgeInsets.only(
  //                                   top: height / 26.1, left: width / 20),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Container(
  //                                     width: 80,
  //                                     height: 100,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(10),
  //                                     ),
  //                                     child: Image.network(
  //                                       profileImageUrl,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                     //Image.network(
  //                                     //  ' ${profile.profile_image[index]}',
  //                                     //
  //                                     //   fit: BoxFit.cover,
  //                                     // ),),
  //                                     //   child: Image.network(
  //                                     //       profile.profileImage),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               width: width / 10,
  //                             ),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Container(
  //                                   width: width / 1.633,
  //                                   child: Row(
  //                                     children: [
  //                                       Text(
  //                                         profile.name,
  //                                         style: GoogleFonts.openSans(
  //                                           fontSize: 12,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.normal,
  //                                           color: Colors.red,
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         width: width / 200,
  //                                       ),
  //                                       Text(
  //                                         profile.member_id,
  //                                         style: GoogleFonts.openSans(
  //                                           fontSize: 12,
  //                                           color: Colors.blue,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.normal,
  //                                         ),
  //                                       ),
  //                                       // SizedBox(
  //                                       //   height: height/78.3,
  //                                       // ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       width: width / 1.86666,
  //                                       child: Text(
  //                                         profile.educationDetails,
  //                                         style: GoogleFonts.nunitoSans(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.italic,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text(
  //                                       '${profile.age}Yrs,',
  //                                       style: GoogleFonts.openSans(
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontStyle: FontStyle.normal,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 5,
  //                                     ),
  //                                     Text(
  //                                       '${profile.height}',
  //                                       style: GoogleFonts.openSans(
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontStyle: FontStyle.normal,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 // Row(
  //                                 //   children: [
  //                                 //     Text(
  //                                 //       'Gotra:${profile.gotra},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     ),
  //                                 //     const SizedBox(
  //                                 //       width: 10,
  //                                 //     ),
  //                                 //     Text(
  //                                 //       'kula:${profile.gotra},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     ),
  //                                 //   ],
  //                                 // ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 // Container(
  //                                 //     width:width/3.915,
  //                                 //     child: Text(
  //                                 //       'Moonsign:${profile.moonsign},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     )),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 // Container(
  //                                 //     width: width/1.96,
  //                                 //     child: Text(
  //                                 //       'Lagnam:${profile.lagnam},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     )),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 Container(
  //                                   width: width / 1.912195,
  //                                   child: Row(
  //                                     children: [
  //                                       Text(
  //                                         " ${profile.state},",
  //                                         style: GoogleFonts.nunitoSans(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.italic,
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         width: width / 78.4,
  //                                       ),
  //                                       Expanded(child: Text(profile.city)),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: width / 29.6),
  //                           child: Row(
  //                             children: [
  //                               Container(
  //                                 decoration: BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   color: Colors.transparent,
  //                                   border: Border.all(
  //                                     color: Colors.red,
  //                                     width: 1.2, // Border width
  //                                   ),
  //                                 ),
  //                                 child: CircleAvatar(
  //                                   backgroundColor: Colors.white,
  //                                   child: IconButton(
  //                                     onPressed: () {
  //                                       sendLikeStatus(
  //                                         member_id: widget.wishlistmemberid,
  //                                         is_liked: !profile.isLiked,
  //                                         profile_id: profile.id,
  //                                       );
  //
  //
  //                                       setState(() {
  //                                         profiles[index].isLiked = !profiles[index].isLiked;
  //                                       });
  //
  //                                       // Show SnackBar when wishlist button is clicked
  //                                       ScaffoldMessenger.of(context).showSnackBar(
  //                                         SnackBar(
  //                                           content: Text(profile.isLiked
  //                                               ? 'Added to Wishlist!'
  //                                               : 'Removed from Wishlist!'),
  //                                           duration: Duration(seconds: 2),
  //                                         ),
  //                                       );
  //                                     },
  //                                     icon: Icon(
  //                                       profile.isLiked
  //                                           ? Icons.favorite_rounded
  //                                           : Icons.favorite_outline_rounded,
  //                                       color: profile.isLiked ? Colors.red : Colors.red,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //
  //                               // Padding(
  //                               //   padding:  EdgeInsets.only(left:width/19.6),
  //                               //   child: Container(
  //                               //     decoration: BoxDecoration(
  //                               //       shape: BoxShape.circle,
  //                               //       color: Colors.transparent,
  //                               //       border: Border.all(
  //                               //         color: Colors.red,
  //                               //         width: 1.2, // Border width
  //                               //       ),
  //                               //     ),
  //                               //     child: CircleAvatar(
  //                               //       backgroundColor: Colors.white,
  //                               //       child: IconButton(
  //                               //         onPressed: () {},
  //                               //         icon: const Icon(
  //                               //           Icons.chat_bubble_outline,
  //                               //           color: Colors.red,
  //                               //         ),
  //                               //       ),
  //                               //     ),
  //                               //   ),
  //                               // ),
  //                               Padding(
  //                                 padding: EdgeInsets.only(left: width / 3),
  //                                 child: ElevatedButton(
  //                                   style: ElevatedButton.styleFrom(
  //                                     backgroundColor: const Color(0xFFDF0A0A),
  //                                     shape: RoundedRectangleBorder(
  //                                       borderRadius: BorderRadius.circular(15),
  //                                     ),
  //                                     minimumSize: const Size(150, 35),
  //                                   ),
  //                                   onPressed: () {},
  //                                   child: const Text("View Profile"),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //       },
  //     );
  //   } else if (tabTitle == 'Tab 2 Content') {
  //     // Content for Tab 2
  //     return FutureBuilder<List<User>>(
  //       future: _userList, // Assuming this fetches a List<User>
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasData && snapshot.data != null) {
  //           final userList = snapshot.data!;
  //           return ListView.builder(
  //               itemCount: userList.length,
  //               itemBuilder: (context, index) {
  //                 final user = userList[index];
  //                 return Padding(
  //                   padding: EdgeInsets.only(top: height / 65.25),
  //                   child: InkWell(
  //                     onTap: () {
  //                       // Navigator.push(
  //                       //   context,
  //                       //   MaterialPageRoute(
  //                       //     builder: (context) => viewProfile(member_id: "${user.member_id}",),
  //                       //   ),
  //                       // );
  //                     },
  //                     child: Container(
  //                       width: double.infinity,
  //                       height: 200,
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.grey,
  //                             offset: Offset(0.0, 2.0),
  //                             blurRadius: 6.0,
  //                           ),
  //                         ],
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Padding(
  //                                 padding:
  //                                 EdgeInsets.only(
  //                                     top: height / 26.1, left: width / 20),
  //                                 child: Column(
  //                                   crossAxisAlignment: CrossAxisAlignment
  //                                       .start,
  //                                   children: [
  //                                     Container(
  //                                       width: 80,
  //                                       height: 100,
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: BorderRadius.circular(
  //                                             10),
  //                                       ),
  //                                       child: Image.asset(
  //                                         ('${user.profileImageUrl}'),
  //                                         fit: BoxFit.cover,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 width: width / 10,
  //                               ),
  //                               Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Container(
  //                                     width: width / 1.633,
  //                                     child: Row(
  //                                       children: [
  //                                         Text(
  //                                           user.name,
  //                                           style: GoogleFonts.openSans(
  //                                             fontSize: 12,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontStyle: FontStyle.normal,
  //                                             color: Colors.red,
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           width: width / 49,
  //                                         ),
  //                                         Text(
  //                                           user.id,
  //                                           style: GoogleFonts.openSans(
  //                                             fontSize: 12,
  //                                             color: Colors.blue,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontStyle: FontStyle.normal,
  //                                           ),
  //                                         ),
  //                                         // SizedBox(
  //                                         //   height: height/78.3,
  //                                         // ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     height: height / 156.6,
  //                                   ),
  //                                   Row(
  //                                     children: [
  //                                       Container(
  //                                         width: width / 1.86666,
  //                                         child: Text(
  //                                           user.education,
  //                                           style: GoogleFonts.nunitoSans(
  //                                             fontSize: 14,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontStyle: FontStyle.italic,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(
  //                                     height: height / 156.6,
  //                                   ),
  //                                   Row(
  //                                     children: [
  //                                       Text(
  //                                         '${user.age}Yrs,',
  //                                         style: GoogleFonts.openSans(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           fontStyle: FontStyle.normal,
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 5,
  //                                       ),
  //                                       Text(
  //                                         '${user.height}',
  //                                         style: GoogleFonts.openSans(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           fontStyle: FontStyle.normal,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(
  //                                     height: height / 156.6,
  //                                   ),
  //                                   // Row(
  //                                   //   children: [
  //                                   //     Text(
  //                                   //       'Gotra:${profile.gotra},',
  //                                   //       style: GoogleFonts.nunitoSans(
  //                                   //         fontSize: 14,
  //                                   //         fontWeight: FontWeight.bold,
  //                                   //         fontStyle: FontStyle.italic,
  //                                   //       ),
  //                                   //     ),
  //                                   //     const SizedBox(
  //                                   //       width: 10,
  //                                   //     ),
  //                                   //     Text(
  //                                   //       'kula:${profile.gotra},',
  //                                   //       style: GoogleFonts.nunitoSans(
  //                                   //         fontSize: 14,
  //                                   //         fontWeight: FontWeight.bold,
  //                                   //         fontStyle: FontStyle.italic,
  //                                   //       ),
  //                                   //     ),
  //                                   //   ],
  //                                   // ),
  //                                   SizedBox(
  //                                     height: height / 156.6,
  //                                   ),
  //                                   // Container(
  //                                   //     width:width/3.915,
  //                                   //     child: Text(
  //                                   //       'Moonsign:${profile.moonsign},',
  //                                   //       style: GoogleFonts.nunitoSans(
  //                                   //         fontSize: 14,
  //                                   //         fontWeight: FontWeight.bold,
  //                                   //         fontStyle: FontStyle.italic,
  //                                   //       ),
  //                                   //     )),
  //                                   SizedBox(
  //                                     height: height / 156.6,
  //                                   ),
  //                                   // Container(
  //                                   //     width: width/1.96,
  //                                   //     child: Text(
  //                                   //       'Lagnam:${profile.lagnam},',
  //                                   //       style: GoogleFonts.nunitoSans(
  //                                   //         fontSize: 14,
  //                                   //         fontWeight: FontWeight.bold,
  //                                   //         fontStyle: FontStyle.italic,
  //                                   //       ),
  //                                   //     )),
  //                                   SizedBox(
  //                                     height: height / 156.6,
  //                                   ),
  //                                   Container(
  //                                     width: width / 1.912195,
  //                                     child: Row(
  //                                       children: [
  //                                         Text(
  //                                           " ${user.state},",
  //                                           style: GoogleFonts.nunitoSans(
  //                                             fontSize: 14,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontStyle: FontStyle.italic,
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           width: width / 78.4,
  //                                         ),
  //                                         Text(user.city),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                           Divider(),
  //                           Padding(
  //                             padding: EdgeInsets.only(left: width / 29.6),
  //                             child: Row(
  //                               children: [
  //                                 GestureDetector(
  //                                   onTap: () {
  //                                     setState(() {
  //                                       a = (a == 0) ? 1 : 0;
  //                                     });
  //                                   },
  //                                   child: a == 1
  //                                       ? Container(
  //                                     decoration: BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: Colors.transparent,
  //                                       border: Border.all(
  //                                         color: Colors.yellow,
  //                                         width: 1.5,
  //                                       ),
  //                                     ),
  //                                     child: CircleAvatar(
  //                                       backgroundColor: Colors.white,
  //                                       child: IconButton(
  //                                         onPressed: () {},
  //                                         icon: const Icon(
  //                                           Icons.favorite,
  //                                           color: Colors.pink,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   )
  //                                       : Container(
  //                                     decoration: BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: Colors.transparent,
  //                                       border: Border.all(
  //                                         color: Colors.red,
  //                                         width: 1.5,
  //                                       ),
  //                                     ),
  //                                     child: CircleAvatar(
  //                                       backgroundColor: Colors.white,
  //                                       child: IconButton(
  //                                         onPressed: () {},
  //                                         icon: const Icon(
  //                                           Icons.favorite_outline_rounded,
  //                                           color: Colors.red,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 // Padding(
  //                                 //   padding:  EdgeInsets.only(left:width/19.6),
  //                                 //   child: Container(
  //                                 //     decoration: BoxDecoration(
  //                                 //       shape: BoxShape.circle,
  //                                 //       color: Colors.transparent,
  //                                 //       border: Border.all(
  //                                 //         color: Colors.red,
  //                                 //         width: 1.2, // Border width
  //                                 //       ),
  //                                 //     ),
  //                                 //     child: CircleAvatar(
  //                                 //       backgroundColor: Colors.white,
  //                                 //       child: IconButton(
  //                                 //         onPressed: () {},
  //                                 //         icon: const Icon(
  //                                 //           Icons.chat_bubble_outline,
  //                                 //           color: Colors.red,
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //   ),
  //                                 // ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(left: width / 3),
  //                                   child: ElevatedButton(
  //                                     style: ElevatedButton.styleFrom(
  //                                       backgroundColor: const Color(
  //                                           0xFFDF0A0A),
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(
  //                                             15),
  //                                       ),
  //                                       minimumSize: const Size(150, 35),
  //                                     ),
  //                                     onPressed: () {},
  //                                     child: const Text("View Profile"),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }
  //           );
  //         } else {
  //           return Center(
  //             child: Text(
  //               'No records found',
  //               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
  //             ),
  //           );
  //         }
  //       },
  //     );
  //
  //
  //     //   interestRequestData.isEmpty
  //     //     ? Center(
  //     //   child: Text('No Records Found'),
  //     // )
  //     //     : ListView.builder(
  //     //   itemCount: interestRequestData.length,
  //     //   itemBuilder: (context, index) {
  //     //     // Display your interest request data here based on the structure of the data
  //     //     // Example: Text(interestRequestData[index]['propertyName'])
  //     //     return ListTile(
  //     //       title: Text('Interest Request ${index +5}'),
  //     //       // Display specific data from interest request
  //     //     );
  //     //   },
  //     // );
  //   } else if (tabTitle == 'Tab 3 Content') {
  //     String dynamicMemberId = widget.wishlistmemberid;
  //     // Content for Tab 3
  //     return FutureBuilder<List<WishlistItem>>(
  //       future: _wishlistApiService.getWishlistItems(dynamicMemberId),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return Center(child: Text('No wishlist item found.'));
  //         } else {
  //           final wishlistItems = snapshot.data!;
  //           return ListView.builder(
  //             itemCount: wishlistItems.length,
  //             itemBuilder: (context, index) {
  //               final item = wishlistItems[index];
  //               final String profileImageUrl = 'https://kaverykannadadevangakulamatrimony.com/profile_image/${item
  //                   .profile_image}';
  //               return Padding(
  //                 padding: EdgeInsets.only(top: height / 65.25),
  //                 child: InkWell(
  //                   onTap: () {
  //                     // Navigator.push(
  //                     //   context,
  //                     //   MaterialPageRoute(
  //                     //     builder: (context) => viewProfile(member_id: "${item.member_id}"),
  //                     //   ),
  //                     // );
  //                   },
  //                   child: Container(
  //                     width: double.infinity,
  //                     height: 200,
  //                     decoration: const BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey,
  //                           offset: Offset(0.0, 2.0),
  //                           blurRadius: 6.0,
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Padding(
  //                               padding:
  //                               EdgeInsets.only(
  //                                   top: height / 26.1, left: width / 20),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Container(
  //                                     width: 80,
  //                                     height: 100,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(10),
  //                                     ),
  //                                     child: Image.network(
  //                                       profileImageUrl,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                     //Image.network(
  //                                     //  ' ${profile.profile_image[index]}',
  //                                     //
  //                                     //   fit: BoxFit.cover,
  //                                     // ),),
  //                                     //   child: Image.network(
  //                                     //       profile.profileImage),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               width: width / 10,
  //                             ),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Container(
  //                                   width: width / 1.633,
  //                                   child: Row(
  //                                     children: [
  //                                       Text(
  //                                         item.name,
  //                                         style: GoogleFonts.openSans(
  //                                           fontSize: 12,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.normal,
  //                                           color: Colors.red,
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         width: width / 200,
  //                                       ),
  //                                       Text(
  //                                         item.member_id,
  //                                         style: GoogleFonts.openSans(
  //                                           fontSize: 12,
  //                                           color: Colors.blue,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.normal,
  //                                         ),
  //                                       ),
  //                                       // SizedBox(
  //                                       //   height: height/78.3,
  //                                       // ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       width: width / 1.86666,
  //                                       child: Text(
  //                                         item.educationDetails,
  //                                         style: GoogleFonts.nunitoSans(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.italic,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text(
  //                                       '${item.age}Yrs,',
  //                                       style: GoogleFonts.openSans(
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontStyle: FontStyle.normal,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 5,
  //                                     ),
  //                                     Text(
  //                                       '${item.height}',
  //                                       style: GoogleFonts.openSans(
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontStyle: FontStyle.normal,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 // Row(
  //                                 //   children: [
  //                                 //     Text(
  //                                 //       'Gotra:${profile.gotra},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     ),
  //                                 //     const SizedBox(
  //                                 //       width: 10,
  //                                 //     ),
  //                                 //     Text(
  //                                 //       'kula:${profile.gotra},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     ),
  //                                 //   ],
  //                                 // ),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 // Container(
  //                                 //     width:width/3.915,
  //                                 //     child: Text(
  //                                 //       'Moonsign:${profile.moonsign},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     )),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 // Container(
  //                                 //     width: width/1.96,
  //                                 //     child: Text(
  //                                 //       'Lagnam:${profile.lagnam},',
  //                                 //       style: GoogleFonts.nunitoSans(
  //                                 //         fontSize: 14,
  //                                 //         fontWeight: FontWeight.bold,
  //                                 //         fontStyle: FontStyle.italic,
  //                                 //       ),
  //                                 //     )),
  //                                 SizedBox(
  //                                   height: height / 156.6,
  //                                 ),
  //                                 Container(
  //                                   width: width / 1.912195,
  //                                   child: Row(
  //                                     children: [
  //                                       Text(
  //                                         " ${item.state},",
  //                                         style: GoogleFonts.nunitoSans(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontStyle: FontStyle.italic,
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         width: width / 78.4,
  //                                       ),
  //                                       Text(item.city),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: [
  //                             ElevatedButton(
  //                               style: ElevatedButton.styleFrom(
  //                                 backgroundColor: Colors.yellow,
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(15),
  //                                 ),
  //                                 minimumSize:  Size(150, 35),
  //                               ),
  //                               onPressed: () {},
  //                               child:  Text("Remove from Wishlist"),
  //                             ),
  //
  //                             // Padding(
  //                             //   padding:  EdgeInsets.only(left:width/19.6),
  //                             //   child: Container(
  //                             //     decoration: BoxDecoration(
  //                             //       shape: BoxShape.circle,
  //                             //       color: Colors.transparent,
  //                             //       border: Border.all(
  //                             //         color: Colors.red,
  //                             //         width: 1.2, // Border width
  //                             //       ),
  //                             //     ),
  //                             //     child: CircleAvatar(
  //                             //       backgroundColor: Colors.white,
  //                             //       child: IconButton(
  //                             //         onPressed: () {},
  //                             //         icon: const Icon(
  //                             //           Icons.chat_bubble_outline,
  //                             //           color: Colors.red,
  //                             //         ),
  //                             //       ),
  //                             //     ),
  //                             //   ),
  //                             // ),
  //                             ElevatedButton(
  //                               style: ElevatedButton.styleFrom(
  //                                 backgroundColor: const Color(0xFFDF0A0A),
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(15),
  //                                 ),
  //                                 minimumSize: const Size(150, 35),
  //                               ),
  //                               onPressed: () {},
  //                               child: const Text("View Profile"),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //       },
  //     );
  //   }
  //
  //   // Default case (should not happen)
  //   return const SizedBox.shrink();
  // }

  Future<void> sendLikeStatus({
    required String member_id,
    required bool is_liked,
    required String profile_id,
  }) async {
    final apiUrl =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/add_wishlist';

    final Map<String, dynamic> body = {
      'member_id': member_id,
      'profile_id': profile_id
    };

    // print(member_id + "-" + profile_id);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.body); // Successful response, handle accordingly
      } else {
        print('Error: ${response.statusCode}'); // Handle error response
      }
    } catch (e) {
      print('Exception: $e'); // Handle exceptions
    }
  }

  //! --------------------------------------
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFE53935),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //! -------------------------------------------

  //! -------------------------------------------
}

// ProfileCard widget
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  final String finalImage;
  final bool isLiked;
  final Function(bool) onLikePressed;
  final VoidCallback onViewProfile;

  const ProfileCard({
    Key? key,
    required this.profile,
    required this.finalImage,
    required this.isLiked,
    required this.onLikePressed,
    required this.onViewProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildProfileImage(),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                             margin: const EdgeInsets.only( right: 10),
                            child: Text(
                              profile.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE53935),
                              ),
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                            ),
                          ),

                          Text(
                            profile.member_id,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.orange[700]),
                              const SizedBox(width: 4),
                              Text(
                                profile.countryofliving,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[700],
                                ),
                              ),
                              if (profile.marital_status != "Unmarried") ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "மறுமணம்",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                           _buildLocationDetails(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:  16,right: 16, left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Profile Details
                    Expanded(child: _buildProfileDetails()),
                  ],
                ),
              ),
              // Action Buttons
              // _buildActionButtons(),
            ],
          ),
        ),

        //
        Positioned(
          top: 5,
            left: 12,
          child: GestureDetector(
            onTap: () => onLikePressed(!isLiked),
            child: Icon( isLiked ? Icons.bookmark : Icons.bookmark_border,color: Colors.red,size: 43,),
          ),
        )
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: finalImage.isEmpty
            ? Image.asset("assets/user_images.png", fit: BoxFit.cover)
            : Image.network(
                'https://kaverykannadadevangakulamatrimony.com/profile_image/$finalImage',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/user_images.png",
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
              _buildDetailItem1(
            Icons.cake, "Age", "${profile.dateofbirth} (${profile.age})"),
        _buildDetailItem1(Icons.height, "Height", profile.height),
          ],
        ),

        // Details Grid
        _buildDetailItem(Icons.school, "Education", profile.educationDetails),
        _buildDetailItem(Icons.work, "Occupation", profile.occupation),
        // Row(
        //   children: [
        // _buildDetailItem(
        //     Icons.cake, "Age", "${profile.dateofbirth} (${profile.age})"),
        // _buildDetailItem(Icons.height, "Height", profile.height),
        //   ],
        // ),

        // Astrological Details
        _buildAstroDetails1(),
        const SizedBox(height: 8),
        _buildAstroDetails(),
        const SizedBox(height: 8),
        _buildAstroDetails3(),

      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFE53935),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailItem1(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAstroDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAstroItem(Icons.brightness_2, "Moon Sign", profile.moonsign),
          const SizedBox(height: 8),
          _buildAstroItem(Icons.star, "Star", profile.star),
          const SizedBox(height: 8),
          _buildAstroItem(Icons.nightlight_round, "Lagnam", profile.lagnam),
        ],
      ),
    );
  }
  Widget _buildAstroDetails1() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAstroItem(Icons.arrow_right, "Mother Kula", "'${profile.motherkula_tname} / ${profile.motherkula_ename}'"),
          const SizedBox(height: 8),
          _buildAstroItem(Icons.arrow_right, "Father kula",  '${profile.kula_tname} / ${profile.kula_ename}'),
          // const SizedBox(height: 8),
          // _buildAstroItem(Icons.arrow_right, "Lagnam", profile.lagnam),
        ],
      ),
    );
  }
  Widget _buildAstroDetails3() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 255, 209),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAstroItem(Icons.arrow_right, "Dosam", "${profile.dosam} ${" "} ${profile.dosam=='Yes'?profile.ddosam:""}"),
          // profile.dosam=='Yes'?
          // _buildAstroItem(Icons.arrow_right, "Dosam", "${profile.ddosam}"):SizedBox(),
          // const SizedBox(height: 8),
          // _buildAstroItem(Icons.arrow_right, "Lagnam", profile.lagnam),
        ],
      ),
    );
  }

Widget _buildAstroItem(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          "$label: ",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[700],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Flexible(
        child: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFFE53935),
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

  Widget _buildLocationDetails() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${profile.city}, ${profile.district_name}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  profile.state_name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Like Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onLikePressed(!isLiked),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE53935),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFE53935),
                  size: 24,
                ),
              ),
            ),
          ),

          // View Profile Button
          ElevatedButton(
            onPressed: onViewProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "View Profile",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
