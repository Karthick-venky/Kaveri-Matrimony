// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, non_constant_identifier_names, avoid_print, unnecessary_cast

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../myprofile/moonsigns.dart';
import '../../myprofile/stars.dart';
import 'package:http/http.dart'as http;
import '../activity/Home Screens/myprofile.dart';


class Astrological_Details extends StatefulWidget {

  final String memberId;
  final String id;

  const Astrological_Details({super.key, required this.memberId, required this.id});

  @override
  State<Astrological_Details> createState() => _Astrological_DetailsState();

}

class _Astrological_DetailsState extends State<Astrological_Details> {

  Nakshatra selectedNakshatra = nakshatras[0];
  MoonSign selectedMoonsign = moonSigns[0];
  MoonSign selectedLagnam = moonSigns[0];


  String selectedDosam = "--select an option--";
  String? selectedSubDosam;

  String? selectedStar;
  String? selectedmoonsign;
  String? selectedlagnam;

  String? horoscope;
  TextEditingController starController = TextEditingController();
  TextEditingController MoonsignController = TextEditingController();
  TextEditingController PathamController = TextEditingController();
  TextEditingController lagnamController = TextEditingController();
  TextEditingController horoscopeController = TextEditingController();
  TextEditingController dosamdetails=TextEditingController();

   TextEditingController dosamController = TextEditingController();
  TextEditingController additionalFieldController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  final TextEditingController timeOfBirthController = TextEditingController();
  final TextEditingController selectedDosamController = TextEditingController();
  final TextEditingController selectedsubDosamController =
  TextEditingController();
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

  void updateProfile() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
    String member_id = prefs.getString("id")!;
    // final apiUrl = 'http://kaverykannadadevangakulamatrimony.com/appadmin/api/astrology_detail_update?id=738&star=Vishakam&moonsign=Maharam&lagnam=Maharam&patham=1';
    
    //"http://kaverykannadadevangakulamatrimony.com/appadmin/api/astrology_detail_update";

    // final apiUrl ='http://kaverykannadadevangakulamatrimony.com/appadmin/api/astrology_detail_update?id=${member_id}&star=${starController.text}&moonsign=${MoonsignController.text}&lagnam=${lagnamController.text}&patham=${selectedPatham!.patham.toString()}';
    final apiUrl ='http://kaverykannadadevangakulamatrimony.com/appadmin/api/astrology_detail_update?id=${member_id}&star=${selectedNakshatra.value}&moonsign=${selectedMoonsign.value}&lagnam=${selectedMoonsign.value}&patham=${selectedPatham?.patham??""}&birth=${placeOfBirthController.text}&timefor=${timeOfBirthController.text}&horoscope=${horoscopeController.text}&dosam=${dosamController.text}';

  log('apiUrl : ${apiUrl}');

    final userData = {
      'id': member_id,
      'birth': placeOfBirthController.text,
      'timefor': timeOfBirthController.text,
      'star':starController.text,
      'moonsign': MoonsignController.text,
      'lagnam': lagnamController.text,
      'horoscope':horoscopeController.text,
      'dosam': dosamController.text,
      'ddosam': selectedsubDosamController.text,
      'dosamdetails':dosamdetails.text,
      'patham':selectedPatham!.patham.toString() ,
    };

    log('userData ${userData.toString()}');
    log('userData 2 : ${apiUrl.toString()}');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        // body: jsonEncode(userData),
        // headers: {'Content-Type': 'application/json'},
      );
      log(response.body);

      print(userData);
      print(horoscopeController.text);
      print(dosamController.text);



      if (response.statusCode == 200) {
        // Successfully updated profile
        print("Profile updated successfully");
        print("Response body: ${response.body}");
        print(userData);
        showCustomBar("Profile updated successfully",Colors.green);

        print(response.body);
        print(response.statusCode);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyProfile(
                  memberId: "1",
                  id: "1",
                )));

      } else {
        // Handle errors
        print("Error updating profile. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      // Handle other exceptions
      log("Error updating profile: $e");
    }
  }
  List<String> dosamOptions = [
    "--select an option--",
    "Yes",
    "No",
    "Do Not Know",
    "Not Applicable",
  ];
  Map<String, List<String>> subDosamOptions = {
    "Yes": ["--select an option--", "Ragu/Keethu", "Seva", "Ragukeethu/Seva"],
    "No": ["--select an option--"],
    "Do Not Know": ["--select an option--"],
    "Not Applicable": ["--select an option--"],
  };
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPatham();

    _fetchProfileData();
  }
 
