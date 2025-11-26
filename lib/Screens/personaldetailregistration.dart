// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../Screens/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiUtils.dart';
import '../Models/GotraModel.dart';
import '../Models/KulaModel.dart';
import '../Models/citizen model.dart';
import 'package:http/http.dart' as http;

import 'astrodetails.dart';


class RegDetails{
 static String fatherName='';
  static String fatherOccupation='';
 static String fatherNative='';

 static String motherEducation='';
 static String motherOccupation='';
 static String motherNative='';
 static GotraModel? motherGothra;
 static KulaModel? motherkula;

 static String brother='';
 static String sisters='';
 static String citizenship='';
 static String residenceStatus='';

 static String residenceCity='';
 static String residenceAddress='';
 static String profileDescription='';
 static String aboutLifePartner='';
 static List<PrefferdKula> PrefferedKula=[];
 static List<PrefferdKula> prefferendKulaAll=[];
}

class PersonalDetailRegistration extends StatefulWidget {
  const PersonalDetailRegistration({super.key});

  @override
  State<PersonalDetailRegistration> createState() =>
      _PersonalDetailRegistrationState();
}

class _PersonalDetailRegistrationState
    extends State<PersonalDetailRegistration> {
  TextEditingController _fathereducationController = TextEditingController();
  TextEditingController _fatheroccupationController = TextEditingController();
  TextEditingController _fathernativeController = TextEditingController();
  TextEditingController _mothereducationController = TextEditingController();
  TextEditingController _motheroccupationController = TextEditingController();
  TextEditingController _mothernativeController = TextEditingController();

  TextEditingController _brotherController = TextEditingController();
  TextEditingController _sisterController = TextEditingController();
  TextEditingController citizenship = TextEditingController();

  TextEditingController _residencestateController = TextEditingController();
  TextEditingController _residencecityController = TextEditingController();
  TextEditingController _residenceaddressController = TextEditingController();
  TextEditingController _profiledescriptionController = TextEditingController();
  TextEditingController _aboutlifepartnerController = TextEditingController();

  List<GotraModel> gotras = [];
  List<KulaModel> kulas = [];
  List<CitizenModel> citizens = [];

  GotraModel? selectedGotra;
  KulaModel? selectedKula;
  CitizenModel? selectedCitizenship;

  String? selectedResidentOptions;

  List<String> visaOptions = [
    "--select an option--",
    "PermanentResident",
    "WorkPermit",
    "StudentVisa",
    "TemporaryVisa"
  ];

  String fathereducation = "",
      foccupation = "",
      meducation = "",
      moccupation = "",
      father_native = "",
      mother_native = "",
      mothergotra = "",
      motherkula = "",
      bro = "",
      sis = "",
      citizenshipval = "";
  String residentstatus = "",
      state = "",
      city = "",
      lifepartner = "",
      raddress = "",
      pdesc = "";

  void fetchGotras() async {
    print("fetchGotras called");
    gotras = await ApiUtils.fetchGotraList();
    // Set the selectedGotra if it's null or not part of the items
    if (selectedGotra == null || !gotras.contains(selectedGotra)) {
      selectedGotra = gotras.isNotEmpty ? gotras[0] : null;
    }
    setState(() {});
    log("fetchGotras completed --1");
  }

  void fetchKulas() async {
    print("fetchKulas called");
    kulas = await ApiUtils.fetchKulaList();
    // Set the selectedKula if it's null or not part of the items
    if (selectedKula == null || !kulas.contains(selectedKula)) {
      selectedKula = kulas.isNotEmpty ? kulas[0] : null;
    }
    setState(() {});
    log("fetchKulas completed --1");
  }

  void fetchCitizens() async {
    print("fetchCountries called");

    citizens = (await ApiUtils.fetchCitizenshipList()).cast<CitizenModel>();

    if (selectedCitizenship == null ||
        !citizens.contains(selectedCitizenship)) {
      selectedCitizenship = citizens.isNotEmpty ? citizens[0] : null;
    }
    setState(() {});
    log("fetchcountry completed  --1");
  }

String prefferedKulaIdsToJson() {
  List<String> idsList = selectedPrefferendKula.map((kula) => kula.id).toList();
  return idsList.join(',');
}
 
  Future<void> secondregistration() async {
    //todo: remove
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //   builder: (context) => const AstroDetails(),
    // ));
    // return;
    if (selectedGotra!.id == '0') {
      showCustomBar("Please Select Mother Gotra", Colors.red);
    } else if (selectedKula!.id == '0') {
      showCustomBar("Please Select Mother Kula", Colors.red);
    } else if (citizenship.text == "0") {
      showCustomBar("Please Select Citizenship", Colors.red);
    } else if (selectedResidentOptions == null) {
      showCustomBar("Please Select Residence Status", Colors.red);
    // } else if (_residencestateController.text == "") {
    //   showCustomBar("Please Enter Residence State", Colors.red);
    } else if (_residencecityController.text == "") {
      showCustomBar("Please Enter Residence City", Colors.red);
    } else if (_residenceaddressController.text == "") {
      showCustomBar("Please Enter Residence Address", Colors.red);
    } else if (_profiledescriptionController.text == "") {
      showCustomBar("Please Enter Profile Description", Colors.red);
    } else if (_aboutlifepartnerController.text == "") {
      showCustomBar("Please Enter About Life Partner", Colors.red);
    } else {
      const apiUrl = "http://kaverykannadadevangakulamatrimony.com/appadmin/api/member_temp_register2";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mobile = prefs.getString("mobile");
      String selectedPrefferendKulaids = prefferedKulaIdsToJson();

      final userData = {
        'mobile': mobile,
        'fathereducation': _fathereducationController.text.toString(),
        'foccupation': _fatheroccupationController.text.toString(),
        'meducation': _mothereducationController.text.toString(),
        'moccupation': _motheroccupationController.text.toString(),
        'father_native': _fathernativeController.text.toString(),
        'mother_native': _mothernativeController.text.toString(),
        'mothergotra': selectedGotra!.id,
        'motherkula': selectedKula!.id,
        'bro': _brotherController.text.toString(),
        'sis': _sisterController.text.toString(),
        'citizenship': citizenship.text.toString(),
        'residentstatus': selectedResidentOptions,
        'state': _residencestateController.text.toString(),
        'city': _residencecityController.text.toString(),
        'raddress': _residenceaddressController.text.toString(),
        'lifepartner': _aboutlifepartnerController.text.toString(),
        'pdesc': _profiledescriptionController.text.toString(),
        'preffered_kula': selectedPrefferendKulaids
      };

      print("Perosnal$userData");

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: jsonEncode(userData),
          headers: {'Content-Type': 'application/json'},
        );
        log('responce 2 : ${response.body}');
        if (response.statusCode == 200) {
          final bool status = json.decode(response.body)['status'];
          if (status == false) {
            showCustomBar("Error", Colors.red);
          } else {
            showCustomBar("Successfully", Colors.green);
         final result =   await   Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AstroDetails(),
            ));
            if (result == 'update') {
      // updateOtherDetailsOnBack();
    }
          }

          print(status);
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
  }

  void showCustomBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  String selectedFamilyValue = "";

  @override
  void initState() {
    super.initState();
    fetchGotras();
    fetchKulas();
    fetchCitizens();
    fetchsecondregister();
    getPrefferdkula();

     _fathereducationController.text = RegDetails.fatherName;
     _fatheroccupationController.text = RegDetails.fatherOccupation;
     _fathernativeController.text = RegDetails.fatherNative;
     _mothereducationController.text = RegDetails.motherEducation;
     _motheroccupationController.text = RegDetails.motherOccupation;
     _mothernativeController.text = RegDetails.motherNative;
     _brotherController.text = RegDetails.brother;
     _sisterController.text = RegDetails.sisters;
     citizenship.text = RegDetails.citizenship;
     _residencecityController.text = RegDetails.residenceCity;
     _residenceaddressController.text = RegDetails.residenceAddress;
     _profiledescriptionController.text = RegDetails.profileDescription;
     _aboutlifepartnerController.text = RegDetails.aboutLifePartner;
 
  }
 void updateOtherDetailsOnBack(){
    setState(() {
        selectedPrefferendKula = RegDetails.PrefferedKula;
   prefferendKula = RegDetails.prefferendKulaAll;
      // selectedGotra = RegDetails.motherGothra??null ;
      // selectedKula = RegDetails.motherkula??null ;
      selectedResidentOptions = RegDetails.residenceStatus;
      // selectedPrefferendKula = RegDetails.PrefferedKula;
    });
  }

