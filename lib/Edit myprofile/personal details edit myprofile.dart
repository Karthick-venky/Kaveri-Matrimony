// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

// import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../ApiUtils.dart';
import '../Models/CountryModel.dart';
import '../Models/GotraModel.dart';
import '../Models/KulaModel.dart';
import '../Models/citizen model.dart';
import '../Screens/personaldetailregistration.dart';
import '../activity/Home Screens/myprofile.dart';
import '../myprofile/height.dart';
import '../myprofile/moonsigns.dart';
import '../myprofile/stars.dart';
import 'package:http/http.dart'as http;

class personaldetails extends StatefulWidget {
  final String memberId;
  final String id;

  const personaldetails({super.key, required this.memberId, required this.id});

  @override
  State<personaldetails> createState() => _personaldetailsState();
}

class _personaldetailsState extends State<personaldetails> {
  TextEditingController fathereducation = TextEditingController();
  TextEditingController fatheroccupation = TextEditingController();
  TextEditingController mothereducation = TextEditingController();
  TextEditingController motheroccupation = TextEditingController();
  TextEditingController fathernative= TextEditingController();
  TextEditingController mothernative = TextEditingController();
  TextEditingController motherkula = TextEditingController();
  TextEditingController motherkotra = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController alternatemobno = TextEditingController();
  TextEditingController landlineno = TextEditingController();
  TextEditingController brother = TextEditingController();
  TextEditingController sister = TextEditingController();
  TextEditingController citizenship = TextEditingController();
  TextEditingController residentstatus = TextEditingController();
  TextEditingController lifepartner = TextEditingController();
  TextEditingController profiledescription = TextEditingController();
  TextEditingController residentaddress = TextEditingController();
  TextEditingController state= TextEditingController();
  TextEditingController city= TextEditingController();
  List<KulaModel> kulas = [];
  List<CountryModel> countries = [];
  List<StateModel> stateList = [];
  List<DistrictModel> districtList = [];
  List<CitizenModel> citizens = [];
  List<GotraModel> gotras = [];
  List<String> profileCreatedByOptions = [
    "--select an option--",
    "Friends",
    "Parents",
    "Relatives",
    "Self",
    "Siblings",
  ];
  List<String> maritalStatusOptions = [
    "--select an option--",
    "Unmarried",
    "Widow/Widower",
    "Divorced",
    "Separator",
    "Others",
  ];
  List<String> visaOptions = [
    "--select an option--",
    "PermanentResident",
    "WorkPermit",
    "StudentVisa",
    "TemporaryVisa"
  ];
  List<String> occupationOptions = [
    "--select an option--",
    "Business",
    "Defence",
    "Government",
    "Not Working",
    "Others",
    "Private",
    "Self Employed",
  ];
  List<String> paymentFrequencyOptions = [
    "--select an option--",
    "Per Month",
    "Per Annual"
  ];
  List<String> bodyTypeOptions = ["Slim", "Average", "Athletic", "Heavy"];
  List<String> complexionOptions = [
    "Fair",
    "Very Fair",
    "Wheatish",
    "Wheatish Medium",
    "Wheatish Brown",
    "Dark",
  ];
  List<String> socioEconomicStatusOptions = [
    "Middle Class",
    "Upper Middle Class",
    "Rich",
    "Affluent",
  ];
  List<String> familyValuesOptions = [
    "Orthodox",
    "Traditional",
    "Moderate",
    "Liberal",
  ];
  String residentOptions = "--select an option--";
  List<String> genderOptions = ["--select an option--", "Male", "Female"];
  String selectedGender = "--select an option--";
  String selectedProfileCreatedBy = "--select an option--";
  String selectedMaritalStatus = "--select an option--";

  Nakshatra selectedNakshatra = nakshatras[0];
  MoonSign selectedMoonsign = moonSigns[0];
  Height selectedHeight = heights[0];


  GotraModel? selectedGotra;
  KulaModel? selectedKula;
  CountryModel? selectedCountry;
  StateModel? selectedState;
  DistrictModel? selectedDistrict;
  CitizenModel? selectedCitizenship;
  //!
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  //!

  void fetchGotras() async {
    print("fetchGotras called");
    gotras = await ApiUtils.fetchGotraList();
    if (selectedGotra == null || !gotras.contains(selectedGotra)) {
      selectedGotra = gotras.isNotEmpty ? gotras[0] : null;
    }
    setState(() {});
    print("fetchGotras completed");
  }

