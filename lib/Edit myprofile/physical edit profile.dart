// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/Home Screens/myprofile.dart';
import '../myprofile/height.dart';
import '../myprofile/weight.dart';

class physical extends StatefulWidget {
  final String memberId;
  final String id;

  const physical({super.key, required this.memberId, required this.id});


  @override
  State<physical> createState() => _physicalState();
}



class _physicalState extends State<physical> {


  TextEditingController bodytype=TextEditingController();
  TextEditingController Complexion=TextEditingController();
  TextEditingController physicalstatus=TextEditingController();
  TextEditingController food=TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController physicallyChallengedController = TextEditingController();

  String? selectedPhysicalStatus;

  String? selectedFood='';
  Weight? selectedWeight;


  List<Weight> weights = [
    Weight( displayText: '38 Kg'),
    Weight( displayText: '39 Kg'),
    Weight( displayText: '40 Kg'),
    Weight(displayText: '41 Kg'),
    Weight( displayText: '42 Kg'),
    Weight( displayText: '43 Kg'),
    Weight( displayText: '44 Kg'),
    Weight( displayText: '45 Kg'),
    Weight( displayText: '46 Kg'),
    Weight( displayText: '47 Kg'),
    Weight( displayText: '48 Kg'),
    Weight( displayText: '49 Kg'),
    Weight( displayText: '50 Kg'),
    Weight( displayText: '51 Kg'),
    Weight( displayText: '52 Kg'),
    Weight( displayText: '53 Kg'),
    Weight( displayText: '54 Kg'),
    Weight( displayText: '55 Kg'),
    Weight( displayText: '56 Kg'),
    Weight( displayText: '57 Kg'),
    Weight( displayText: '58 Kg'),
    Weight( displayText: '59 Kg'),
    Weight( displayText: '60 Kg'),
    Weight( displayText: '61 Kg'),
    Weight( displayText: '62 Kg'),
    Weight( displayText: '63 Kg'),
    Weight( displayText: '64 Kg'),
    Weight( displayText: '65 Kg'),
    Weight( displayText: '66 Kg'),
    Weight( displayText: '67 Kg'),
    Weight( displayText: '68 Kg'),
    Weight( displayText: '69 Kg'),
    Weight( displayText: '70 Kg'),
    Weight( displayText: '71 Kg'),
    Weight( displayText: '72 Kg'),
    Weight( displayText: '73 Kg'),
    Weight( displayText: '74 Kg'),
    Weight( displayText: '75 Kg'),
    Weight( displayText: '76 Kg'),
    Weight( displayText: '77 Kg'),
    Weight( displayText: '78 Kg'),
    Weight( displayText: '79 Kg'),
    Weight( displayText: '80 Kg'),
    Weight( displayText: '81 Kg'),
    Weight( displayText: '82 Kg'),
    Weight( displayText: '83 Kg'),
    Weight( displayText: '84 Kg'),
    Weight( displayText: '85 Kg'),
    Weight( displayText: '86 Kg'),
    Weight( displayText: '87 Kg'),
    Weight( displayText: '88 Kg'),
    Weight( displayText: '89 Kg'),
    Weight( displayText: '90 Kg'),
    Weight( displayText: '91 Kg'),
    Weight( displayText: '92 Kg'),
    Weight( displayText: '93 Kg'),
    Weight( displayText: '94 Kg'),
    Weight( displayText: '95 Kg'),
    Weight( displayText: '96 Kg'),
    Weight( displayText: '97 Kg'),
    Weight( displayText: '98 Kg'),
    Weight( displayText: '99 Kg'),
    Weight( displayText: '100 Kg'),
    Weight( displayText: '101 Kg'),
    Weight( displayText: '102 Kg'),
    Weight( displayText: '103 Kg'),
    Weight( displayText: '104 Kg'),
    Weight( displayText: '105 Kg'),
    Weight( displayText: '106 Kg'),
    Weight( displayText: '107 Kg'),
    Weight( displayText: '108 Kg'),
    Weight( displayText: '109 Kg'),
    Weight( displayText: '110 Kg'),
    Weight( displayText: '111 Kg'),
    Weight( displayText: '112 Kg'),
    Weight( displayText: '113 Kg'),
    Weight( displayText: '114 Kg'),
    Weight( displayText: '115 Kg'),
    Weight( displayText: '116 Kg'),
    Weight( displayText: '117 Kg'),
    Weight( displayText: '118 Kg'),
    Weight( displayText: '119 Kg'),
    Weight( displayText: '120 Kg'),
    Weight( displayText: '121 Kg'),
    Weight( displayText: '122 Kg'),
    Weight( displayText: '123 Kg'),
    Weight( displayText: '124 Kg'),
    Weight( displayText: '125 Kg'),
    Weight( displayText: '126 Kg'),
    Weight( displayText: '127 Kg'),
    Weight( displayText: '128 Kg'),
    Weight( displayText: '129 Kg'),
    Weight( displayText: '130 Kg'),
    Weight( displayText: '131 Kg'),
    Weight( displayText: '132 Kg'),
    Weight( displayText: '133 Kg'),
    Weight( displayText: '134 Kg'),
    Weight( displayText: '135 Kg'),
    Weight( displayText: '136 Kg'),
    Weight( displayText: '137 Kg'),
    Weight( displayText: '138 Kg'),
    Weight( displayText: '139 Kg'),
    Weight( displayText: '140 Kg'),
    // Add more weights as needed
  ];
  String? selectedComplexion;

