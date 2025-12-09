import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../other_files/global.dart';

class MemebrshipPlan extends StatefulWidget {
  const MemebrshipPlan({super.key});

  @override
  State<MemebrshipPlan> createState() => _MemebrshipPlanState();
}

class _MemebrshipPlanState extends State<MemebrshipPlan> {



  @override
  void initState() {
    super.initState();
    fetchmembershipdetails();
  }

  String content = "",upi_img1="",upi_img2="",bank_image="",phone="",name="",account_no="",bank="",branch="",ifsc="";

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB30000),
        title: const Text(
          "Membership Plan",
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
                  padding: const EdgeInsets.symmetric(horizontal:10,vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/mat_backimg.jpg'), // Change the path to your image file
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken
                      ),/// Adjust as needed
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(content,
                        style: const TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold,fontSize: 16),),

                    ],
                  )
              ),
              const SizedBox(height: 10,),
              const Text("Payment Options",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
              const SizedBox(height: 10,),
              Image.network("${GlobalVariables.baseUrl}assets/newimage/$upi_img1",height: 140,),
              const SizedBox(height: 10,),
              Text("Phone No: $phone",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text("Name: $name",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Image.network("${GlobalVariables.baseUrl}assets/newimage/$upi_img2",height: 400,),
              const SizedBox(height: 10,),
              Image.network("${GlobalVariables.baseUrl}assets/newimage/$bank_image",height: 200,),
              const SizedBox(height: 10,),
              Text("Name: $name",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text("Account No : $account_no",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text("Bank : $bank",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text("Branch : $branch",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text("IFSC Code : $ifsc",style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
              const SizedBox(height: 20,),
              // Text("அன்பார்ந்த நம் சமூக பெருமக்களே இந்த சேவையை நமது சமூகத்திற்க்கான சமூக சேவைக்காகவே தொடர்ந்து செயல்படுத்தப்படுகிறது. இதற்கு தங்களால் முடிந்த நல் ஆதரவை வழங்குங்கள்.",style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w500),),
              // SizedBox(height: 20,),
              Text("உதவிக்கு அழையுங்கள் : $phone",style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),),

            ],
          ),
        ),
      ),
    );
  }
}
