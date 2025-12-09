// import 'package:flutter/material.dart';
//
// import '../../Models/matched profile model.dart';
// import '../../Models/search member id model.dart';
//
// class memberidscreenpage extends StatefulWidget {
//   final ProfileModel profile;
//
//   const memberidscreenpage({Key? key, required this.profile}) : super(key: key);
//
//
//   @override
//   State<memberidscreenpage> createState() => _memberidscreenpageState();
// }
//
// class _memberidscreenpageState extends State<memberidscreenpage> {
//   List<ProfileModel> filteredProfiles = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Column(
//         // Customize the layout based on your needs
//         children: [
//           Text('Name: ${widget.profile.name}'),
//           Text('Member ID: ${widget.profile.member_id}'),
//           // Add other relevant profile details as needed
//         ],
//       ),
//     );
//   }
// }
import 'package:google_fonts/google_fonts.dart';

import '../../Models/search member id model.dart';
import 'package:flutter/material.dart';

import '../../other_files/global.dart';

class SearchResultPage extends StatelessWidget {
  final SearchProfileModel profile;

  const SearchResultPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Search Result'),
      ),
      body:
      DefaultTabController(
        length: 7,
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
              child: const TabBar(
                tabs: [
                  Tab(text: "Basic"),
                  Tab(text: "Personal"),
                  Tab(text: "Education"),
                  Tab(text: "Astrological"),
                  Tab(text: "Physical"),
                  Tab(text: "Family"),
                  Tab(text: "View Profile"),
                ],
                indicatorWeight: 3,
                labelColor: Color(0xFFDF0A0A),
                unselectedLabelColor: Colors.black,
                indicatorColor: Color(0xFFDF0A0A),
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
              ),
            ),
            
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left
                                  : width / 18.0),
                              child: Text(
                                "Basic Details",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: width / 18),
                            //   child: InkWell(
                            //     onTap: (){
                            //       Navigator.of(context).push(
                            //           MaterialPageRoute(builder: (context)=>basicdetails(memberId: widget.memberId,id: widget.id,))
                            //       );
                            //     },
                            //     child: Icon(
                            //       Icons.edit, color: Colors.red, size: 20,),
                            //   ),
                            // )
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black12,
                        ),


                        // ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     backgroundColor: Colors.blue,
                        //     textStyle: const TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white, // Set your text color
                        //     ),
                        //     minimumSize: const Size(150, 50),
                        //   ),
                        //   child: const Padding(
                        //     padding: EdgeInsets.all(12.0),
                        //     child: Text("Update"),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                'Name',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 3.6),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Father Name",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 8),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                " ${profile.father_name}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Mother Name",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 9),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                " ${profile.mother_name}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Gender",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: width / 4),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                "${profile.gender} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  print(height);
                                  print(width);
                                },
                                child: Text(
                                  "Profile Created By",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 90),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                "${profile.gender} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Gotra",
                                style: GoogleFonts.poppins
                                  (
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 3.46153),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                " ${profile.gotra}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Kula",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 3.0508),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                "${profile.kula} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Date of Birth",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 6.20689),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.dob,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Country of Living In",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 45),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                "${profile.country_of_living} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Marital Status",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 7.5),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                " ${profile.marital_status}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        // Padding(
                        //   padding:  EdgeInsets.only(left: width/3.6,top: height/37.8),
                        //   child: ElevatedButton(
                        //     onPressed: () {},
                        //     style: ElevatedButton.styleFrom(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //       backgroundColor: Colors.red,
                        //       textStyle: const TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white, // Set your text color
                        //       ),
                        //       minimumSize: const Size(150, 50),
                        //     ),
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(12.0),
                        //       child: Text("Update",style: TextStyle(
                        //         color:Colors.black,
                        //         fontWeight: FontWeight.w600,
                        //         fontSize: 20
                        //
                        //       ),),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
 
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 75.6,
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left
                                  : width / 18.0),
                              child: Text(
                                "Personal Details",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: width / 18),
                            //   child: InkWell(
                            //     onTap: (){
                            //       Navigator.of(context).push(
                            //           MaterialPageRoute(builder: (context)=>personaldetails(memberId: widget.memberId,id: widget.id,))
                            //       );
                            //     },
                            //     child: Icon(
                            //       Icons.edit, color: Colors.red, size: 20,),
                            //   ),
                            // )
                          ],
                        ),

                        const Divider(
                          thickness: 2,
                          color: Colors.black12,
                        ),


                        // ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     backgroundColor: Colors.blue,
                        //     textStyle: const TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white, // Set your text color
                        //     ),
                        //     minimumSize: const Size(150, 50),
                        //   ),
                        //   child: const Padding(
                        //     padding: EdgeInsets.all(12.0),
                        //     child: Text("Update"),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Father Education",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 27.69),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                " ${profile.fathereducation}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 20),
                          child: Row(
                            children: [
                              Text(
                                "Father Occupation",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 360),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                "${profile.fathereducation} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),


                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Mother  Education",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.meducation,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Father Native",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 8.372),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                " ${profile.meducation}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  print(height);
                                  print(width);
                                },
                                child: Text(
                                  "Mother Native",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                " ${profile.mother_native}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              Text(
                                "Mother Kula",
                                style: GoogleFonts.poppins
                                  (
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width / 6.545),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                profile.motherkula,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Mother Kotra",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 60),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.motherkula,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Phonenumber",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.mobile,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Alternate Mobile No",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width / 45),
                                child: const Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.alter_mobile,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Landline No",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 70),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.landline_no,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Brother",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 105),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  profile.bro,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Sisters",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 110),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.sis,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Citizenship",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 80),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.citizenship,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Resident Status",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 47),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              SizedBox(
                                width:100,
                                child: Text(
                                  profile.residentstatus,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "State",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 125),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.state,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "City",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 135),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              Text(
                                profile.city,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Residing Address",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 35),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  profile.raddress,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "Profile Description",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 26),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              SizedBox(
                                width:100,
                                child: Text(
                                  profile.pdesc,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 18),
                          child: Row(
                            children: [
                              const Text(
                                "About Life partner",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36,),
                              SizedBox(
                                width:100,
                                child: Text(
                                  profile.lifepartner,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 75.6,
                        ),


                        // Padding(
                        //   padding:  EdgeInsets.only(left: width/3.6,top: height/37.8),
                        //   child: ElevatedButton(
                        //     onPressed: () {},
                        //     style: ElevatedButton.styleFrom(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //       backgroundColor: Colors.red,
                        //       textStyle: const TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white, // Set your text color
                        //       ),
                        //       minimumSize: const Size(150, 50),
                        //     ),
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(12.0),
                        //       child: Text("Update",style: TextStyle(
                        //           color:Colors.black,
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: 20
                        //
                        //       ),),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
            
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 75.6,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left
                                : width / 18.0),
                            child: Text(
                              "Education Details &\nOccupation Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: width / 18),
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.of(context).push(
                          //           MaterialPageRoute(builder: (context)=>education(memberId: widget.memberId,id: widget.id,))
                          //       );
                          //     },
                          //     child: Icon(
                          //       Icons.edit, color: Colors.red, size: 20,),
                          //   ),
                          // )
                        ],
                      ),

                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),


                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     backgroundColor: Colors.blue,
                      //     textStyle: const TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white, // Set your text color
                      //     ),
                      //     minimumSize: const Size(150, 50),
                      //   ),
                      //   child: const Padding(
                      //     padding: EdgeInsets.all(12.0),
                      //     child: Text("Update"),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Education Details",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            SizedBox(
                              width:100,
                              child: Text(
                                profile.education_details,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Employed In",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 90),
                              child: Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.employedin,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),


                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Income",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 130),
                              child: Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              profile.income,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Per",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(left: 165),
                              child: Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.per,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print(height);
                                print(width);
                              },
                              child: Text(
                                "Occupation Details",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            SizedBox(
                              width:100,
                              child: Text(
                                profile.occupation_details,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),
                      // Padding(
                      //   padding:  EdgeInsets.only(left: width/3.6,top: height/37.8),
                      //   child: ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       backgroundColor: Colors.red,
                      //       textStyle: const TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white, // Set your text color
                      //       ),
                      //       minimumSize: const Size(150, 50),
                      //     ),
                      //     child: const Padding(
                      //       padding: EdgeInsets.all(12.0),
                      //       child: Text("Update",style: TextStyle(
                      //           color:Colors.black,
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 20
                      //
                      //       ),),
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 75.6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left
                                : width / 18.0),
                            child: Text(
                              "Astrology Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: width / 18),
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.of(context).push(
                          //           MaterialPageRoute(builder: (context)=>Astrological_Details(memberId: widget.memberId, id: widget.id,))
                          //       );
                          //     },
                          //     child: Icon(
                          //       Icons.edit, color: Colors.red, size: 20,),
                          //   ),
                          // ),
                        ],
                      ),

                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),


                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     backgroundColor: Colors.blue,
                      //     textStyle: const TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white, // Set your text color
                      //     ),
                      //     minimumSize: const Size(150, 50),
                      //   ),
                      //   child: const Padding(
                      //     padding: EdgeInsets.all(12.0),
                      //     child: Text("Update"),
                      //   ),
                      // ),

                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Place of Birth",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 10),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              "${profile.birth} ",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Time of Birth",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width /9),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              "${profile.timefor} ",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Star",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width/3.2727272727272),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            SizedBox(
                              width:150,
                              child: Text(
                                "${profile.star} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Moonsign",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 6),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            SizedBox(
                              width: 150,
                              child: Text(
                                "${profile.moonsign} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Lagnam",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 5),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            SizedBox(
                              width: 150,
                              child: Text(
                                "${profile.lagnam} ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Horoscope\nMatch",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 7),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              "${profile.horoscope} ",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                        child: Row(
                          children: [
                            Text(
                              "Dosam",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 4.5),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              "${profile.dosam} ",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),





                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 75.6,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left
                                : width / 18.0),
                            child: Text(
                              "Physical Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: width / 18),
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.of(context).push(
                          //           MaterialPageRoute(builder: (context)=>physical(memberId: widget.memberId,id: widget.id,))
                          //       );
                          //     },
                          //     child: Icon(
                          //       Icons.edit, color: Colors.red, size: 20,),
                          //   ),
                          // )
                        ],
                      ),

                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),


                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     backgroundColor: Colors.blue,
                      //     textStyle: const TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white, // Set your text color
                      //     ),
                      //     minimumSize: const Size(150, 50),
                      //   ),
                      //   child: const Padding(
                      //     padding: EdgeInsets.all(12.0),
                      //     child: Text("Update"),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Height",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 4),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.height,

                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Weight",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 4.235),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.weight,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),


                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Body Type",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 6),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              profile.bodytype,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Complexion",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: width / 8),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.complexion,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print(height);
                                print(width);
                              },
                              child: Text(
                                "Physical Status ",

                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 24),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            SizedBox(
                              width:100,
                              child: Text(
                                profile.physically,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left
                                : width / 18.0),
                            child: Text(
                              "Habits",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),

                        ],
                      ),

                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print(height);
                                print(width);
                              },
                              child: Text(
                                "Food ",

                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 3.6),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.food,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 75.6,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left
                                : width / 18.0),
                            child: Text(
                              "Family Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: width / 18),
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.of(context).push(
                          //           MaterialPageRoute(builder: (context)=>family(memberId: widget.memberId,id: widget.id,))
                          //       );
                          //     },
                          //     child: Icon(
                          //       Icons.edit, color: Colors.red, size: 20,),
                          //   ),
                          // )
                        ],
                      ),

                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),


                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     backgroundColor: Colors.blue,
                      //     textStyle: const TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white, // Set your text color
                      //     ),
                      //     minimumSize: const Size(150, 50),
                      //   ),
                      //   child: const Padding(
                      //     padding: EdgeInsets.all(12.0),
                      //     child: Text("Update"),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Family details",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 10),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.familystatus,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Family Value",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 8.2),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: width / 36,),
                            Text(
                              profile.familyvalue,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),


                      Padding(
                        padding: EdgeInsets.only(left: width / 18),
                        child: Row(
                          children: [
                            Text(
                              "Family Type",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width / 7),
                              child: const Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              profile.familytype,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 37.8,
                      ),


                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 75.6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left
                                : width / 18.0),
                            child: Text(
                              "View Profile",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: width / 18),
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.of(context).push(
                          //           MaterialPageRoute(builder: (context)=>family(memberId: widget.memberId,id: widget.id,))
                          //       );
                          //     },
                          //     child: Icon(
                          //       Icons.edit, color: Colors.red, size: 20,),
                          //   ),
                          // )
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),

                      Image.network(
                        '${GlobalVariables.baseUrl}profile_image/${profile.profile_image}',
                        width: 200, // Set the width as needed
                        height: 200, // Set the height as needed
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                      SizedBox(
                        height: height / 75.6,
                      ),
                    ],
                  ),
         
         
                ],
              ),
            
            ),
          ],
        ),
      ),
    );
  }
}