  void fetchKulas() async {
    print("fetchKulas called");
    kulas = await ApiUtils.fetchKulaList();
    // Set the selectedKula if it's null or not part of the items
    if (selectedKula == null || !kulas.contains(selectedKula)) {
      selectedKula = kulas.isNotEmpty ? kulas[0] : null;
    }
    setState(() {});
    print("fetchKulas completed");
  }

  void fetchCitizens() async {
    print("fetchCountries called");

    citizens = (await ApiUtils.fetchCitizenshipList()).cast<CitizenModel>();

    if (selectedCitizenship == null ||
        !citizens.contains(selectedCitizenship)) {
      selectedCitizenship = citizens.isNotEmpty ? citizens[0] : null;
      countryValue = countryValue.isNotEmpty ? citizens[0].citizenName.toString() : "";
    }
    setState(() {});
    print("fetchcountry completed");
  }

  void fetchCountries() async {
    print("fetchCountries called");

    countries = (await ApiUtils.fetchCountryList()).cast<CountryModel>();

    if (selectedCountry == null || !countries.contains(selectedCountry)) {
      selectedCountry = countries.isNotEmpty ? countries[0] : null;
    }
    setState(() {});
    print("fetchcountry completed");
  }

  void fetchState() async {
    print("fetchCountries called");

    stateList = (await ApiUtils.fetchStateList()).cast<StateModel>();
    log("state 1 : $stateList");

    if (selectedState == null || !stateList.contains(selectedState)) {
      selectedState = stateList.isNotEmpty ? stateList[0] : null;
    }
    setState(() {});
    print("fetchcountry completed");
  }

  void fetchDistrict() async {
    print("fetch district called");

    districtList = (await ApiUtils.fetchDistrictList()).cast<DistrictModel>();
    log("district 1 : $districtList");

    if (selectedDistrict == null || !districtList.contains(selectedDistrict)) {
      selectedDistrict = districtList.isNotEmpty ? districtList[0] : null;
    }
    setState(() {});
    print("fetchcountry completed");
  }

