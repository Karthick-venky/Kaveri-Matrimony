// ignore_for_file: prefer_if_null_operators, dead_code, prefer_const_constructors

import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../export.dart';
import '../Home Screens/viewprofile.dart';
import 'AdvanceSearchModel.dart';

class AdvanceSearch extends StatefulWidget {
  final String kula;
  final String gotra;
  final String fromage;
  final String toage;
  final String moonsign;
  final String star;
  final String dosam;
  final String from_height;
  final String to_height;
  final String martial;
  final String job;
  final String country;
  final String state;
  final String city;
  final String district;

  const AdvanceSearch({super.key, required this.kula, required this.gotra,required this.fromage,required this.toage,required this.moonsign,
    required this.star,required this.dosam,required this.from_height,required this.to_height,
    required this.martial,
    required this.country,
    required this.job,
    required this.state,
    required this.district,
    required this.city, });

  @override
  State<AdvanceSearch> createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {
  List<MemberDetails> userList = [];

  String ownmember_id = "";
  bool isLiked = true;
  String memId  = "";
  String gen="";

  Future<void> fetchmemberid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ownmember_id = prefs.getString("id")!;
    memId = prefs.getString('member_id')!;
    gen=prefs.getString('gender')!;

  }

  @override
  void initState() {
    super.initState();
    fetchmemberid();
    fetchSearchList();
    print('VICKY == >>> ${widget.martial}');

  }

  bool isLoading = true;

  Future<AdvanceSearchModel> fetchSearchList() async {
    String kula = "0";

    if (widget.kula.isNotEmpty) {
      kula = widget.kula;
    }

    String gotra = "0";

    if (widget.gotra.isNotEmpty) {
      gotra = widget.gotra;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString("gender");
    print("vijay gender${gender!}");
    final apiUrl =
        'https://kaverykannadadevangakulamatrimony.com/appadmin/api/search?marital_status='+widget.martial+'&gender='+gender+'&gotra='+gotra+"&kula="+kula+
            "&from_age="+widget.fromage+"&to_age="+widget.toage+"&moonsign="+widget.moonsign+"&star="+widget.star+"&ddosam="+widget.dosam+"&from_height="+widget.from_height+"&to_height="+widget.to_height+"&job="+(widget.job.isEmpty?"":widget.job)+"&country="+widget.country+"&state="+widget.state+"&district="+widget.district+"&member_id="+memId+"&id="+ownmember_id; //
    print(apiUrl);
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var mm=  AdvanceSearchModel.fromJson(json.decode(response.body));
      setState(() {
        userList = mm.memberDetails!;
        isLoading = false;
      });
      return mm;
    } else {
      throw Exception(
          'Failed to load employee data. Status code: ${response.statusCode}');
    }
  }

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
          "SEARCH PROFILE",
          style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white),
        ),
        centerTitle: true,
      ),


      body: isLoading == false ?
      userList.isNotEmpty ? ListView.builder(
        itemCount: userList.length,
        itemBuilder: (_, index) {

          final profileImage = userList[index].profileImage!;
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
                              child: finalImage == ""
                                  ? Image.asset(
                                  "assets/user_images.png")
                                  : Image.network(
                                'https://kaverykannadadevangakulamatrimony.com/profile_image/$finalImage',
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
                                        'https://kaverykannadadevangakulamatrimony.com/profile_image/$finalImage',
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
                                      userList[index].name!,
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
                                      userList[index].memberId!,
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
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      '${userList[index].countryofliving}',
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
                                      userList[index].maritalStatus ==
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
                                      userList[index].educationDetails!,
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
                                      '${userList[index].occupation}',
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
                                      userList[index].income.toString().isNotEmpty && userList[index].income.toString() !="Nil"
                                          ? userList[index].income.toString()
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
                                    '${userList[index].dateofbirth}',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFFE0808),),
                                  ),
                                  Text(
                                    '(${userList[index].age})',
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
                                    '${userList[index].height}',
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
                                children: const [
                                  SizedBox(
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
                                      ' ${userList[index].fatherkulaTname} / ${userList[index].fatherkulaEname}',
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
                                      ' ${userList[index].motherkulaTname} / ${userList[index].motherkulaEname}',
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
                                      '${userList[index].moonsign}',
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
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        250,
                                    child: Text(
                                      '${userList[index].star}',
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
                              userList[index].patham!.isEmpty ? SizedBox():
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
                                      SizedBox(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width -
                                            250,
                                        child: Text(
                                          '${userList[index].patham}',
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
                                  SizedBox(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        250,
                                    child: Text(
                                      '${userList[index].lagnam}',
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
                                    ' ${userList[index].dosam}',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    '${userList[index].ddosam}',
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
                                      " ${userList[index].city}",
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
                                      " ${userList[index].district}",
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
                                      "${userList[index].state}",
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
                                  sendLikeStatus(
                                    member_id: ownmember_id,
                                    profile_id: userList[index].id!,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text('Added to Wishlist!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.favorite_outline_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding:  EdgeInsets.only(left:width/19.6),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Colors.transparent,
                          //       border: Border.all(
                          //         color: Colors.red,
                          //         width: 1.2, // Border width
                          //       ),
                          //     ),
                          //     child: CircleAvatar(
                          //       backgroundColor: Colors.white,
                          //       child: IconButton(
                          //         onPressed: () {},
                          //         icon: const Icon(
                          //           Icons.chat_bubble_outline,
                          //           color: Colors.red,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                                      memberId: userList[index].id!,
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
      ):Center(
          child:Text("No Data For Your Search",style: TextStyle(
              color: Colors.red,
              fontSize: 18
          ),)): Center(child: CircularProgressIndicator(color: Colors.red,),
      ),
    );
  }

  Future<void> sendLikeStatus({
    required String member_id,
    required String profile_id,}) async {
    const apiUrl =
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
}
