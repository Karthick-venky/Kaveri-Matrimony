import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../Models/CountryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../other_files/api_utils.dart';
import '../../Models/GotraModel.dart';
import '../../Models/KulaModel.dart';
import '../../Models/matched profile model.dart';
import '../../Models/search member id model.dart';
import '../../myprofile/searchheights.dart';
import '../../myprofile/searchmoonSigns.dart';
import '../../myprofile/searcknakshtra.dart';
import '../../other_files/global.dart';
import '../BottomBar/bottombar.dart';
import '../Home Screens/viewprofile.dart';
import 'advanceserach.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  double selectedHeight = 0.0;

  TextEditingController memberIdController = TextEditingController();
  TextEditingController fromheightController = TextEditingController();
  TextEditingController toheightController = TextEditingController();

  String memberDetails = '';
  List<ProfileModel> allProfiles = [];
  List<ProfileModel> filteredProfiles = [];
  TextEditingController gotraController = TextEditingController();
  TextEditingController kulaController = TextEditingController();
  TextEditingController dosamController = TextEditingController();
  TextEditingController MoonsignController = TextEditingController();
  TextEditingController starController = TextEditingController();
  TextEditingController martController = TextEditingController();

  int a = 0;
  int b = 1;

  List<GotraModel> gotras = [];
  List<KulaModel> kulas = [];

  SearchNakshatra selectedNakshatra = searchNakshatras[0];
  SearchMoonSign selectedMoonsign = searchMoonSigns[0];
  String selectedDosam = "--select an option--";
  String? selectedSubDosam;
  List<String> dosamOptions = [
    "--select an option--",
    "yes",
    "No",
    "Do Not Know",
    "Not Applicable",
  ];
  List<String> subDosamOptions = [
    "--select an option--",
    "Ragu/Keethu",
    "Seva",
    "RaguKeethu/Seva",
  ];


  GotraModel? selectedGotra;
  KulaModel? selectedKula;
  int selectedfromValue = 0, selectedtoValue = 0;

  // String countryValue = "";
  // String stateValue = "";
  String cityValue = "";
  String address = "";

  //!
    StateModel? selectedState;
  DistrictModel? selectedDistrict;
   CountryModel? selectedCountry;
     List<CountryModel> countries = [];
  List<StateModel> stateList = [];
  List<DistrictModel> districtList = [];
  List<Job> jobList = [];
  String? selectedJob;
  //!

    void fetchCountries() async {
    print("fetchCountries called");

    countries = (await ApiUtils.fetchCountryList()).cast<CountryModel>();

    if (selectedCountry == null || !countries.contains(selectedCountry)) {
      // selectedCountry = countries.isNotEmpty ? countries[0] : null;
    }
    setState(() {});
    print("fetchcountry completed");
  }

  void fetchState() async {
    print("fetchCountries called");

    stateList = (await ApiUtils.fetchStateList()).cast<StateModel>();
    log("state 1 : $stateList");

    if (selectedState == null || !stateList.contains(selectedState)) {
      // selectedState = stateList.isNotEmpty ? stateList[0] : null;
      //  fetchDistrict(selectedState!.id.toString());
    }
    setState(() {});
    print("fetchcountry completed");
  }

  void fetchDistrict(String stateId) async {
    print("fetch district called");

    districtList = (await  fetchDistrictList(stateId)).cast<DistrictModel>();
    log("district 1 : $districtList");

    if (selectedDistrict == null || !districtList.contains(selectedDistrict)) {
      selectedDistrict = districtList.isNotEmpty ? districtList[0] : null;
    }
    setState(() {});
    print("fetchcountry completed");
  }


  Future<List<DistrictModel>> fetchDistrictList(String id) async {
    try {
      final url = '${GlobalVariables.baseUrl}appadmin/api/district?state_id=$id';
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

  List<String> ageOptions = ["--select an option--"];

  Future<List<SearchProfileModel>> getProfileData(String memberId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gender = prefs.getString("gender")!;
    print(gender);
    final response = await http.get(
      Uri.parse('${GlobalVariables.baseUrl}appadmin/api/search_by_id?member_id=${memberId}&gender=${ gender == "Male" ? "male":"female"}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['member_details'];
      print("sdsd"+data.toString());

      // Check if data is not empty
      if (data.isNotEmpty) {
        // Assuming SearchProfileModel has a named constructor fromJson KKDMB00177
        print("success");
        print(data.first);
        return data
            .map((profileJson) => SearchProfileModel.fromJson(profileJson))
            .toList();
      } else {
        print("exe");
        throw Exception("No data available for the given member ID.");

      }
    } else {
      print("Exe");

      throw Exception("Error fetching profile data: ${response.statusCode}");
    }
  }

   Future<void> fetchJobs() async {
    final response = await http.get(Uri.parse('${GlobalVariables.baseUrl}appadmin/api/jobs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['msg'];
      setState(() {
        jobList = jsonResponse.map((job) => Job.fromJson(job)).toList();
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }


  Future<SearchProfileModel?> _searchProfile(String memberId) async {
    try {
      final List<SearchProfileModel> profiles = await getProfileData(memberId);

      if (profiles.isNotEmpty) {
        return profiles.first; // Return the first profile if available
      } else {
        return null; // Return null if no profiles are found
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
     fetchJobs();

    fetchGotras();
    fetchKulas();
    fetchCountries();
     fetchState();
        // fetchDistrict();
    for (int i = 18; i <= 58; i++) {
      ageOptions.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.pink,
                ),
                width: 120,
                height: 50,
                child: const Center(
                    child: Text(
                  "Find Partner",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      a = 1;
                      b = 0;
                    });
                  },
                  child: a == 1
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue,
                          ),
                          width: 150,
                          height: 40,
                          child: const Center(
                              child: Text(
                            "Advanced Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          width: 150,
                          height: 40,
                          child: const Center(
                              child: Text(
                            "Advanced Search",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      a = 0;
                      b = 1;
                    });
                  },
                  child: b == 1
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue,
                          ),
                          width: 190,
                          height: 40,
                          child: const Center(
                              child: Text(
                            "Search By Matrimony id",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          width: 190,
                          height: 40,
                          child: const Center(
                              child: Text(
                            "Search By Matrimony id",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                ),
              ],
            ),
            a == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "From Age",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                          // This will remove the dropdown icon
                          items: ageOptions.map((String option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            selectedfromValue = int.parse(value!);
                            ;
                          },
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "To Age",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                          // This will remove the dropdown icon
                          items: ageOptions.map((String option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            selectedtoValue = int.parse(value!);
                            ;
                          },
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField<GotraModel>(
                          hint: const Text("Select Gotra"),
                          initialValue: selectedGotra,
                          onChanged: (GotraModel? value) {
                            setState(() {
                              gotraController.text = value?.id ?? "";
                              selectedGotra = value;
                            });
                          },
                          items: gotras.map<DropdownMenuItem<GotraModel>>(
                              (GotraModel gotra) {
                            return DropdownMenuItem(
                              value: gotra,
                              child: Container(
                                  width: 250,
                                  child: Text(
                                    '${gotra.englishName}/${gotra.tamilName}',
                                    style: TextStyle(fontSize: 11),
                                  )),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Gotra",
                            labelStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField<KulaModel>(
                          hint: const Text("Select Kula"),
                          initialValue: selectedKula,
                          onChanged: (KulaModel? value) {
                            setState(() {
                              selectedKula = value;
                              kulaController.text = value?.id ?? "";
                            });
                          },
                          items: kulas.map<DropdownMenuItem<KulaModel>>(
                              (KulaModel kula) {
                            return DropdownMenuItem(
                              value: kula,
                              child: Container(
                                  width: 300,
                                  child: Text(
                                    '${kula.englishName}/${kula.tamilName}',
                                    style: TextStyle(fontSize: 11),
                                  )),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Kula",
                            labelStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Martial Status *",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null, // This will remove the dropdown icon
                          items: const [
                            DropdownMenuItem(
                              value: "--select an option--",
                              child: Text("--select an option--"),
                            ),
                            DropdownMenuItem(
                              value: "Unmarried",
                              child: Text("Unmarried"),
                            ),
                            DropdownMenuItem(
                              value: "Widow/Widower",
                              child: Text("Widow/Widower"),
                            ),
                            DropdownMenuItem(
                              value: "Divorced",
                              child: Text("Divorced"),
                            ),
                            DropdownMenuItem(
                              value: "Separator",
                              child: Text("Separator"),
                            ),
                            DropdownMenuItem(
                              value: "Others",
                              child: Text("Others"),
                            ),
                          ],
                          onChanged: (value) {
                            martController.text = value.toString();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Moonsign",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                          items: searchMoonSigns.map((SearchMoonSign moonsign) {
                            return DropdownMenuItem<SearchMoonSign>(
                              value: moonsign,
                              child: Text(moonsign.name),
                            );
                          }).toList(),
                          onChanged: (SearchMoonSign? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedMoonsign = newValue;
                                MoonsignController.text =
                                    newValue.name.toString();
                                print(newValue.name.toString());
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Jobs",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                           items: jobList.map<DropdownMenuItem<String>>((Job job) {
                  return DropdownMenuItem<String>(
                    value: job.job,
                    child: Text(job.job),
                  );
                }).toList(),
                          onChanged: (String? newValue) {
                            // if (newValue != null) {
                              setState(() {
                    selectedJob = newValue;
                  });
                            // }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // todo : country
                        Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: DropdownButtonFormField<CountryModel>(
                    hint: const Text("Select Country"),
                      decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Select Country",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                    initialValue: selectedCountry,
                    onChanged: (CountryModel? value) {
                      setState(() {
                        selectedCountry = value;
                        // if (value!="India") {
                        //    selectedState = StateModel(stateName: '', id: '');
                        //    selectedDistrict = DistrictModel(districtName: "",id: "");
                        // }

                        // selectedCountry.text=
                        //     value?.id ?? "";
                      });
                    },
                    items: countries
                        .map<DropdownMenuItem<CountryModel>>(
                          (CountryModel country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Container(
                            width: 250,
                            child: Text(country.countryName),
                          ),
                        );
                      },
                    ).toList(),

                  )),
                selectedCountry?.countryName==null  ?SizedBox( height: 20,):  SizedBox(  ),
                selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?SizedBox( height: 20,):  SizedBox(  ),
                  //!
                  selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: DropdownButtonFormField<StateModel>(
                    hint: const Text("Select State"),
                      decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Select State",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                    initialValue: selectedState,
                    onChanged: (StateModel? value) {
                       fetchDistrict(value!.id.toString());
                      setState(() {
                        selectedState = value;
                        // selectedCountry.text=
                        //     value?.id ?? "";
                        //  if (value!="Tamil Nadu") {
                        //    selectedDistrict = DistrictModel(districtName: "",id: "");
                        // }

                      });
                    },
                    items: stateList
                        .map<DropdownMenuItem<StateModel>>(
                          (StateModel state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Container(
                            width: 250,
                            child: Text(state.stateName),
                          ),
                        );
                      },
                    ).toList(),

                  ))
               :SizedBox(),

                selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?    SizedBox(
                height: 20,
              ):SizedBox(),
              selectedState?.stateName!=null&& selectedCountry?.countryName=="India"  ?
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: DropdownButtonFormField<DistrictModel>(
                    hint: const Text("Select District"),
                      decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Select District",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                    initialValue: selectedDistrict,
                    onChanged: (DistrictModel? value) {
                      setState(() {
                        selectedDistrict = value;
                        // selectedCountry.text=
                        //     value?.id ?? "";
                      });
                    },
                    items: districtList
                        .map<DropdownMenuItem<DistrictModel>>(
                          (DistrictModel state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Container(
                            width: 250,
                            child: Text(state.districtName),
                          ),
                        );
                      },
                    ).toList(),
                  ))
               :SizedBox(),
                selectedState?.stateName!=null && selectedCountry?.countryName=="India"  ?   SizedBox(
                  height: 20,
              ):SizedBox(),

                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Star",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                          items:
                              searchNakshatras.map((SearchNakshatra nakshatra) {
                            return DropdownMenuItem<SearchNakshatra>(
                              value: nakshatra,
                              child: Text(nakshatra.name),
                            );
                          }).toList(),
                          onChanged: (SearchNakshatra? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedNakshatra = newValue;
                                starController.text =
                                    selectedNakshatra.name.toString();
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              //value:   subDosamOptions[0]!.first,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Dosam",
                                labelStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 5, // Set your border color
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              icon: null,
                              items: subDosamOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  selectedSubDosam = value;
                                  dosamController.text = selectedSubDosam!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField<SearchHeight>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "From Height",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                          items: searchHeights
                              .map<DropdownMenuItem<SearchHeight>>(
                                  (SearchHeight height) {
                            return DropdownMenuItem<SearchHeight>(
                              value: height,
                              child: Text(height.displayText),
                            );
                          }).toList(),
                          onChanged: (SearchHeight? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedHeight = newValue.value;
                                fromheightController.text =
                                    newValue.displayText;
                              });
                            }
                            print("Selected height value: ${newValue?.value}");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: DropdownButtonFormField<SearchHeight>(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "To Height",
                            labelStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 5, // Set your border color
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          icon: null,
                          items: searchHeights
                              .map<DropdownMenuItem<SearchHeight>>(
                                  (SearchHeight height) {
                            return DropdownMenuItem<SearchHeight>(
                              value: height,
                              child: Text(height.displayText),
                            );
                          }).toList(),
                          onChanged: (SearchHeight? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedHeight = newValue.value;
                                toheightController.text = newValue.displayText;
                              });
                            }
                            print("Selected height value: ${newValue?.value}");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (martController.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                    child: Text(
                                      "Please Select Martial Status",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              );

                            } else {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdvanceSearch(
                                      kula: kulaController.text.toString(),
                                      gotra: gotraController.text.toString(),
                                      fromage: selectedfromValue.toString() ==
                                              "--select an option--"
                                          ? ""
                                          : selectedfromValue.toString(),
                                      toage: selectedtoValue.toString() == "--select an option--"
                                          ? ""
                                          : selectedtoValue.toString(),
                                      moonsign: MoonsignController.text.toString() ==
                                              "--select an option--"
                                          ? ""
                                          : MoonsignController.text.toString(),
                                      star: starController.text.toString() ==
                                              "--select an option--"
                                          ? ""
                                          : starController.text.toString(),
                                      dosam: dosamController.text.toString() ==
                                              "--select an option--"
                                          ? ""
                                          : dosamController.text.toString(),
                                      from_height: fromheightController.text.toString() ==
                                              "--select an option--"
                                          ? ""
                                          : fromheightController.text.toString(),
                                      to_height: toheightController.text.toString() == "--select an option--" ? "" : toheightController.text.toString(),
                                      martial: martController.text.toString() == "--select an option--" ? "" : martController.text.toString(),
                                       // Add the country, state, and city values here
                                  country:  selectedCountry?.id ??"", // Pass countryValue
                                  state: selectedState?.id??"" , // Pass stateValue
                                  district: selectedDistrict?.id ??"" , // Pass stateValue
                                  // state: stateValue.toString() , // Pass stateValue
                                  city: cityValue.toString(), // Pass cityValue
                                  job:selectedJob??""
                                      ),

                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.yellow,
                            textStyle: TextStyle(fontSize: 18,),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          child: Text("Search Profile"),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "Search for a specific profile by entering the unique Matrimony ID",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 40,
                              width: 160,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                  )),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: TextField(
                                    controller: memberIdController,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "KKDMBD00010",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final String memberId =
                                    memberIdController.text.trim();
                                if (memberId.isNotEmpty) {
                                  try {
                                    final SearchProfileModel? profile =
                                        await _searchProfile(memberId);
                                    if (profile != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => viewProfile(
                                            memberId: profile.id,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Member ID not found
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              "Sorry! You Can't Search Same Gender.",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(
                                            "Sorry! You Can't Search Same Gender.",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    );
                                    print("Error: $error");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.yellow,
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                              child: Text("Search"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
          ]),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the back icon here
          ),
          title: Text(
            "Search",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFB30000),
        ),
        bottomNavigationBar: BottomBar(index: 1),
      ),
    );
  }
}
class Job {
  final String id;
  final String job;

  Job({required this.id, required this.job});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      job: json['job'],
    );
  }
}
