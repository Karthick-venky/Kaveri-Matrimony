import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'global.dart';

class ApiService {
  static String baseURL = '${GlobalVariables.baseUrl}appadmin/api/wishlist';

  Future<dynamic> getWishlistData(String memberId) async {
    final url = Uri.parse('$baseURL?member_id=$memberId'); // Append the member_id here

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        log("response.statusCode ${response.statusCode}");
        log(response.body);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}


class WishlistItem {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String occupation;
  final String educationDetails;
  final String profileImage;
  final String height;
  final String age;
  final String moonsign;
  final String gotra;
  final String kula;
  final String lagnam;
  final String state;
  final String city;
  final String occupationDetails;


  WishlistItem({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.occupation,
    required this.educationDetails,
    required this.profileImage,
    required this.height,
    required this.age,
    required this.moonsign,
    required this.gotra,
    required this.kula,
    required this.lagnam,
    required this.state,
    required this.city,
    required this.occupationDetails,

  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      occupation: json['occupation'] ?? 'Not Available',
      educationDetails: json['education_details'] ?? 'Not Available',
      profileImage: json['profile_image'] ?? '',
      height: json['height'] ?? '',
      age: json['age'] ?? '',
      moonsign: json['moonsign'] ?? '',
      gotra: json['gotra'] ?? '',
      kula: json['kula'] ?? '',
      lagnam: json['lagnam'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      occupationDetails: json['occupation_details'] ?? 'Not Available',

    );
  }
}


class WishlistScreen extends StatefulWidget {
  final String memberId;

  const WishlistScreen({super.key, required this.memberId});

  @override
  WishlistScreenState createState() => WishlistScreenState();
}

class WishlistScreenState extends State<WishlistScreen> {
  final ApiService _apiService = ApiService();
  late Future<WishlistItem> _wishlistItem;

  @override
  void initState() {
    super.initState();
    _wishlistItem = _fetchWishlistData();
  }

  Future<WishlistItem> _fetchWishlistData() async {
    try {
      final data = await _apiService.getWishlistData(widget.memberId);
      return WishlistItem.fromJson(data['emp'][0]);
    } catch (e) {
      throw Exception('Error fetching wishlist data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Details'),
      ),
      body: FutureBuilder<WishlistItem>(
        future: _wishlistItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No wishlist item found.'));
          } else {
            final item = snapshot.data!;
            return
           SizedBox(
             width: double.infinity,

             child: ListView.builder(
                itemCount: 2,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                    ),
                     child:
                  InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => viewProfile(),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: double.infinity,
                            height:380,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
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
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          item.profileImage,
                                        ),
                                        fit: BoxFit.cover,
                                      ),




                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                    (item.name),
                                          style: GoogleFonts.openSans(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontStyle:
                                                FontStyle.normal,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          (item.id),
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontStyle:
                                                FontStyle.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text(
                                          (item.educationDetails),
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 130),
                                      child: Row(
                                        children: [
                                          Text(
                                            ('${item.age}yrs'),
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.w500,
                                              fontStyle:
                                                  FontStyle.normal,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text(
                                            (item.height),
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.w500,
                                              fontStyle:
                                                  FontStyle.normal,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(
                                      ('gotra:${item.gotra}'),
                                      style:
                                          GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontStyle:
                                            FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(
                                      ('Kula:${item.kula}'),
                                      style:
                                      GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontStyle:
                                        FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        ('Moonsign:${item.moonsign}'),
                                        style:
                                        GoogleFonts.nunitoSans(
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontStyle:
                                          FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        ('Lagnam:${item.lagnam}'),
                                        style:
                                        GoogleFonts.nunitoSans(
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontStyle:
                                          FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 80),
                                      child: Row(
                                        children: [
                                          Text(
                                            (item.state),
                                            style:
                                                GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontStyle:
                                                  FontStyle.italic,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text(
                                            (item.city),
                                            style:
                                            GoogleFonts.nunitoSans(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontStyle:
                                              FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1.5, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.favorite_outline_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10),
                                    child: Container(
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
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.chat_bubble_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 50),
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
                                      onPressed: () {},
                                      child: const Text("Remove from whislist"),
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
           );
          }
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wishlist Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WishlistScreen(
                    memberId: 'KKDMB00010', // Replace with actual memberId
                  ),
                ),
              );
            },
            child: const Text('View Wishlist Details'),
          ),
        ),
      ),
    );
  }
}