  @override
  void initState() {
    super.initState();
    fetchGotras();
    fetchKulas();
    fetchCountries();
    fetchCitizens();
    _fetchProfileData();
        getPrefferdkula();
        fetchState();
        fetchDistrict();

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

//!
String prefferedKulaIdsToJson() {
  List<String> idsList = selectedPrefferendKula.map((kula) => kula.id).toList();
  return idsList.join(',');
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
  void updateProfile() async {
 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String member_id = prefs.getString("id")!;

    log('id : $member_id');
    log('mobile : ${phonenumber.text}');

    final url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/update_mobile?id='+member_id+'&mobile='+phonenumber.text;
    final uri = Uri.parse(url);
    final response1 = await http.post(uri);
    final body = response1.body;
    final json = jsonDecode(body);
    final status = json['status'];
    log("============== RESULT ============== ");
    log("JSON : $json ");

    print(json);

    if(status==true)
      {
        const apiUrl = "http://kaverykannadadevangakulamatrimony.com/appadmin/api/personal_detail_update";
        String selectedPrefferendKulaids = prefferedKulaIdsToJson();

        final userData = {
          'id':member_id,
          'mobile': phonenumber.text,
          'alter_mobile':alternatemobno.text,
          'landline_no': landlineno.text,
          'fathereducation': fathereducation.text,
          'foccupation': fatheroccupation.text,
          'meducation':mothereducation.text,
          'moccupation': motheroccupation.text,
          'father_native': fathernative.text,
          'mother_native': mothernative.text,
          'mothergotra':motherkotra.text,
          'motherkula': motherkula.text,
          'bro': brother.text,
          'sis':sister.text,
          'citizenship': citizenship.text,
          'residentstatus':residentstatus.text,
          'country_of_living':selectedCountry.toString(),
          'district ':selectedDistrict!.id.toString(),
          'state':selectedState!.id.toString(), 
          'city':cityValue.toString(), 
          'raddress':residentaddress.text,
          'lifepartner':lifepartner.text,
          'pdesc':profiledescription.text,
          'preffered_kula':selectedPrefferendKulaids
        };

        log('userData : ${userData.toString()}');

        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            body: jsonEncode(userData),
            headers: {'Content-Type': 'application/json'},
          );
           log("response : $response ");

          if (response.statusCode == 200) {
            // Successfully updated profile

            log("Profile updated successfully");
            log("Response body: ${response.body}");
            // log(userData);
            log(response.body);
            // log(response.statusCode);
            showCustomBar("Profile updated successfully",Colors.green);
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
          print("Error updating profile: $e");
        }
      }
    else
    {
      showCustomBar(json['msg'].toString(), Colors.red);
    }


  }




  List<dynamic> profileData = [];

  Future<void> _fetchProfileData() async {

    await Future.delayed(Duration(seconds: 1));


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String member_id = prefs.getString("id")!;


    final url = Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/myprofile?member_id='+member_id);

    try {
      final response = await http.get(url);
      log('response : ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          profileData = [jsonResponse['member_details']];
          setState(() {
            fathereducation.text =profileData[0]['fathereducation'];
            fatheroccupation.text = profileData[0]['foccupation'];
            mothereducation.text = profileData[0]['meducation'];
            motheroccupation.text = profileData[0]['moccupation'];
            mothernative.text = profileData[0]['mother_native'];
            fathernative.text = profileData[0]['father_native'];
            phonenumber.text = profileData[0]['mobile'];
            landlineno.text = profileData[0]['landline_no'];
            brother.text = profileData[0]['bro'];
            sister.text = profileData[0]['sis'];
            residentstatus.text = profileData[0]['residentstatus'];
            state.text = profileData[0]['state'];
            city.text = profileData[0]['city'];
            lifepartner.text = profileData[0]['lifepartner'];
            profiledescription.text = profileData[0]['pdesc'];
            residentaddress.text = profileData[0]['raddress'];
            motherkotra.text =  profileData[0]['mothergotra'];
            motherkula.text =  profileData[0]['motherkula'];
            citizenship.text = profileData[0]['citizenship'];

            var pKula =profileData[0]['preffered_kulla'];
            // Step 1: Split the `pKula` string by commas to get the list of ids
List<String> ids = pKula.split(',');

// Step 2: Clear the selectedPrefferendKula list
selectedPrefferendKula.clear();
// Step 3: Iterate over the ids and add matching PrefferdKula objects to selectedPrefferendKula
for (String id in ids) {
  PrefferdKula? match = prefferendKula.firstWhere(
    (kula) => kula.id == id,
    // orElse: () => null, // Return null if no match is found
  );

  selectedPrefferendKula.add(match);
}


            for(int i=0;i<gotras.length;i++)
            {
              if(gotras[i].id==profileData[0]['mothergotra'])
              {
                selectedGotra =  gotras[i];
              }
            }

            for(int i=0;i<kulas.length;i++)
            {
              if(kulas[i].id==profileData[0]['motherkula'])
              {
                selectedKula =  kulas[i];
              }
            }

            for(int i=0;i<citizens.length;i++)
            {
              if(citizens[i].id==profileData[0]['citizenship'])
              {
                selectedCitizenship =  citizens[i];
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



  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        backgroundColor: Colors.red,
        title: Text("Personal Details",style: TextStyle(color: Colors.white),),
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height:height/37.8,
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: fathereducation,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Father Education",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: fatheroccupation,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Father Occupation",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mothereducation,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Mother Education",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: motheroccupation,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Mother Occupation",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: fathernative,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Father Native",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mothernative,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Mother Native",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<GotraModel>(
                  hint: const Text("Select Gotra"),
                  value: selectedGotra,
                  onChanged: (GotraModel? value) {
                    setState(() {
                      motherkotra.text =
                          value?.id ?? "";
                      selectedGotra = value;
                    });
                  },
                  items: gotras.map<DropdownMenuItem<GotraModel>>(
                          (GotraModel gotra) {
                        return DropdownMenuItem(
                          value: gotra,
                          child: SizedBox(
                              width: 250,
                              child: Text(
                                  '${gotra.englishName}/${gotra.tamilName}',style: TextStyle(
                                fontSize: 11
                              ),)),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
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
                height:height/37.8,
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<KulaModel>(
                  hint: const Text("Select Kula"),
                  value: selectedKula,
                  onChanged: (KulaModel? value) {
                    setState(() {
                      selectedKula = value;
                      motherkula .text =
                          value?.id ?? "";
                    });
                  },
                  items: kulas.map<DropdownMenuItem<KulaModel>>(
                          (KulaModel kula) {
                        return DropdownMenuItem(
                          value: kula,
                          child: SizedBox(
                              width: 250,
                              child: Text(
                                  '${kula.englishName}/${kula.tamilName}',style: TextStyle(
                                fontSize: 11,
                              ),)),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Kula",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phonenumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Phone number",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: alternatemobno,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Alternate mobile no",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: landlineno,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Landline No",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: brother,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Brother",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: sister,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Sisters",labelStyle: TextStyle(
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
                height:height/37.8,
              ),
              // TODO :  REMOVE
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<CitizenModel>(
                    hint: const Text("Select citizenship"),
                    value: selectedCitizenship,
                    onChanged: (CitizenModel? value) {
                      setState(() {
                        selectedCitizenship = value;
                        citizenship.text=
                            value?.id ?? "";
                      });
                    },
                    items: citizens
                        .map<DropdownMenuItem<CitizenModel>>(
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
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Citizenship",labelStyle: TextStyle(
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
                          color: Colors.deepOrangeAccent
                              .withOpacity(0.7),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )),
              SizedBox(
                height:height/37.8,
              ),
              // Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: DropdownButtonFormField<CountryModel>(
              //       hint: const Text("Select Country"),
              //       value: selectedCountry,
              //       onChanged: (CountryModel? value) {
              //         setState(() {
              //           selectedCountry = value;
              //           // if (value!="India") {
              //           //    selectedState = StateModel(stateName: '', id: '');
              //           //    selectedDistrict = DistrictModel(districtName: "",id: "");
              //           // }
                        
              //           // selectedCountry.text=
              //           //     value?.id ?? "";
              //         });
              //       },
              //       items: countries
              //           .map<DropdownMenuItem<CountryModel>>(
              //             (CountryModel country) {
              //           return DropdownMenuItem(
              //             value: country,
              //             child: Container(
              //               width: 250,
              //               child: Text(country.countryName),
              //             ),
              //           );
              //         },
              //       ).toList(),
              //       decoration: InputDecoration(
              //         fillColor: Colors.white,
              //         filled: true,
              //         labelText: "Country",labelStyle: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w500,
              //         fontSize: 18,
              //       ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //               color: Colors.red, width: 2),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Colors.deepOrangeAccent
              //                 .withOpacity(0.7),
              //           ),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //       ),
              //     )),
            //   SizedBox(
            //     height:height/37.8,
            //   ),
            //  selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: DropdownButtonFormField<StateModel>(
            //         hint: const Text("Select State"),
            //         value: selectedState,
            //         onChanged: (StateModel? value) {
            //           setState(() {
            //             selectedState = value;
            //             // selectedCountry.text=
            //             //     value?.id ?? "";
            //             //  if (value!="Tamil Nadu") {
            //             //    selectedDistrict = DistrictModel(districtName: "",id: "");
            //             // }
                        
            //           });
            //         },
            //         items: stateList
            //             .map<DropdownMenuItem<StateModel>>(
            //               (StateModel state) {
            //             return DropdownMenuItem(
            //               value: state,
            //               child: Container(
            //                 width: 250,
            //                 child: Text(state.stateName),
            //               ),
            //             );
            //           },
            //         ).toList(),
            //         decoration: InputDecoration(
            //           fillColor: Colors.white,
            //           filled: true,
            //           labelText: "State",labelStyle: TextStyle(
            //           color: Colors.black,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18,
            //         ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: const BorderSide(
            //                 color: Colors.red, width: 2),
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.deepOrangeAccent
            //                   .withOpacity(0.7),
            //             ),
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //         ),
            //       ))
            //    :SizedBox(),

            //  selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?    SizedBox(
            //     height:height/37.8,
            //   ):SizedBox(),
            //   selectedState?.stateName!=null&& selectedState?.stateName=="Tamil Nadu" ?
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: DropdownButtonFormField<DistrictModel>(
            //         hint: const Text("Select District"),
            //         value: selectedDistrict,
            //         onChanged: (DistrictModel? value) {
            //           setState(() {
            //             selectedDistrict = value;
            //             // selectedCountry.text=
            //             //     value?.id ?? "";
            //           });
            //         },
            //         items: districtList
            //             .map<DropdownMenuItem<DistrictModel>>(
            //               (DistrictModel state) {
            //             return DropdownMenuItem(
            //               value: state,
            //               child: Container(
            //                 width: 250,
            //                 child: Text(state.districtName),
            //               ),
            //             );
            //           },
            //         ).toList(),
            //         decoration: InputDecoration(
            //           fillColor: Colors.white,
            //           filled: true,
            //           labelText: "District",labelStyle: TextStyle(
            //           color: Colors.black,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 18,
            //         ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: const BorderSide(
            //                 color: Colors.red, width: 2),
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.deepOrangeAccent
            //                   .withOpacity(0.7),
            //             ),
            //             borderRadius: BorderRadius.circular(20),
            //           ),
            //         ),
            //       ))
            //    :SizedBox(),

            //   selectedState?.stateName!=null && selectedState?.stateName=="Tamil Nadu" ?   SizedBox(
            //     height:height/37.8,
            //   ):SizedBox(),
              //!  STATE
              //!
                //  Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 8),
                //         child: Container(
                //           padding: EdgeInsets.all( 5),
                //           // margin: EdgeInsets.all(5),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.all(Radius.circular(20 )),
                //             border: Border.all(
                //              color: Colors.red, width: 2
                //             ),
                //           ),
                //           child: CSCPicker(
                //             countrySearchPlaceholder: "Select citizenship",
                //             stateSearchPlaceholder: "Search State",
                //             citySearchPlaceholder: "Search City",

                //             countryDropdownLabel: countryValue.isEmpty
                //                 ? "Select Country"
                //                 : countryValue,
                //             //!
                //             stateDropdownLabel: stateValue.length==0 ? "State": stateValue.toString(),
                //             cityDropdownLabel: cityValue.length==0?"City":cityValue.toString(),
                //             //!
                //             selectedItemStyle: TextStyle(
                //               color: Colors.black,
                //               fontSize: 15,
                //             ),
                //             dropdownDecoration: BoxDecoration(
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(5)),
                //                 color: Colors.white,
                //                 border: Border.all(
                //                     color:
                //                         const Color.fromARGB(0, 255, 255, 255),
                //                     width: 1.0)),
                //             showStates: countryValue == "India",
                //             // showStates:   true ,
                //             flagState: CountryFlag.DISABLE,

                //             /// Enable disable city drop down [OPTIONAL PARAMETER]
                //             showCities: countryValue == "India",
                //             // showCities:  true ,

                //             onCountryChanged: (value) {
                //               log('countryValue :$countryValue');
                //               setState(() {
                //                 countryValue = value;
                //                 if (countryValue != "India") {
                //                   stateValue = "";
                //                   cityValue = "";
                //                 }
                //               });
                //             },
                //             onStateChanged: (value) {
                //               setState(() {
                //                 stateValue = value.toString();
                //               });
                //             },
                //             onCityChanged: (value) {
                //               setState(() {
                //                 cityValue = value.toString();
                //               });
                //             },
                //           ),
                //         ),
                //       ),
              //!
              // SizedBox(
              //   height:height/37.8,
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       fillColor: Colors.white,
              //       filled: true,
              //       hintText: "${_profile!.mobile}",
              //       labelText: "Citizenship",labelStyle: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 18,
              //     ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Colors.red, width: 2),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent
              //               .withOpacity(0.7),
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //     icon: null,
              //     // This will remove the dropdown icon
              //     items: visaOptions.map((String option) {
              //       return DropdownMenuItem(
              //         value: option,
              //         child: Text(option),
              //       );
              //     }).toList(),
              //     onChanged: (String? value) {
              //       // Handle the selected value
              //       print("Selected value: $value");
              //     },
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: residentstatus,
              //     decoration: InputDecoration(
              //       fillColor: Colors.white,
              //       filled: true,
              //       labelText: "Residing State",labelStyle: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 18,
              //     ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Colors.red, width: 2),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent.withOpacity(
              //               0.7), // Set your border color
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height:height/37.8,
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: residentaddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 50.0, horizontal: 16.0),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Residing Address",labelStyle: TextStyle(
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
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: profiledescription,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Profile Description",labelStyle: TextStyle(
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
              // SizedBox(
              //   height:height/37.8,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: state,
              //     decoration: InputDecoration(
              //       contentPadding: EdgeInsets.symmetric(
              //           vertical: 30.0, horizontal: 16.0),
              //       fillColor: Colors.white,
              //       filled: true,
              //       labelText: "State",labelStyle: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 18,
              //     ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Colors.red, width: 2),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent.withOpacity(
              //               0.7), // Set your border color
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height:height/37.8,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: city,
              //     decoration: InputDecoration(
              //       contentPadding: EdgeInsets.symmetric(
              //           vertical: 30.0, horizontal: 16.0),
              //       fillColor: Colors.white,
              //       filled: true,
              //       labelText: "City",labelStyle: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 18,
              //     ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             color: Colors.red, width: 2),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent.withOpacity(
              //               0.7), // Set your border color
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height:height/37.8,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: lifepartner,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "About Life Partner",labelStyle: TextStyle(
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
                height:height/37.8,
              ),
                 //todo: prefferd kula
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Preffered Kula*",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: prefferendKula.map((e) {
                      log("ISSelected : ${selectedPrefferendKula.contains(e)}");
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
