// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiUtils.dart';
import '../Models/CountryModel.dart';
import '../Models/GotraModel.dart';
import '../Models/KulaModel.dart';
import '../Models/citizen model.dart';
import '../activity/Home Screens/myprofile.dart';
import '../myprofile/height.dart';
import '../myprofile/moonsigns.dart';
import '../myprofile/stars.dart';

class basicdetails extends StatefulWidget {
  final String memberId;
  final String id;

  const basicdetails({super.key, required this.memberId, required this.id});


  @override
  State<basicdetails> createState() => _basicdetailsState();
}

class _basicdetailsState extends State<basicdetails> {



  final Apiservice apiService = Apiservice('http://kaverykannadadevangakulamatrimony.com/appadmin/api');
  final TextEditingController _dateController = TextEditingController();
  TextEditingController gotraController = TextEditingController();
  TextEditingController kulaController = TextEditingController();
  TextEditingController profileForController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController countryOfLivingController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController motherController = TextEditingController();
  List<KulaModel> kulas = [];
  List<CountryModel> countries = [];
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
    "Window/Windower",
    "Divorced",
    "Separated",
    "Others",
  ];
  List<String> visaOptions = [
    "--select an option--",
    "Permanent Resident",
    "Work Permit",
    "Student Visa",
    "Temporary Visa"
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

  String selGotra ="";
  String selKula = "";

  GotraModel? selectedGotra;
  KulaModel? selectedKula;
  CountryModel? selectedCountry;
  CitizenModel? selectedCitizenship;

  bool childvisible = false;

  String? noofchildern,childernlivingstatus;

  
    List<StateModel> stateList = [];
  List<DistrictModel> districtList = [];
    StateModel? selectedState;
  DistrictModel? selectedDistrict;

  void fetchGotras() async {
    print("fetchGotras called");
    gotras = await ApiUtils.fetchGotraList();
    // Set the selectedGotra if it's null or not part of the items
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

  @override
  void initState() {
    super.initState();
    fetchGotras();
    fetchKulas();
    fetchCountries();
    fetchCitizens();
    _fetchProfileData();
    fetchState(); 
    fetchCountries();


  }
   Future<List<DistrictModel>> fetchDistrictList(String id) async {
    try {
      final url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/district?state_id=$id';
    final uri = Uri.parse(url);
    final response = await http.post(uri);
    final body = response.body;
    final json = jsonDecode(body);
    log("json : ${json['district']}");

    final stateList = (json['district'] as List<dynamic>).map((country) {
      return DistrictModel.fromJson(country);
    }).toList();
    setState(() {
districtList=stateList;      
    });
    return stateList;
    } catch (e) {
      log("error : $e");
      return [];
    }
    
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

  void fetchDistrict(String stateId) async {
    print("fetch district called");

    districtList = (await fetchDistrictList(stateId)).cast<DistrictModel>();
    log("district 1 : $districtList");

    if (selectedDistrict == null || !districtList.contains(selectedDistrict)) {
      selectedDistrict = districtList.isNotEmpty ? districtList[0] : null;
    }
    setState(() {});
    print("fetchcountry completed");
  }
  void updateProfile() async {
    const apiUrl = "http://kaverykannadadevangakulamatrimony.com/appadmin/api/profile_update";


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;

    final userData = {
      'id': memberId,
      'name': nameController.text,
      'gender': genderController.text,
      'father_name': fatherController.text,
      'mother_name': motherController.text,
      'profile_for': profileForController.text,
      'gotra': gotraController.text,
      'kula': kulaController.text,
      'country_of_living': countryOfLivingController.text,
      'dob': _dateController.text,
      'marital_status': maritalStatusController.text,
      "children":noofchildern,
      "livingstatus":childernlivingstatus, 
      'state': selectedState!.id.toString() ,
      'district': selectedDistrict!.id.toString(),
      // Add other properties here
      // todo : add state and district
    };

    print(userData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      print(nameController.text);
      print(userData);

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
      print("Error updating profile: $e");
    }
  }



  List<dynamic> profileData = [];

  Future<void> _fetchProfileData() async {
log("Api called");
    await Future.delayed(Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString("id")!;
log("1");


    final url = Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/myprofile?member_id=$memberId');
    try {
      final response = await http.get(url);
log("2");

      if (response.statusCode == 200) {
log("3");

        var jsonResponse = json.decode(response.body);
log("4");
log("jsonResponse : ${jsonResponse}");

        setState(() {
          log('jsonResponse : ${jsonResponse.toString()}');
          profileData = [jsonResponse['member_details']]; // todo : some issue here
          log('profileData : ${profileData}');
          setState(() {
            nameController.text = profileData[0]['name']??"";
            fatherController.text = profileData[0]['father_name']??"";
            motherController.text = profileData[0]['mother_name']??"";
            selectedGender = profileData[0]['gender']??"";
            genderController.text = profileData[0]['gender']??"";
            selectedProfileCreatedBy = profileData[0]['profile_for']??"";
            profileForController.text = profileData[0]['profile_for']??"";
            _dateController.text = profileData[0]['dob']??"";
            selectedMaritalStatus =  profileData[0]['marital_status']??"";
            maritalStatusController.text =profileData[0]['marital_status']??"";
            gotraController.text =profileData[0]['gotra']??"";
            kulaController.text =profileData[0]['kula']??"";
             countryOfLivingController.text = profileData[0]['country_of_living']??"";

            if(profileData[0]['marital_status']!="Unmarried")
            {
              childvisible = true;
              noofchildern =  profileData[0]['children']??"";
              if(profileData[0]['livingstatus']!="")
                {
                  childernlivingstatus =profileData[0]['livingstatus']??"";
                }



            }
            else
            {
              childvisible = false;
            }

            for(int i=0;i<gotras.length;i++)
            {
              if(gotras[i].id==profileData[0]['gotra'])
              {
                selectedGotra =  gotras[i];
              }
            }

            for(int i=0;i<kulas.length;i++)
            {
              if(kulas[i].id==profileData[0]['kula'])
              {
                selectedKula =  kulas[i];
              }
            }
            if(profileData[0]['country_of_living']!=null)
              {
                for(int i=0;i<countries.length;i++)
                {
                  if(countries[i].id==profileData[0]['country_of_living'])
                  {
                    selectedCountry =  countries[i];
                  }
                }
              }

          });
        });
             log("country : ${profileData[0]['country_of_living']}");
        log("state : ${profileData[0]['state']}");
        log("district : ${profileData[0]['district']}");
          CountryModel? result = findCountryById(profileData[0]['country_of_living']);

          if (result != null) {
            print('Country found: ${result.countryName}');
            selectedCountry= result;
          } else {
            print('Country not found');
          }

          log('country_of_living : ${profileData[0]['country_of_living']}');
         
        if (profileData[0]['country_of_living'].toString()=='1') { 
          log('country checked success');
            StateModel? result1 = findStateById(profileData[0]['state']);
          selectedState= result1; 
          log('selectedState : ${selectedState}');
          log("DISTRICT DATA 1 : ${result1!.id}");
          List<DistrictModel> districtList =  await fetchDistrictList(result1.id);
          log("DISTRICT DATA 2 : ${districtList.length}");
         
          setState(() {});
        DistrictModel? result = findDistrictById(profileData[0]['district'],districtList);

          log("DISTRICT DATA 3 : ${result!.districtName}");
            // todo : fetch district
          selectedDistrict=result;
          setState(() {});

        } 

setState(() {});

      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }
  CountryModel? findCountryById(String id) {
  return countries.firstWhere(
    (country) => country.id == id,
    // orElse: () => null,  
  );
}
  DistrictModel? findDistrictById(String id,List<DistrictModel> districtList44) {
  return districtList44.firstWhere(
    (country) => country.id == id,
    // orElse: () => null,  
  );
}

  StateModel? findStateById(String id) {
  return stateList.firstWhere(
    (state) => state.id == id,
    // orElse: () => null,  
  );
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
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back icon here
        ),
        backgroundColor: Colors.red,
        title: Text("Basic details",style: TextStyle(color: Colors.white),),
      ),
      body:
      profileData.isNotEmpty?SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height:height/37.8,
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Name",labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepOrangeAccent, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(
                                  0.7), // Set your border color
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fatherController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Father Name",labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepOrangeAccent, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(
                                  0.7), // Set your border color
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: motherController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Mother Name",labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepOrangeAccent, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(
                                  0.7), // Set your border color
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        value: selectedGender,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Gender",labelStyle: TextStyle(
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
                        icon: null, // This will remove the dropdown icon
                        items: genderOptions
                            .map<DropdownMenuItem<String>>(
                                (String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                            genderController.text = selectedGender;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        value: selectedProfileCreatedBy,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Profile Created by",labelStyle: TextStyle(
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
                        icon: null,
                        items: profileCreatedByOptions
                            .map<DropdownMenuItem<String>>(
                              (String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProfileCreatedBy = value.toString();
                            profileForController.text =
                                selectedProfileCreatedBy;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<GotraModel>(
                        value: selectedGotra,
                        onChanged: (GotraModel? value) {
                          setState(() {
                            gotraController.text =
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
                                      '${gotra.englishName}/${gotra.tamilName}',
                                      style: TextStyle(
                                          fontSize: 11
                                      ),
                                    )),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Gotra",labelStyle: TextStyle(
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
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<KulaModel>(
                        hint: const Text("Select Kula"),
                        value: selectedKula,
                        onChanged: (KulaModel? value) {
                          setState(() {
                            selectedKula = value;
                            kulaController.text =
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
                                      '${kula.englishName}/${kula.tamilName}',
                                      style: TextStyle(
                                          fontSize: 11
                                      ),)
                                ),
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
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: TextFormField(
                          onTap: () {
                            _selectDate(context);
                          },
                          controller: _dateController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "mm/dd/yyyy",labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                            suffixIcon:
                            const Icon(Icons.calendar_today_rounded),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepOrangeAccent
                                    .withOpacity(
                                    0.7), // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<CountryModel>(
                        hint: const Text("Select country"),
                        value: selectedCountry,
                        onChanged: (CountryModel? value) {
                          setState(() {
                            selectedCountry = value;
                            countryOfLivingController.text =
                                value?.id ?? "";
                          });
                        },
                        items: countries
                            .map<DropdownMenuItem<CountryModel>>(
                                (CountryModel country) {
                              return DropdownMenuItem(
                                value: country,
                                child: SizedBox(
                                    width: 250,
                                    child: Text(country.countryName)),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Country of Living in",labelStyle: TextStyle(
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
                      height:10,
                    ),
            //         selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?
            // const Padding(
            //   padding: EdgeInsets.all(10.0),
            //   child: Text(
            //     "State of living in *",
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ):SizedBox(),
            selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<StateModel>(
                hint: const Text("State of living in *"),
                value: selectedState,
                onChanged: (StateModel? value) {
                  fetchDistrict(value!.id.toString());
                  setState(() {
                    selectedState = value;
                    // countryOfLivingController.text =
                    //     value?.id ?? "";
                  });
                },
                items: stateList
                    .map<DropdownMenuItem<StateModel>>(
                        (StateModel country) {
                      return DropdownMenuItem(
                        value: country,
                        child: SizedBox(
                            width: 250,
                            child: Text(country.stateName)),
                      );
                    }).toList(),
                  decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "State of living in",labelStyle: TextStyle(
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
            ):SizedBox(),
            //!
            //!
          //  selectedState?.stateName!=null&&  selectedCountry?.countryName=="India"  ?
          //   const Padding(
          //     padding: EdgeInsets.all(10.0),
          //     child: Text(
          //       "District of living in *",
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ):SizedBox(),
           selectedState?.stateName!=null &&  selectedCountry?.countryName=="India" ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<DistrictModel>(
                hint: const Text("District of living in *"),
                value: selectedDistrict,
                onChanged: (DistrictModel? value) {
                  setState(() {
                    selectedDistrict = value; 
                  });
                },
                items: districtList
                    .map<DropdownMenuItem<DistrictModel>>(
                        (DistrictModel country) {
                      return DropdownMenuItem(
                        value: country,
                        child: SizedBox(
                            width: 250,
                            child: Text(country.districtName)),
                      );
                    }).toList(),
                 decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "District of living in",labelStyle: TextStyle(
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
            ):SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedMaritalStatus,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Marital Status",labelStyle: TextStyle(
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
                        icon: null,
                        items: maritalStatusOptions
                            .map<DropdownMenuItem<String>>(
                              (String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMaritalStatus = value.toString();
                            maritalStatusController.text =
                                selectedMaritalStatus;
                            setState(() {
                              if(selectedMaritalStatus!="Unmarried")
                              {
                                childvisible = true;
                              }
                              else
                              {
                                childvisible = false;
                              }
                            });
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: childvisible,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              value: noofchildern,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Number of Children",labelStyle: TextStyle(
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
                              icon: null, // This will remove the dropdown icon
                              items: const [
                                DropdownMenuItem(
                                  value: "--select an option--",
                                  child: Text("--select an option--"),
                                ),
                                DropdownMenuItem(
                                  value: "None",
                                  child: Text("None"),
                                ),
                                DropdownMenuItem(
                                  value: "1",
                                  child: Text("1"),
                                ),
                                DropdownMenuItem(
                                  value: "2",
                                  child: Text("2"),
                                ),
                                DropdownMenuItem(
                                  value: "3",
                                  child: Text("3"),
                                ),
                                DropdownMenuItem(
                                  value: "4",
                                  child: Text("4 and Above"),
                                ),
                              ],
                              onChanged: (value) {
                                // Handle the selected value
                                noofchildern = value.toString();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              value: childernlivingstatus,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Children Living Status",labelStyle: TextStyle(
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
                              icon: null, // This will remove the dropdown icon
                              items: const [
                                DropdownMenuItem(
                                  value: "--select an option--",
                                  child: Text("--select an option--"),
                                ),
                                DropdownMenuItem(
                                  value: "None",
                                  child: Text("None"),
                                ),
                                DropdownMenuItem(
                                  value: "Living with me",
                                  child: Text("Living with me"),
                                ),
                                DropdownMenuItem(
                                  value: "Not Living with me",
                                  child: Text("Not Living with me"),
                                ),
                              ],
                              onChanged: (value) {
                                childernlivingstatus = value.toString();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed:(){
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
          ],
        ),
      ):Container(),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }
}
