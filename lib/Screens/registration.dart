import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../Screens/personaldetailregistration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiUtils.dart';
import '../Models/CountryModel.dart';
import '../Models/GotraModel.dart';
import '../Models/KulaModel.dart';
import 'package:http/http.dart' as http;


class register_Page extends StatefulWidget {
  const register_Page({super.key});

  @override
  State<register_Page> createState() => _register_PageState();
}

class _register_PageState extends State<register_Page> {

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _altmobileController = TextEditingController();
  final TextEditingController _landlineController = TextEditingController();
  final TextEditingController _mothernameController = TextEditingController();
  final TextEditingController _fathernameController = TextEditingController();
  TextEditingController countryOfLivingController = TextEditingController();

  List<GotraModel> gotras = [];
  List<KulaModel> kulas = [];
  List<CountryModel> countries = [];

  GotraModel? selectedGotra;
  KulaModel? selectedKula;
  CountryModel? selectedCountry;


   String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  List<StateModel> stateList = [];
  List<DistrictModel> districtList = [];
  StateModel? selectedState;
  DistrictModel? selectedDistrict;

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
    log("fetchState called");
    try {
      stateList = (await ApiUtils.fetchStateList()).cast<StateModel>();
      log("State list: $stateList");

      if (selectedState == null || !stateList.contains(selectedState)) {
        setState(() {
          selectedState = stateList.isNotEmpty ? stateList[0] : null;
        });
      }
    } catch (e) {
      log("Error fetching states: $e");
      stateList = [];
    }