  String? selectedHeight;
  String? selectedBodyType;



  List<Height> heights = [
    Height(value: 150.0, displayText: 'Below 4ft'),
    Height(value: 150.0, displayText: '4ft 6in'),
    Height(value: 160.0, displayText: '4ft 7in'),
    Height(value: 170.0, displayText: '4ft 8in'),
    Height(value: 180.0, displayText: '4ft 9in'),
    Height(value: 190.0, displayText: '4ft 10in'),
    Height(value: 200.0, displayText: '4ft 11in'),
    Height(value: 210.0, displayText: '5ft '),
    Height(value: 220.0, displayText: '5ft 1in'),
    Height(value: 230.0, displayText: '5ft 2in'),
    Height(value: 240.0, displayText: '5ft 3in'),
    Height(value: 250.0, displayText: '5ft 4in'),
    Height(value: 260.0, displayText: '5ft 5in'),
    Height(value: 270.0, displayText: '5ft 6in'),
    Height(value: 280.0, displayText: '5ft 7in'),
    Height(value: 290.0, displayText: '5ft 8in'),
    Height(value: 300.0, displayText: '5ft 9in'),
    Height(value: 300.0, displayText: '5ft 10in'),
    Height(value: 300.0, displayText: '5ft 11in'),
    Height(value: 300.0, displayText: '6ft '),
    Height(value: 300.0, displayText: '6ft 1in'),
    Height(value: 300.0, displayText: '6ft 2in'),
    Height(value: 300.0, displayText: '6ft 3in'),
    Height(value: 300.0, displayText: '6ft 4in'),
    Height(value: 300.0, displayText: '6ft 5in'),
    Height(value: 300.0, displayText: '6ft 6in'),
    Height(value: 300.0, displayText: '6ft 7in'),
    Height(value: 300.0, displayText: '6ft 8in'),
    Height(value: 300.0, displayText: '6ft 9in'),
    Height(value: 300.0, displayText: '6ft 10in'),
    Height(value: 300.0, displayText: '6ft 11in'),
    Height(value: 300.0, displayText: '7ft'),
    Height(value: 300.0, displayText: 'Above 7ft'),



    // Add more height options as needed
  ];

  List<dynamic> profileData = [];
  // Map<String, dynamic> profileData ={};

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;


