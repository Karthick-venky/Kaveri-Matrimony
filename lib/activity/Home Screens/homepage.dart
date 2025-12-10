// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../activity/Home%20Screens/viewprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../other_files/api_utils.dart';
import '../../Models/matched profile model.dart';
import '../../Screens/loginScreen.dart';
import '../../other_files/common_snackbar.dart';
import '../../other_files/global.dart';
import '../../other_files/loading.dart';
import '../../other_files/profile_service.dart';
import '../BottomBar/bottombar.dart';

import '../Intrested Screen/intrestedpage.dart';
import '../SearchScreen/searchpage.dart';
import '../common_dialog.dart';
import '../hidden_profile.dart';
import '../membershipplan.dart';
import '../wishlistScreen/whislistpage.dart';
import 'contactus.dart';
import 'myprofile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String wishlistmemberid;
  final String interestedmemberid;

  const HomeScreen({super.key, required this.wishlistmemberid, required this.interestedmemberid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late final String profileimage = "${GlobalVariables.baseUrl}profile_image";

  int a = 0;
  late Future<List<ProfileModel>> _apiData = Future.value([]);
  final ApiService _apiService = ApiService();

  late Future<List<ProfileModel>> _userList;
  final ApiService apiService = ApiService();
  bool isLiked = true;

  String name = "", email = "", member_id = "", profile_image = "", ownmember_id = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadLocalUser();
    await _checkActiveProfile();
  }

  Future<void> _loadLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    name          = prefs.getString("name") ?? "";
    email         = prefs.getString("email") ?? "";
    profile_image = prefs.getString("profile_image") ?? "";
    member_id     = prefs.getString("id") ?? "";

    log("name $name");
    log("member_id before API = $member_id");
    setState(() {});
  }

  Future<void> _checkActiveProfile() async {
    log("member_id before API = $member_id");
    final url = '${GlobalVariables.baseUrl}appadmin/api/view_profile?member_id=$member_id';

    try {
      log("checkActiveProfile URL : $url");
      final response = await http.get(Uri.parse(url));

      log("response : ${response.body}");
      log("status   : ${response.statusCode}");

      if (response.statusCode != 200) {throw "Invalid status code";}

      final data = jsonDecode(response.body);
      final emp  = data['emp'][0];
      final status = emp['delete_request'].toString();

      if (status == "1") {
        final shouldLogout = await showCommonDialog(
          context: context,
          title: "Your Profile is Inactive",
          message: "For more information contact admin",
          confirmText: "Ok",
          showCancelBtn: false,
          confirmColor: Colors.red,
        );

        if (shouldLogout == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const loginScreen()),);
        }
        return;
      }

      await _loadMemberAndUsers();

    } catch (e) {
      log("checkActiveProfile error: $e");
    }
  }

  Future<void> _loadMemberAndUsers() async {
    final prefs = await SharedPreferences.getInstance();
    ownmember_id = prefs.getString("member_id") ?? "";

    log("ownmember_id $ownmember_id");

    _apiData = fetchData();
    _userList = UserService().fetchUserList(widget.interestedmemberid);

    setState(() {});
  }

  Future<void> loadInitialApi() async {
    await _loadLocalUser();
    await _loadMemberAndUsers();
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

  Future<List<ProfileModel>> fetchData() async {
    try {
      final data = await _apiService.getMatchedProfileData();
      return data.map((item) => ProfileModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> hideProfile({required String loginMemberId, required String profileId,}) async {
    MyCustomLoading.start(context);
    final result = await ProfileService.hideProfile(loginMemberId: loginMemberId, profileId: profileId,);

    if (!mounted) return;

    if (result["status"] == true) {
      CommonSnackBar.show(context, message: result["msg"], backgroundColor: Colors.green,);
      loadInitialApi();
    } else {
      CommonSnackBar.show(context, message: result["msg"] ?? "Failed", backgroundColor: Colors.red,);
    }
  }
  Widget _drawerTile({required dynamic icon, required String text, required VoidCallback onTap,}) {
    final iconColor = MyColors.iconColor;
    return ListTile(
      leading: SizedBox(width: 30, child: icon is IconData ? Icon(icon, color: iconColor) : FaIcon(icon, color: iconColor),),
      title: Text(text,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: const Color(0xFF800080),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFDF0A0A),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 3,
          title: Text("Kavery Kannada Devangakula Matrimony",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white,),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => searchScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.search_rounded, size: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        drawer: SafeArea(
          child: Drawer(
            elevation: 16.0,
            width: width / 1.67,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(name, style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16,),),
                  accountEmail: Text(ownmember_id, style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16,),),
                  currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage('${GlobalVariables.baseUrl}profile_image/$profile_image')),
                  decoration: const BoxDecoration(color: Color(0xFFB00F0F),),
                ),

                const SizedBox(height: 10),

                // 🟣 Matched Profile
                _drawerTile(
                  icon: FontAwesomeIcons.handshake,
                  text: "Matched Profile",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),

                // 🩷 Interested Profile
                _drawerTile(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "Interested Profile",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InterestedScreen()),);
                  },
                ),

                // 💼 Wishlist Profile
                _drawerTile(
                  icon: FontAwesomeIcons.bagShopping,
                  text: "Wishlist Profile",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen()),);
                  },
                ),

                // 🩷 Hidden Profile
                _drawerTile(
                  icon: Icons.group_remove,
                  text: "Hidden Profile",
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HiddenProfileScreen(),),
                    ).then((_) {
                      loadInitialApi();
                    });

                  },
                ),

                // 👤 My Profile
                _drawerTile(
                  icon: FontAwesomeIcons.user,
                  text: "My Profile",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(memberId: "1", id: "1"),),);
                  },
                ),

                // 👑 Membership Plan
                _drawerTile(
                  icon: FontAwesomeIcons.crown,
                  text: "Membership Plan",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MemebrshipPlan()),);
                  },
                ),

                // ☎️ Contact
                _drawerTile(
                  icon: Icons.call,
                  text: "Contact",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUS()),);
                  },
                ),

                const Divider(thickness: 1, indent: 16, endIndent: 16),

                // 🚪 Logout
                _drawerTile(
                  icon: Icons.logout,
                  text: "Log Out",
                  onTap: () async {
                    final shouldLogout = await showCommonDialog(
                      context: context,
                      title: "Confirm Logout",
                      message: "Are you sure you want to log out?",
                      confirmText: "Logout",
                      confirmColor: Colors.red,
                    );

                    if (shouldLogout == true) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const loginScreen()),);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(index: 0),
        body: FutureBuilder<List<ProfileModel>>(
          future: _apiData,
          builder: (context, snapshot) {
            if (_apiData == null) {
              return Center(child: CircularProgressIndicator());
            }
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
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    padding: EdgeInsets.all(10),
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
                                          '${GlobalVariables.baseUrl}profile_image/$final_image',
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
                                                  '${GlobalVariables.baseUrl}profile_image/$final_image',
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 156.6,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
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
                                      Text(profile.marital_status == "Unmarried" ? "" : "மறுமணம்",
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 9,
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
                                      SizedBox(
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
                                                Text(
                                                  'Patham: ',
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
                                      Text(
                                        " ${profile.city}",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFF368EFB)),
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
                                      Text(
                                        "${profile.state_name}",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Wishlist Button -------------------------------
                            IconButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                              icon: Icon(profile.isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded, color: MyColors.iconColor, size: 30,),
                              onPressed: () {
                                sendLikeStatus(
                                  member_id: member_id,
                                  is_liked: !profile.isLiked,
                                  profile_id: profile.id ?? "",
                                );

                                setState(() {
                                  profiles[index].isLiked = !profiles[index].isLiked;
                                });
                                CommonSnackBar.show(context, message: profile.isLiked ? "Added to Wishlist!" : "Removed from Wishlist!",);
                              },
                            ),

                            // Hide Profile Button ----------------------------
                            IconButton(
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                              icon: Icon(Icons.block_rounded, color: MyColors.iconColor, size: 30,),
                              onPressed: () async {
                                final shouldHide = await showCommonDialog(
                                  context: context,
                                  title: "Hide this Profile?",
                                  message: "Are you sure you want to Hide this Profile?",
                                  confirmText: "Hide",
                                  confirmColor: Colors.red,
                                );

                                log("shouldHide $shouldHide");

                                if (shouldHide == true) {
                                  await hideProfile(loginMemberId: member_id, profileId: profile.id ?? "",);
                                }
                              },
                            ),

                            Spacer(),
                            // View Profile Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: MyColors.submitBtnColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => viewProfile(memberId: profile.id ?? "",),),);
                              },
                              child: const Text("View Profile", style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(width: 10,)
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }

  Future<void> sendLikeStatus({
    required String member_id,
    required bool is_liked,
    required String profile_id,
  }) async {
    final apiUrl = '${GlobalVariables.baseUrl}appadmin/api/add_wishlist';

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
        log(response.body); // Successful response, handle accordingly
      } else {
        log('Error: ${response.statusCode}'); // Handle error response
      }
    } catch (e) {
      log('Exception: $e'); // Handle exceptions
    }
  }
}