    if (selectedState != null) {
      await fetchDistrict(selectedState!.id);
    }
  }

  Future<void> fetchDistrict(String stateId) async {
    log("fetchDistrict called");
    try {
      districtList = (await fetchDistrictList(stateId)).cast<DistrictModel>();
      log("District list: $districtList");

      if (selectedDistrict == null || !districtList.contains(selectedDistrict)) {
        setState(() {
          selectedDistrict = districtList.isNotEmpty ? districtList[0] : null;
        });
      }
    } catch (e) {
      log("Error fetching districts: $e");
      districtList = [];
    }
  }


  String martialstatus = "--select an option--",profilecreated = "--select an option--",gender = "--select an option--";
  bool childvisible = false;

  String name = "",
  mobile_val = "",
  genderval="",
  email="",
  father_name ="",
  mother_name="",
  kula="",gotra="",
  profile_for="",
  dob="",
  // country_of_living="",
  marital_status="",
  children="",
  livingstatus="";


  String noofchildern = "--select an option--",childernlivingstatus = "--select an option--";


  bool validateEmail(String value) {
    String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(value);
  }

  Future<void> firstregistration() async {
    if (_firstController.text.trim().isEmpty) {
      showCustomBar("Please Enter First Name", Colors.red);
      return;
    } else if (_emailController.text.trim().isEmpty) {
      showCustomBar("Please Enter Email", Colors.red);
      return;
    } else if (!validateEmail(_emailController.text.trim())) {
      showCustomBar("Please Enter a Valid Email", Colors.red);
      return;
    } else if (_mobileController.text.trim().isEmpty) {
      showCustomBar("Please Enter Mobile Number", Colors.red);
      return;
    } else if (gender == "--select an option--") {
      showCustomBar("Please Select Gender", Colors.red);
      return;
    } else if (selectedCountry == null || selectedCountry!.countryName.isEmpty) {
      showCustomBar("Please Select Country Of Living", Colors.red);
      return;
    } else if (_fathernameController.text.trim().isEmpty) {
      showCustomBar("Please Enter Father Name", Colors.red);
      return;
    } else if (_mothernameController.text.trim().isEmpty) {
      showCustomBar("Please Enter Mother Name", Colors.red);
      return;
    } else if (profilecreated == "--select an option--") {
      showCustomBar("Please Select Profile Created By", Colors.red);
      return;
    } else if (selectedGotra == null || selectedGotra!.id == '0') {
      showCustomBar("Please Select Gotra", Colors.red);
      return;
    } else if (selectedKula == null || selectedKula!.id == '0') {
      showCustomBar("Please Select Kula", Colors.red);
      return;
    } else if (_dateController.text.trim().isEmpty) {
      showCustomBar("Please Select Date Of Birth", Colors.red);
      return;
    } else if (martialstatus == "--select an option--") {
      showCustomBar("Please Select Marital Status", Colors.red);
      return;
    }

    // Proceed with mobile validation
    final uri = Uri.parse(
      'https://kaverykannadadevangakulamatrimony.com/appadmin/api/mobile_validation?mobile=${_mobileController.text.trim()}',
    );

    try {
      final response1 = await http.get(uri);
      final json = jsonDecode(response1.body);

      if (json['status'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobile', _mobileController.text.trim());
        await prefs.setBool('registerworking', true);

        var request = http.Request(
          'POST',
          Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/member_profile_temp'),
        );

        request.bodyFields = {
          'name': _firstController.text.trim(),
          'email': _emailController.text.trim(),
          'gender': gender,
          'mobile': _mobileController.text.trim(),
          'father_name': _fathernameController.text.trim(),
          'mother_name': _mothernameController.text.trim(),
          'profile_for': profilecreated,
          'gotra': selectedGotra!.id,
          'kula': selectedKula!.id,
          'country_of_living': countryOfLivingController.text.trim(),
          'dob': _dateController.text.trim(),
          'marital_status': martialstatus,
          'children': noofchildern,
          'livingstatus': childernlivingstatus,
          'alter_mobile': _altmobileController.text.trim(),
          'state': selectedState?.id ?? "",
          'district': selectedDistrict?.id ?? "",
          'landline_no': _landlineController.text.trim(),
        };

        final response = await request.send();

        if (response.statusCode == 200) {
          showCustomBar("Successfully Registered", Colors.green);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PersonalDetailRegistration()),
          );
        } else {
          showCustomBar("Registration failed. Try again later.", Colors.red);
          print(response.reasonPhrase);
        }
      } else {
        showCustomBar(json['msg'].toString(), Colors.red);
      }
    } catch (e) {
      showCustomBar("An error occurred: $e", Colors.red);
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


  Future<void> fetchfirstregister() async {

    try {
      await Future.delayed(const Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");
    bool? registerworking = prefs.getBool("registerworking");
    print(registerworking);
    if(registerworking==true)
    {
      final url = Uri.parse(
          'http://kaverykannadadevangakulamatrimony.com/appadmin/api/get_register?mobile=${mobile!}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['member_details'];
        print(data);
        log('data : $data');

        log("============================================");
        log("data[0] : ${data[0]}");
        log("============================================");
        
      
          name = data[0]['name'];
          mobile_val = data[0]['mobile'];
          genderval = data[0]['gender'];
          email = data[0]['email'];
          father_name = data[0]['father_name'];
          mother_name = data[0]['mother_name'];
          kula = data[0]['kula'];
         var gotra1 = data[0]['gotra'];
         selectedGotra = gotras.firstWhere(
  (gotra) => gotra.id == gotra1,
  // orElse: () => null, // Return null if no match is found
);

          profile_for = data[0]['profile_for'];
          dob = data[0]['dob'];
          // country_of_living = data[0]['country_of_living'];
          marital_status = data[0]['marital_status'];
          children = data[0]['children'] ?? "";
          livingstatus = data[0]['livingstatus'] ?? "";
          noofchildern= data[0]['children'] ?? "";
          childernlivingstatus= data[0]['livingstatus'] ?? "";

          _altmobileController.text = data[0]['alter_mobile'] ?? "";
          _landlineController.text  = data[0]['landline_no'] ?? "";

          if(marital_status!="Unmarried")
            {
              childvisible = true;
            }

          _firstController.text = name;
          _mobileController.text = mobile_val;
          _emailController.text = email;
          _fathernameController.text = father_name;
          _mothernameController.text = mother_name;
          martialstatus = marital_status;
          _dateController.text = dob;
          profilecreated = profile_for;
          gender = genderval;
          // countryOfLivingController.text = country_of_living;
setState(() {});
          for(int i=0;i<gotras.length;i++)
          {
            if(gotras[i].id==gotra)
            {
              selectedGotra =  gotras[i];
            }
          }

          for(int i=0;i<kulas.length;i++)
          {
            if(kulas[i].id==kula)
            {
              selectedKula =  kulas[i];
            }
          }
setState(() {});
          // for(int i=0;i<countries.length;i++)
          // {
          //   if(countries[i].id==country_of_living)
          //   {
          //     selectedCountry =  countries[i];
          //   }
          // }
          // selectedCountry=

        log("country : ${data[0]['country_of_living']}");
        log("state : ${data[0]['state']}");
        log("district : ${data[0]['district']}");
        // countries
        CountryModel? result = findCountryById(data[0]['country_of_living']);

          if (result != null) {
            print('Country found: ${result.countryName}');
            selectedCountry= result;
             setState(() {});
          } else {
            print('Country not found');
          }
         
        if (data[0]['country_of_living']=='1') { 
            StateModel? result1 = findStateById(data[0]['state']);
          selectedState= result1; 
          log("DISTRICT DATA 1 : ${result1!.id}");
          List<DistrictModel> districtList =  await fetchDistrictList(result1.id);
          log("DISTRICT DATA 2 : ${districtList.length}");

          setState(() {});
        DistrictModel? result = findDistrictById(data[0]['district'],districtList);

 log("DISTRICT DATA 3 : ${result!.districtName}");
  // todo : fetch district
      selectedDistrict=result;
        } 

setState(() {});
log('====== FULL DATA ====');
log('marital_status : $marital_status');
log('selectedGotra : ${selectedGotra?.englishName??"NO"}');

      } else {
        throw Exception('Failed to load data');
      }
    }
    } catch (e) {
      log('---------------- got error ------------------------');
      log('ERROR : ${e.toString()}');
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

  @override
  void initState() {
    super.initState();
    fetchGotras();
    fetchKulas();
    fetchCountries();

    fetchState();
       
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: Center(
                child: Text(
                  "Register Now" ,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                  "Basic Details",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "First Name *",
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
                controller : _firstController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "First Name",
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
                "Email *",
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Email",
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
                "Phone Number *",
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
                keyboardType: TextInputType.number,
                controller: _mobileController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Phone Number",
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
                "Alternate Mobile No",
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
                keyboardType: TextInputType.number,
                controller: _altmobileController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Alternate mobile no ",
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
                "Gender*",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: gender,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "--Select an option--",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                icon: null, // This will remove the dropdown icon
                items: const [
                  DropdownMenuItem(
                    value: "--select an option--",
                    child: Text("--select an option--"),
                  ),
                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male"),
                  ),
                  DropdownMenuItem(
                    value: "Female",
                    child: Text("Female"),
                  ),
                ],
                onChanged: (value) {
                  gender = value!;
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Landline No",
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
                keyboardType: TextInputType.number,
                controller: _landlineController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Landline No ",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //!
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Country of living in *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<CountryModel>(
                hint: const Text("Country of living in *"),
                value: selectedCountry,
                onChanged: (CountryModel? value) {
                  setState(() {
                    selectedCountry = value;
                    countryOfLivingController.text =
                        value?.id ?? "";
                  });
                },
                items: countries.map<DropdownMenuItem<CountryModel>>(
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
                  hintText: "--Select an option--",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //!
            //!


            selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "State of living in *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ):const SizedBox(),

            selectedCountry?.countryName!=null&&  selectedCountry?.countryName=="India" ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<StateModel>(
                hint: const Text("State of living in *"),
                value: selectedState,
                onChanged: (StateModel? value) {

                  setState(() {
                    selectedState = value;
                     fetchDistrict(value!.id.toString());
                  });
                },
                items: stateList.map<DropdownMenuItem<StateModel>>(
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
                  hintText: "--Select an option--",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ):const SizedBox(),
            //!
            //!



           selectedState?.stateName!=null&&  selectedCountry?.countryName=="India"  ?
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "District of living in *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ):const SizedBox(),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<DistrictModel>(
                hint: const Text("District of living in *"),
                value: selectedDistrict,
                onChanged: selectedState?.stateName != null &&
                    selectedCountry?.countryName == "India"
                    ? (DistrictModel? value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                }
                    : null,
                items: selectedState?.stateName != null &&
                    selectedCountry?.countryName == "India"
                    ? districtList.map<DropdownMenuItem<DistrictModel>>(
                        (DistrictModel district) {
                      return DropdownMenuItem(
                        value: district,
                        child: SizedBox(
                          width: 250,
                          child: Text(district.districtName),
                        ),
                      );
                    }).toList()
                    : [],
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "--Select an option--",
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
                "Father Name *",
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
                controller: _fathernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Father Name ",
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
                "Mother Name *",
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
                controller: _mothernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Mother Name ",
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
                "Profile Created by *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: profilecreated,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "--Select an option--",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                icon: null, // This will remove the dropdown icon
                items:  const [
                  DropdownMenuItem(
                    value: "--select an option--",
                    child: Text("--select an option--"),
                  ),
                  DropdownMenuItem(
                    value: "Friends",
                    child: Text("Friends"),
                  ),
                  DropdownMenuItem(
                    value: "Parents",
                    child: Text("Parents"),
                  ),
                  DropdownMenuItem(
                    value: "Relatives",
                    child: Text("Relatives"),
                  ),
                  DropdownMenuItem(
                    value: "Self",
                    child: Text("Self"),
                  ),
                  DropdownMenuItem(
                    value: "Siblings",
                    child: Text("Siblings"),
                  ),
                ],
                onChanged: (value) {
                  profilecreated = value!;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Gotra *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<GotraModel>(
                hint: const Text("Select Gotra"),
                value: selectedGotra,
                onChanged: (GotraModel? value) {
                  setState(() {
                    selectedGotra = value;
                  });
                },
                items: gotras
                    .map<DropdownMenuItem<GotraModel>>((GotraModel gotra) {
                  return DropdownMenuItem(
                    value: gotra,
                    child: SizedBox(
                        width: 250,
                        child: Text('${gotra.englishName}/${gotra.tamilName}',style: const TextStyle(
                            fontSize: 13
                        ))),
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
                "Kula *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<KulaModel>(
                hint: const Text("Select Kula"),
                value: selectedKula,
                onChanged: (KulaModel? value) {
                  setState(() {
                    selectedKula = value;
                  });
                },
                items: kulas.map<DropdownMenuItem<KulaModel>>((KulaModel kula) {
                  return DropdownMenuItem(
                    value: kula,
                    child: Text('${kula.englishName}/${kula.tamilName}',style: const TextStyle(
                        fontSize: 13
                    )),
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
                "Date of Birth *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: TextFormField(
                  onTap: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                  controller: _dateController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "dd-mm-yyyy",
                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Martial Status *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: martialstatus,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "--Select an option--",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
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
                    value: "Window/Windower",
                    child: Text("Widow / Widower"),
                  ),
                  DropdownMenuItem(
                    value: "Divorced",
                    child: Text("Divorced"),
                  ),
                  DropdownMenuItem(
                    value: "Separated",
                    child: Text("Separated"),
                  ),
                  DropdownMenuItem(
                    value: "Others",
                    child: Text("Others"),
                  ),
                ],
                onChanged: (value) {
                  // Handle the selected value
                  martialstatus = value!;
                  setState(() {
                    if(martialstatus!="Unmarried")
                    {
                      childvisible = true;
                    }
                    else
                    {
                      childvisible = false;
                    }
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
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Number of Children",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: noofchildern,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "--Select an option--",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
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
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Children Living Status",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: childernlivingstatus,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "--Select an option--",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  firstregistration();
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
      ),
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
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }
}