// patham

 List<Patham> patham =[];
   Patham? selectedPatham ;

     Future<void> getPatham() async {
    try {
      final url = Uri.parse(
          'https://kaverykannadadevangakulamatrimony.com/appadmin/api/patham');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
       

        final paatham = (data['msg'] as List<dynamic>).map((kula) {
          return Patham.fromJson(kula);
        }).toList();

        setState(() {
          patham = paatham;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
     log('ERROR : ${e}');
    
    }
  }




  List<dynamic> profileData = [];

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String member_id = prefs.getString("id")!;

    //!
     final url = Uri.parse(
          'https://kaverykannadadevangakulamatrimony.com/appadmin/api/patham');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
       

        final paatham = (data['msg'] as List<dynamic>).map((kula) {
          return Patham.fromJson(kula);
        }).toList();

        setState(() {
          patham = paatham;
        });
      } else {
        throw Exception('Failed to load data');
      }
    //!

    log("member_id : ${member_id}");
    final url2 = Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/myprofile?member_id='+member_id);

    try {
      final response = await http.get(url2);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
       log("jsonResponse:${jsonResponse}");
        setState(() {
          profileData = [jsonResponse['member_details']];
          print(profileData);
          setState(() {
            placeOfBirthController.text = profileData[0]['birth']??"";
            timeOfBirthController.text = profileData[0]['timefor'];

             horoscope = profileData[0]['horoscope'].isEmpty?"No":profileData[0]['horoscope'];
            selectedDosam = profileData[0]['dosam']??"";
            dosamController.text  = profileData[0]['dosam']??"";
            selectedSubDosam = profileData[0]['ddosam']??"";
            selectedsubDosamController.text  = profileData[0]['ddosam']??"";
            dosamdetails.text = profileData[0]['dosamdetails']??"";
             horoscopeController.text =profileData[0]['horoscope'].isEmpty?"No":profileData[0]['horoscope'];
log('4');

            var  selectedPatham1 =profileData[0]['patham']??"";
            selectedPatham1 = selectedPatham1.trim();

log('5');
log('selectedPatham1 : ${selectedPatham1}');
log('patham : ${patham}');
log('patham : ${patham.length}');

               selectedPatham = patham.firstWhere(
                  (item) => item.patham == selectedPatham1,
                );
log('selectedPatham : ${selectedPatham?.patham}');

log('3');


            for(int i=0;i<nakshatras.length;i++)
            {
              if(nakshatras[i].name==profileData[0]['star'])
              {
                starController.text = nakshatras[i].value;
                selectedNakshatra =  nakshatras[i];
              }
            }
log('1');

            for(int i=0;i<moonSigns.length;i++)
            {

              if(moonSigns[i].name==profileData[0]['moonsign'])
              {
                selectedMoonsign =  moonSigns[i];
                MoonsignController.text =   moonSigns[i].value;
              }


              if(moonSigns[i].name==profileData[0]['lagnam'])
              {
                selectedLagnam =  moonSigns[i];
                lagnamController.text =  moonSigns[i].value;
              }
            }

log('2');

          });
        });

      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        title:  Text(
          "Astrological Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [


              SizedBox(
                height: 20,
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: placeOfBirthController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Place of Birth",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent.withOpacity(
                            0.7), // Set your border color
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
           
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: timeOfBirthController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Time of Birth",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent.withOpacity(
                            0.7), // Set your border color
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButtonFormField<Nakshatra>(
                  value: selectedNakshatra,  // Ensure selectedNakshatra is a valid Nakshatra instance from the list
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Star",
                    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrangeAccent.withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: null,
                  items: nakshatras.map((Nakshatra nakshatra) {
                    return DropdownMenuItem<Nakshatra>(
                      value: nakshatra,  // Ensure each value is unique and corresponds to an item
                      child: Text(nakshatra.name),
                    );
                  }).toList(),
                  onChanged: (Nakshatra? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedNakshatra = newValue;
                        starController.text = selectedNakshatra.value;
                      });
                    }
                    print("Selected nakshatra code: ${newValue?.code}");
                  },
                ),
              ),


              SizedBox(
                height: 20,
              ),


              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButtonFormField<MoonSign>(
                  value: selectedMoonsign, // Ensure selectedMoonsign is a valid MoonSign instance from the list
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Moonsign",
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
                      borderSide: BorderSide(color: Colors.deepOrangeAccent.withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: null,
                  items: moonSigns.map((MoonSign moonsign) {
                    return DropdownMenuItem<MoonSign>(
                      value: moonsign,  // Ensure each value is unique and corresponds to an item
                      child: Text(moonsign.name),
                    );
                  }).toList(),
                  onChanged: (MoonSign? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedMoonsign = newValue;
                        MoonsignController.text = selectedMoonsign.value; // Ensure value is correctly accessed
                      });
                    }
                  },
                ),
              ),


              SizedBox(
                height: 20,
              ),


              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButtonFormField<MoonSign>(
                  value: selectedLagnam,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Lagnam",
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
                  items: moonSigns.map((MoonSign moonsign) {
                    return DropdownMenuItem<MoonSign>(
                      value: moonsign,
                      child: Text(moonsign.name),
                    );
                  }).toList(),
                  onChanged: (MoonSign? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedLagnam = newValue;
                        lagnamController.text = selectedLagnam.value;  // Ensure this works correctly with the MoonSign value
                      });
                    }
                  },
                ),
              ),



              SizedBox(
                height: 20,
              ),

              // //!

              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButtonFormField(
                  value: horoscope,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Horoscope Match",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent.withOpacity(
                            0.7), // Set your border color
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: null,
                  // This will remove the dropdown icon
                  items: const [
                    DropdownMenuItem(
                      value: "Yes",
                      child: Text("Yes"),
                    ),
                    DropdownMenuItem(
                      value: "No",
                      child: Text("No"),
                    ),
                    DropdownMenuItem(
                      value: "Does Not matter",
                      child: Text("Does Not matter"),
                    ),
                  ],
                  onChanged: (value) {
                    horoscopeController.text = value!;
                    print("Selected value: $value");
                  },
                ),
              ),


             //!
              SizedBox(
                height: 20,
              ),


              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Dosam Dropdown
                    DropdownButtonFormField<String>(
                      value: dosamOptions.contains(selectedDosam) ? selectedDosam : null, // Ensure the value exists
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "Dosam",
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
                          borderSide: BorderSide(color: Colors.deepOrangeAccent.withOpacity(0.7)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: null,
                      items: dosamOptions.map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDosam = value!;
                          dosamController.text = selectedDosam;

                          // Reset sub-dosam selection
                          selectedSubDosam = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Sub Dosam dropdown for "yes" option
                    if (selectedDosam == "Yes")
                      DropdownButtonFormField<String>(
                        value: subDosamOptions[selectedDosam]!.contains(selectedSubDosam)
                            ? selectedSubDosam
                            : null, // Ensure the value exists
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Selected Dosam",
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
                            borderSide: BorderSide(color: Colors.deepOrangeAccent.withOpacity(0.7)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: null,
                        items: subDosamOptions[selectedDosam]!
                            .map<DropdownMenuItem<String>>((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubDosam = value;
                            selectedsubDosamController.text = selectedSubDosam!;
                          });
                        },
                      ),
                    const SizedBox(height: 20),

                    // Dosam details field, visible only if selectedDosam is "Yes"
                    Visibility(
                      visible: selectedDosam == "Yes",
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: dosamdetails,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Dosam Details",
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
                              borderSide: BorderSide(color: Colors.deepOrangeAccent.withOpacity(0.7)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              //!
               //todo patham dropdown   

                Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButtonFormField(
                  value: selectedPatham,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Patham",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent.withOpacity(
                            0.7), // Set your border color
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ),
                  icon: null,
                  items: patham.map((Patham patham) {
                    return DropdownMenuItem<Patham>(
                      value: patham,
                      child: Text(patham.patham),
                    );
                  }).toList(),
                  hint: Text("Choose Patham"),
                  onChanged: ( newValue) {
                   
                      setState(() {
                        selectedPatham= newValue as Patham?;
                        
                      });
                    
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
                    color: Colors.black
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
//todo patham model class
class Patham {
  String id;
  String patham;

  Patham({required this.id, required this.patham});

  // Factory constructor to create an instance from JSON
  factory Patham.fromJson(Map<String, dynamic> json) {
    return Patham(
      id: json['id'] as String,
      patham: json['patham'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patham': patham,
    };
  }
}
