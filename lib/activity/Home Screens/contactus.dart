import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../../other_files/global.dart';

class ContactUS extends StatefulWidget {
  const ContactUS({super.key});

  @override
  State<ContactUS> createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {

  @override
  void initState() {
    super.initState();
    fetchmembershipdetails();
    fetchcontactdata();
  }

  String content = "",upi_img1="",upi_img2="",bank_image="",phone="",name="",account_no="",bank="",branch="",ifsc="";
  String email="",mobile="",address="";

  Future<void> fetchmembershipdetails() async {

    final url = '${GlobalVariables.baseUrl}appadmin/api/member_ship';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      content = json['msg'][0]['content'];
      upi_img1 = json['msg'][0]['upi_img1'];
      upi_img2 = json['msg'][0]['upi_img2'];
      bank_image = json['msg'][0]['bank_image'];
      phone = json['msg'][0]['phone'];
      name = json['msg'][0]['name'];
      account_no = json['msg'][0]['account_no'];
      bank = json['msg'][0]['bank'];
      branch = json['msg'][0]['branch'];
      ifsc = json['msg'][0]['ifsc'];
    });

    print(content);

  }

  Future<void> fetchcontactdata() async {

    final url = '${GlobalVariables.baseUrl}appadmin/api/contact_us';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      email = json['msg'][0]['email'];
      mobile = json['msg'][0]['mobile'];
      address = json['msg'][0]['address'];
    });

    print(content);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB30000),
        title: const Text(
          "Contact Us",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC), // Container color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: Image.asset('assets/mobile.jpg',fit: BoxFit.fitWidth,)),
                      const SizedBox(height: 10,),
                       Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           const Padding(
                             padding: EdgeInsets.only(top: 25),
                             child: Icon(
                               Icons.phone_android,
                               size: 30,
                               color: Colors.grey,
                             ),
                           ),
                           const SizedBox(width: 5,),
                           Text(mobile,
                             style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                         ],
                       ),
                      const SizedBox(height: 10,),
                    ],
                  )
              ),
              const SizedBox(height: 20,),
              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC), // Container color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: Image.asset('assets/email.jpg',fit: BoxFit.fitWidth,)),
                      const SizedBox(height: 10,),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Icon(
                           Icons.email,
                           size: 30,
                           color: Colors.grey,
                         ),
                         const SizedBox(width: 5,),
                         Text(email,
                           style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                       ],
                     ),
                      const SizedBox(height: 10,),
                     ],
                  )
              ),
              const SizedBox(height: 20,),
              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC), // Container color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: Image.asset('assets/address.jpg',fit: BoxFit.fitWidth,)),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Icon(
                            Icons.location_city,
                            size: 30,
                            color: Colors.grey,
                          ),
                            const SizedBox(width: 5,),
                          Expanded(
                            child: Text(address,
                              style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                        ],),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  )
              ),
              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
}