    final url = Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/myprofile?member_id=$memberId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
       var jsonResponse = json.decode(response.body);
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        log('jsonResponse 1: ${response.body}');
        log('jsonResponse 2: ${jsonResponse['member_details']}');
        log('jsonResponse 3: ${jsonResponse['member_details'][0]}');
        log('jsonResponse 4: ${jsonResponse['member_details']['physically']}');
        setState(() {
          profileData = [jsonResponse['member_details']];
        log('profileData : $profileData');
        // log('profileData 1 : ${profileData['bodytype']}').toString();

          setState(() {
            selectedBodyType = profileData[0]['bodytype'].toString();
            selectedComplexion = profileData[0]['complexion'].toString();
            selectedPhysicalStatus = profileData[0]['physically'].toString();
            selectedFood = profileData[0]['food'].toString().isEmpty? 'Vegetarian':profileData[0]['food'].toString();
            selectedHeight = profileData[0]['height'].toString();
            heightController.text= profileData[0]['height'].toString();
            weightController.text = profileData[0]['weight'].toString();
            bodytype.text = profileData[0]['bodytype'].toString();
            Complexion.text = profileData[0]['complexion'].toString();
            physicalstatus.text = profileData[0]['physically'].toString();
            physicallyChallengedController.text = profileData[0]['phy_details'].toString();
            food.text = profileData[0]['food'].toString();

            for(int i=0;i<weights.length;i++)
            {
              if(weights[i].displayText==profileData[0]['weight'].toString())
              {
                selectedWeight =  weights[i];
              }
            }

          });
        });

      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }

  void updateProfile() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;

    const apiUrl = "http://kaverykannadadevangakulamatrimony.com/appadmin/api/physical_attribute_update";

    final userData = {
      'id': memberId,
      'height': heightController.text,
      'weight': weightController.text,
      'bodytype': bodytype.text,
      'complexion': Complexion.text,
      'physically': physicalstatus.text,
      'phy_details': physicallyChallengedController.text,
      'food':food.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successfully updated profile
        print("Profile updated successfully");
        print("Response body: ${response.body}");
        print(userData);
        showCustomBar("Profile updated successfully",Colors.green);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyProfile(
                  memberId: memberId,
                  id: memberId,
                )));
        print(response.body);
        print(response.statusCode);

      } else {
        // Handle errors
        print("Error updating profile. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      // Handle other exceptions
      print("Error updating profile: $e");
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
  void initState() { 
    super.initState();
    _fetchProfileData();
  }
  List<String> complexionOptions = [
    "Fair",
    "Very Fair",
    "Wheatish",
    "Wheatish Medium",
    "Wheatish Brown",
    "Dark",
  ];
  List<String> bodyTypeOptions = ["Slim", "Average", "Athletic", "Heavy"];
  // Height selectedHeight = heights[0];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        backgroundColor: Colors.red,
        title: Text(
          "Physical Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:    Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Height>(
                value: heights.firstWhere(
                      (height) => height.displayText == selectedHeight,
                  orElse: () => heights[0],
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Height",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                // items: heights.map<DropdownMenuItem<Height>>((Height height) {
                //   return DropdownMenuItem<Height>(
                //     value: height,
                //     child: Text(height.displayText),
                //   );
                // }).toList(),
                // onChanged: (Height? newValue) {
                //   if (newValue != null) {
                //     setState(() {
                //       selectedHeight = newValue.displayText;
                //       heightController.text = newValue.displayText;
                //     });
                //   }
                //   print("Selected height value: ${newValue?.value}");
                // },
                items: heights.map<DropdownMenuItem<Height>>((Height height) {
                  return DropdownMenuItem<Height>(
                    value: height,
                    child: Text(height.displayText),
                  );
                }).toList(),
                onChanged: (Height? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedHeight = newValue.displayText;
                      heightController.text = newValue.displayText;
                    });
                  }
                  print("Selected height value: ${newValue?.value}");
                },
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Weight>(
                value: selectedWeight ?? weights[0],
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: selectedWeight?.displayText ?? 'Select Weight',
                  labelText: "Weight",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                items: weights.map<DropdownMenuItem<Weight>>((weight) {
                  return DropdownMenuItem<Weight>(
                    value: weight,
                    child: Text(weight.displayText),
                  );
                }).toList(),
                onChanged: (Weight? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedWeight = newValue;
                      weightController.text = newValue.displayText;
                    });
                  }
                },
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedBodyType,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "BodyType",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                items: bodyTypeOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedBodyType = value;
                      bodytype.text = value;
                    });
                  }
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedComplexion,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Complexion",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: null,
                items: complexionOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedComplexion = value;
                      Complexion.text = value;
                    });
                  }
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedPhysicalStatus,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Physical status",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent.withOpacity(0.7),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: null,
                  items: const [
                    DropdownMenuItem(
                      value: "Normal",
                      child: Text("Normal"),
                    ),
                    DropdownMenuItem(
                      value: "Physically Challenged",
                      child: Text("Physically Challenged"),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedPhysicalStatus = value;
                      physicalstatus.text = value ?? "";
                    });
                  },
                ),
              ),
              Visibility(
                visible: selectedPhysicalStatus == "Physically Challenged",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: physicallyChallengedController,
                    decoration: InputDecoration(
                      labelText: "Physically Challenged details",
                      labelStyle: TextStyle(
                        color: Colors.black, // Set label text color
                      ),
                      fillColor: Colors.white, // Set text box color
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrangeAccent.withOpacity(0.7),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Habits",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedFood!.isEmpty?"Vegetarian":selectedFood,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: "Food",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepOrangeAccent.withOpacity(0.7),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: null,
              items: const [
                DropdownMenuItem(
                  value: "Vegetarian",
                  child: Text("Vegetarian"),
                ),
                DropdownMenuItem(
                  value: "Non-Vegetarian",
                  child: Text("Non-Vegetarian"),
                ),
                DropdownMenuItem(
                  value: "Eggetarian",
                  child: Text("Eggetarian"),
                ),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedFood = value;
                    food.text = value;
                  });
                }
                // Handle the selected value
                print("Selected value: $value");
              },
            ),
          ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  updateProfile();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set your text color
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Update",style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