//!
  List<PrefferdKula> prefferendKula = [];
  List<PrefferdKula> selectedPrefferendKula = [];

  Future<void> getPrefferdkula() async {
    try {
      final url = Uri.parse(
          'http://kaverykannadadevangakulamatrimony.com/appadmin/api/kula');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("data : $data");

        final pKula = (data['msg'] as List<dynamic>).map((kula) {
          return PrefferdKula.fromJson(kula);
        }).toList();

        setState(() {
          prefferendKula = pKula;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('ERROR : $e');
    }
  }
  Future<List<PrefferdKula>> getPrefferdkulas() async {
    try {
      final url = Uri.parse(
          'http://kaverykannadadevangakulamatrimony.com/appadmin/api/kula');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("data : $data");

        final pKula = (data['msg'] as List<dynamic>).map((kula) {
          return PrefferdKula.fromJson(kula);
        }).toList();

        setState(() {
          prefferendKula = pKula;
        });
        return pKula;
      } else {
        throw Exception('Failed to load data'); 
      }
    } catch (e) {
      log('ERROR : $e');
       return [];
    }
  }

//!
  Future<void> fetchsecondregister() async {
    try {
       log('started fetch details --1.1');
    await Future.delayed(const Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");

    final url = Uri.parse(
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/get_register2?mobile=${mobile!}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      bool status = json.decode(response.body)['status'];
      print(json.decode(response.body));
      if (status == true) {
        final List<dynamic> data = json.decode(response.body)['member_details'];
        log("data : ${data[0]}");
        setState(() {
          fathereducation = data[0]['fathereducation'];
          foccupation = data[0]['foccupation'];
          meducation = data[0]['meducation'];
          moccupation = data[0]['moccupation'];
          father_native = data[0]['father_native'];
          mother_native = data[0]['mother_native'];
          mothergotra = data[0]['mothergotra'];
          motherkula = data[0]['motherkula'];
          bro = data[0]['bro'];
          sis = data[0]['sis'];
          citizenshipval = data[0]['citizenship'];
          residentstatus = data[0]['residentstatus'];
          state = data[0]['state']??"";
          city = data[0]['city'];
          lifepartner = data[0]['lifepartner'];
          raddress = data[0]['raddress'];
          pdesc = data[0]['pdesc'];

          _fathereducationController.text = fathereducation;
          _fatheroccupationController.text = foccupation;
          _mothereducationController.text = meducation;
          _motheroccupationController.text = moccupation;
          _mothernativeController.text = mother_native;
          _fathernativeController.text = father_native;
          _brotherController.text = bro;
          _sisterController.text = sis;
          _aboutlifepartnerController.text = lifepartner;
          _profiledescriptionController.text = pdesc;
          _residenceaddressController.text = raddress;
          _residencecityController.text = city;
          _residencestateController.text = state;

              selectedGotra = RegDetails.motherGothra ;
              selectedKula = RegDetails.motherkula ;
              log('---2');
              log('selectedResidentOptions 1 : ${RegDetails.residenceStatus.isEmpty?visaOptions[0]:RegDetails.residenceStatus}');
              selectedResidentOptions = residentstatus.isEmpty?visaOptions[0]:residentstatus;
                 log('residentstatus 1 : $residentstatus');
              log('---3');

              selectedPrefferendKula = RegDetails.PrefferedKula;

          for (int i = 0; i < gotras.length; i++) {
            if (gotras[i].id == mothergotra) {
              selectedGotra = gotras[i];
            }
          }

          for (int i = 0; i < kulas.length; i++) {
            if (kulas[i].id == motherkula) {
              selectedKula = kulas[i];
            }
          }

          for (int i = 0; i < citizens.length; i++) {
            if (citizens[i].id == citizenshipval) {
              selectedCitizenship = citizens[i];
            }
          }

          citizenship.text = citizenshipval;
          if (state != "") {
            selectedResidentOptions = residentstatus;
            log('residentstatus 2 : $residentstatus');
            log('selectedResidentOptions 2 : $selectedResidentOptions');
          }

        
        });
          //! prefferd kula   preffered_kulla
           String pdescwe = data[0]['preffered_kulla'];
            log("pdescwe : $pdescwe");

            List<PrefferdKula> allPKula  =  await getPrefferdkulas();
            prefferendKula=allPKula;
            List<PrefferdKula> selectedKulas = findMatchingPreferredKula(pdescwe,allPKula);

            log('selectedKulas : ${selectedKulas.length}');
            selectedPrefferendKula=selectedKulas;
            setState(() {
              
            });
           
      }
    } else {
      throw Exception('Failed to load data');
    }
    } catch (e) {
      log('====================== fetchsecondregister error  ==========================');
      log(e.toString());
    }
   
  }

  List<PrefferdKula> findMatchingPreferredKula(String idString, List<PrefferdKula> allPKulas ) { 
  List<String> ids = idString.split(',');
  
  List<PrefferdKula> matchingKulaList = [];
  for (String id in ids) { 
    PrefferdKula? matchedKula = allPKulas.firstWhere(
      (kula) => kula.id == id, 
    );
 
    matchingKulaList.add(matchedKula);
    }
  
  return matchingKulaList;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe00a0a),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minimumSize: const Size(100, 50),
              ),
              child: const Text(
                "Personal Details",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Father Education",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _fathereducationController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Father Education",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Father Occupation",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _fatheroccupationController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Father Occupation",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Father Native",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _fathernativeController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Father Native",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Mother Education",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _mothereducationController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mother Education",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Mother Occupation",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _motheroccupationController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mother Occupation",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Mother Native",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _mothernativeController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mother Native",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Mother Gotra *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: selectedGotra==null?const CircularProgressIndicator(): DropdownButtonFormField<GotraModel>(
              hint: const Text("Mother Gotra"),
              value: selectedGotra,
              onChanged: (GotraModel? value) {
                setState(() {
                  selectedGotra = value;
                });
              },
              items:
                  gotras.map<DropdownMenuItem<GotraModel>>((GotraModel gotra) {
                return DropdownMenuItem(
                  value: gotra,
                  child: SizedBox(
                      width: 250,
                      child: Text('${gotra.englishName}/${gotra.tamilName}',
                          style: const TextStyle(fontSize: 13))),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Mother Kula *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: selectedKula==null ?const CircularProgressIndicator(): DropdownButtonFormField<KulaModel>(
              hint: const Text("Mother Kula"),
              value: selectedKula,
              onChanged: (KulaModel? value) {
                setState(() {
                  selectedKula = value;
                });
              },
              items: kulas.map<DropdownMenuItem<KulaModel>>((KulaModel kula) {
                return DropdownMenuItem(
                  value: kula,
                  child: Text('${kula.englishName}/${kula.tamilName}',
                      style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Brothers",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _brotherController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "(elder/younger/married/unmarried)",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Sisters",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sisterController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "(elder/younger/married/unmarried)",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Citizenship *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<CitizenModel>(
                hint: const Text("Select citizenship"),
                value: selectedCitizenship,
                onChanged: (CitizenModel? value) {
                  setState(() {
                    selectedCitizenship = value;
                    citizenship.text = value!.id.toString();
                  });
                },
                items: citizens.map<DropdownMenuItem<CitizenModel>>(
                  (CitizenModel citizen) {
                    return DropdownMenuItem(
                      value: citizen,
                      child: SizedBox(
                        width: 250,
                        child: Text(citizen.citizenName),
                      ),
                    );
                  },
                ).toList(),
                decoration: InputDecoration(
                  hintText: "Select citizenship",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Residence Status *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              // value: visaOptions[2],
              value: selectedResidentOptions,
              decoration: InputDecoration(
                hintText: "Residence Status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              icon: null,
              items: visaOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedResidentOptions = value;
                  });
                }
                // Handle the selected value
                print("Selected value: $value");
              },
            ),
          ),
          //! REMOVED RESIDENT STATE
          // const Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Text(
          //     "Residence State *",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextFormField(
          //     controller: _residencestateController,
          //     decoration: InputDecoration(
          //       fillColor: Colors.white,
          //       filled: true,
          //       hintText: "Residence State",
          //       focusedBorder: const OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.red, width: 1.3),
          //       ),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(5.0),
          //       ),
          //     ),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Residence City *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _residencecityController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Residence City",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Residence Address *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _residenceaddressController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Residence address",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Profile Description *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _profiledescriptionController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Profile Description",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "About Life Partner *",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _aboutlifepartnerController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "About Life Partner",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.3),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          //todo: prefferd kula
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Preffered Kula*",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: prefferendKula.map((e) { 
              return CheckboxListTile(
                title: Text('${e.tamilName} (${e.englishName})'),
                value: selectedPrefferendKula.contains(e)
                    ? true
                    : false,
                onChanged: (newValue) {
                  log('${e.tamilName} (${e.englishName})');

                  if (selectedPrefferendKula.contains(e)==true) {
                  log('not containing');

                    //! remove
                    setState(() {
                      selectedPrefferendKula.remove(e);
                    });
                  } else {
                  log(' containing');

                    //! add
                    setState(() {
                      selectedPrefferendKula.add(e);
                    });
                  }
                  log('selectedPrefferendKula : $selectedPrefferendKula');
                  log('selectedPrefferendKula : ${selectedPrefferendKula.length}');
                  // setState(() {
                  //   checkedValue = newValue;
                  // });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              );
              // return Text('${e.tamilName} (${e.englishName})');
            }).toList(),
          ),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "*Required fields",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                      // Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const register_Page(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9fd00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text(
                    "Prev",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    secondregistration();
                    RegDetails.fatherName=_fathereducationController.text;
                    RegDetails.fatherOccupation=_fatheroccupationController.text;
                    RegDetails.fatherNative=_fathernativeController.text;

                    RegDetails.motherEducation=_mothereducationController.text;
                    RegDetails.motherOccupation=_motheroccupationController.text;
                    RegDetails.motherNative=_mothernativeController.text;

                    RegDetails.motherGothra=selectedGotra;
                    RegDetails.motherkula=selectedKula;

                    RegDetails.brother=_brotherController.text;
                    RegDetails.sisters=_sisterController.text;
                    RegDetails.citizenship=citizenship.text;

                    RegDetails.residenceStatus=selectedResidentOptions.toString();

                    RegDetails.residenceCity=_residencecityController.text;
                    RegDetails.residenceAddress=_residenceaddressController.text;
                    RegDetails.profileDescription=_profiledescriptionController.text;
                    RegDetails.aboutLifePartner=_aboutlifepartnerController.text;

                    RegDetails.PrefferedKula= selectedPrefferendKula;
                    RegDetails.prefferendKulaAll= prefferendKula;
                     
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9fd00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(100, 50),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class PrefferdKula {
  String id;
  String tamilName;
  String englishName;

  PrefferdKula({
    required this.id,
    required this.tamilName,
    required this.englishName,
  });

  // Factory constructor to create an instance from JSON
  factory PrefferdKula.fromJson(Map<String, dynamic> json) {
    return PrefferdKula(
      id: json['id'] as String,
      tamilName: json['tamil_name'] as String,
      englishName: json['english_name'] as String,
    );
  }
}
