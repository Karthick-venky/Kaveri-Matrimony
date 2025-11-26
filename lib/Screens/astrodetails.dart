// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import '../../Models/CountryModel.dart';
import '../../activity/SearchScreen/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../export.dart';
import '../myprofile/height.dart';
import '../myprofile/moonsigns.dart';
import '../myprofile/stars.dart';
import '../myprofile/weight.dart';

import 'package:http/http.dart' as http;

import 'familydetails.dart';
import 'personaldetailregistration.dart';

class AstroDetails extends StatefulWidget {
  const AstroDetails({super.key});

  @override
  State<AstroDetails> createState() => _EduAstroDetailsState();
}

class _EduAstroDetailsState extends State<AstroDetails>  with WidgetsBindingObserver {



  TextEditingController _placeofbirthController = TextEditingController();
  TextEditingController _placeofDistrictController = TextEditingController();
  TextEditingController _timeofbirthController = TextEditingController();
  TextEditingController starController = TextEditingController();
  TextEditingController MoonsignController = TextEditingController();
  // TextEditingController PathamController = TextEditingController();
  TextEditingController lagnamController = TextEditingController();
  TextEditingController selectedDosamController = TextEditingController();
  TextEditingController selectedsubDosamController = TextEditingController();
  TextEditingController dosamController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _dosamdetailsController = TextEditingController();
  TextEditingController employedin = TextEditingController();
  TextEditingController incomecontroller = TextEditingController();
  TextEditingController percontroller = TextEditingController();
  TextEditingController Occupationdetails = TextEditingController();
  Nakshatra selectedNakshatra = nakshatras[0];
 
  MoonSign selectedMoonsign = moonSigns[0];
  // String selectedPatham = patham[0] as String;
  MoonSign selectedLagnam = moonSigns[0];
  String selectedDosam = "--select an option--";
  String? selectedSubDosam;
  String horscopmatch = "Select a Option";

  String? selectedHeight;
  String? selectedBodyType;

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bodytype = TextEditingController();
  TextEditingController Complexion = TextEditingController();
  TextEditingController physicallyChallengedController =
      TextEditingController();
  TextEditingController physicalstatus = TextEditingController();

  List<Weight> weights = [
    Weight(displayText: '38 Kg'),
    Weight(displayText: '39 Kg'),
    Weight(displayText: '40 Kg'),
    Weight(displayText: '41 Kg'),
    Weight(displayText: '42 Kg'),
    Weight(displayText: '43 Kg'),
    Weight(displayText: '44 Kg'),
    Weight(displayText: '45 Kg'),
    Weight(displayText: '46 Kg'),
    Weight(displayText: '47 Kg'),
    Weight(displayText: '48 Kg'),
    Weight(displayText: '49 Kg'),
    Weight(displayText: '50 Kg'),
    Weight(displayText: '51 Kg'),
    Weight(displayText: '52 Kg'),
    Weight(displayText: '53 Kg'),
    Weight(displayText: '54 Kg'),
    Weight(displayText: '55 Kg'),
    Weight(displayText: '56 Kg'),
    Weight(displayText: '57 Kg'),
    Weight(displayText: '58 Kg'),
    Weight(displayText: '59 Kg'),
    Weight(displayText: '60 Kg'),
    Weight(displayText: '61 Kg'),
    Weight(displayText: '62 Kg'),
    Weight(displayText: '63 Kg'),
    Weight(displayText: '64 Kg'),
    Weight(displayText: '65 Kg'),
    Weight(displayText: '66 Kg'),
    Weight(displayText: '67 Kg'),
    Weight(displayText: '68 Kg'),
    Weight(displayText: '69 Kg'),
    Weight(displayText: '70 Kg'),
    Weight(displayText: '71 Kg'),
    Weight(displayText: '72 Kg'),
    Weight(displayText: '73 Kg'),
    Weight(displayText: '74 Kg'),
    Weight(displayText: '75 Kg'),
    Weight(displayText: '76 Kg'),
    Weight(displayText: '77 Kg'),
    Weight(displayText: '78 Kg'),
    Weight(displayText: '79 Kg'),
    Weight(displayText: '80 Kg'),
    Weight(displayText: '81 Kg'),
    Weight(displayText: '82 Kg'),
    Weight(displayText: '83 Kg'),
    Weight(displayText: '84 Kg'),
    Weight(displayText: '85 Kg'),
    Weight(displayText: '86 Kg'),
    Weight(displayText: '87 Kg'),
    Weight(displayText: '88 Kg'),
    Weight(displayText: '89 Kg'),
    Weight(displayText: '90 Kg'),
    Weight(displayText: '91 Kg'),
    Weight(displayText: '92 Kg'),
    Weight(displayText: '93 Kg'),
    Weight(displayText: '94 Kg'),
    Weight(displayText: '95 Kg'),
    Weight(displayText: '96 Kg'),
    Weight(displayText: '97 Kg'),
    Weight(displayText: '98 Kg'),
    Weight(displayText: '99 Kg'),
    Weight(displayText: '100 Kg'),
    Weight(displayText: '101 Kg'),
    Weight(displayText: '102 Kg'),
    Weight(displayText: '103 Kg'),
    Weight(displayText: '104 Kg'),
    Weight(displayText: '105 Kg'),
    Weight(displayText: '106 Kg'),
    Weight(displayText: '107 Kg'),
    Weight(displayText: '108 Kg'),
    Weight(displayText: '109 Kg'),
    Weight(displayText: '110 Kg'),
    Weight(displayText: '111 Kg'),
    Weight(displayText: '112 Kg'),
    Weight(displayText: '113 Kg'),
    Weight(displayText: '114 Kg'),
    Weight(displayText: '115 Kg'),
    Weight(displayText: '116 Kg'),
    Weight(displayText: '117 Kg'),
    Weight(displayText: '118 Kg'),
    Weight(displayText: '119 Kg'),
    Weight(displayText: '120 Kg'),
    Weight(displayText: '121 Kg'),
    Weight(displayText: '122 Kg'),
    Weight(displayText: '123 Kg'),
    Weight(displayText: '124 Kg'),
    Weight(displayText: '125 Kg'),
    Weight(displayText: '126 Kg'),
    Weight(displayText: '127 Kg'),
    Weight(displayText: '128 Kg'),
    Weight(displayText: '129 Kg'),
    Weight(displayText: '130 Kg'),
    Weight(displayText: '131 Kg'),
    Weight(displayText: '132 Kg'),
    Weight(displayText: '133 Kg'),
    Weight(displayText: '134 Kg'),
    Weight(displayText: '135 Kg'),
    Weight(displayText: '136 Kg'),
    Weight(displayText: '137 Kg'),
    Weight(displayText: '138 Kg'),
    Weight(displayText: '139 Kg'),
    Weight(displayText: '140 Kg'),
    // Add more weights as needed
  ];

  Weight? selectedWeight;
  String? selectedPhysicalStatus;
  String? employed_val;
  String? per_val;
  String? selectedComplexion;
  String? selectedFood;
  List<String> bodyTypeOptions = ["Slim", "Average", "Athletic", "Heavy"];

  List<String> complexionOptions = [
    "Fair",
    "Very Fair",
    "Wheatish",
    "Wheatish Medium",
    "Wheatish Brown",
    "Dark",
  ];

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

  Future<void> thirdregistration() async {
    print(selectedComplexion);//todo send data to backend
    if (_placeofbirthController.text == "") {
      showCustomBar("Please Enter Place of Birth", Colors.red);
    } else if (_timeofbirthController.text == "") {
      showCustomBar("Please Enter Time of Birth", Colors.red);
    } else if (starController.text == "") {
      showCustomBar("Please Select Star", Colors.red);
    } else if (MoonsignController.text == "") {
      showCustomBar("Please Select MoonSign", Colors.red);
    } else if (lagnamController.text == "") {
      showCustomBar("Please Select Lagnam", Colors.red);
    } else if (horscopmatch == "Select a Option") {
      showCustomBar("Please Select Horscope", Colors.red);
    } else if (dosamController.text == "") {
      showCustomBar("Please Select Dosam", Colors.red);
    } else if (_educationController.text == "") {
      showCustomBar("Please Enter Education Details", Colors.red);
    } else if (employedin.text == "") {
      showCustomBar("Please Select Employed In", Colors.red);
    } else if (Occupationdetails.text == "") {
      showCustomBar("Please Enter Occupation Details", Colors.red);
    } else if (percontroller.text == "") {
      showCustomBar("Please Select Income Per", Colors.red);
    } else if (heightController.text == "") {
      showCustomBar("Please Select Height", Colors.red);
    } else if (weightController.text == "") {
      showCustomBar("Please Select Weight", Colors.red);
    } else if (bodytype.text == "") {
      showCustomBar("Please Select Body Type", Colors.red);
    } else if (selectedComplexion == null) {
      showCustomBar("Please Select Complexion", Colors.red);
    } else if (physicalstatus.text == "") {
      showCustomBar("Please Select Physical Status", Colors.red);
    }
    else if (_placeofDistrictController.text == "") {
      showCustomBar("Please Enter Place of District", Colors.red);
    }

    else {
      const apiUrl =
          "http://kaverykannadadevangakulamatrimony.com/appadmin/api/member_temp_register3";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mobile = prefs.getString("mobile");

      final userData = {
        'mobile': mobile,
        'birth': _placeofbirthController.text.toString(),
        'timefor': _timeofbirthController.text.toString(),
        'placeof_district':_placeofDistrictController.text.toString(),
        'star': starController.text.toString(),
        'moonsign': MoonsignController.text.toString(),
        'lagnam': lagnamController.text.toString(),
        'horoscope': horscopmatch,
        'dosam': dosamController.text.toString(),
        'ddosam': selectedsubDosamController.text.toString(),
        'employedin': employedin.text.toString(),
        'education_details': _educationController.text.toString(),
        'income': incomecontroller.text.toString(),
        'per': percontroller.text.toString(),
        'height': heightController.text.toString(),
        'weight': weightController.text.toString(),
        'bodytype': bodytype.text.toString(),
        'complexion': Complexion.text.toString(),
        'physically': physicalstatus.text.toString(),
        'phy_details': physicallyChallengedController.text.toString(),
        'occupation_details': Occupationdetails.text.toString(),
        // 'patham':selectedPatham!.patham.toString(),
        'patham': selectedPatham?.patham?.toString() ?? '',
        'dosamdetails': _dosamdetailsController.text.toString(),
      };

      print(userData);
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: jsonEncode(userData),
          headers: {'Content-Type': 'application/json'},
        );
        log('responce 3 : ${response.body}');
        if (response.statusCode == 200) {
          final bool status = json.decode(response.body)['status'];
          if (status == false) {
            showCustomBar("Error", Colors.red);
          } else {
            showCustomBar("Successfully", Colors.green);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'Occupationdetails', Occupationdetails.text.toString());
            await prefs.setString('horoscope', horscopmatch);
            await prefs.setString('star', starController.text.toString());
            await prefs.setString(
                'moonsign', MoonsignController.text.toString());
            await prefs.setString('lagnam', lagnamController.text.toString());
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const FamilyDetails(),
            ));
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

  // List<String> occupationOptions = [
  //   "--select an option--",
  //   "Business",
  //   "Defence",
  //   "Government",
  //   "Not Working",
  //   "Others",
  //   "Private",
  //   "Self Employed",
  // ];

  List<String> paymentFrequencyOptions = [
    "--select an option--",
    "PerMonth",
    "PerAnnual"
  ];

  String birth = "",
      timefor = "",
      star = "",
      moonsign = "",
      lagnam = "",
      horoscope = "",
      dosam = "",
      ddosam = "",
      employedinval = "",
      education_details = "";
  String income = "",
      per = "",
      height = "",
      weight = "",
      bodytypeval = "",
      complexion = "",
      physically = "",
      phy_details = "",
      placeofdistrict="";




  Future<void> fetchthirdregister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");
    String? Occupationdetails1 = prefs.getString("Occupationdetails");
    String? horoscope12 = prefs.getString("horoscope");

    final url = Uri.parse(
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/get_register3?mobile=${mobile!}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['member_details'];
      log('data : $data');

      setState(() {
        birth = data[0]['birth'];

        if (birth != "") {
          timefor = data[0]['timefor'];
          star = data[0]['star'];
          moonsign = data[0]['moonsign'];
          lagnam = data[0]['lagnam'];
          dosam = data[0]['dosam'];
          placeofdistrict=data[0]['placeof_district'];
          ddosam = data[0]['ddosam'];
          employedinval = data[0]['employedin'];
          education_details = data[0]['education_details'];
          income = data[0]['income'];
          per = data[0]['per'];
          height = data[0]['height'];
          weight = data[0]['weight'];
          bodytypeval = data[0]['bodytype'];
          complexion = data[0]['complexion'];
          physically = data[0]['physically'];
          phy_details = data[0]['phy_details'];

          // Convert the 'patham' string to a Patham object
          // String pathamString = data[0]['patham'] ?? '';
          // selectedPatham = patham.firstWhere(
          //       (p) => p.patham == pathamString,
          //   orElse: () => Patham(id: '', patham: ''), // Default if not found
          // );
          String pathamString = data[0]['patham'] ?? '';
          selectedPatham = patham.firstWhere(
                (p) => p.patham == pathamString,
            orElse: () => Patham(id: '', patham: null), // Optional patham here
          );

          print("selectedPatham  =====>>>> $selectedPatham");

          physicallyChallengedController.text = data[0]['phy_details'];

          _placeofbirthController.text = birth;
          _timeofbirthController.text = timefor;
          _placeofDistrictController.text=placeofdistrict;
          _educationController.text = education_details;
          Occupationdetails.text = Occupationdetails1!;
          incomecontroller.text = income;

          selectedBodyType = bodytypeval;
          bodytype.text = bodytypeval;

          selectedComplexion = complexion;
          Complexion.text = complexion;
          employedin.text = employedinval;
          horscopmatch = horoscope12!;
          selectedDosam = dosam;
          selectedSubDosam = data[0]['ddosam'];
          _dosamdetailsController.text = data[0]['dosamdetails'];
          selectedPhysicalStatus = physically;
          employed_val = employedinval;
          per_val = per;

          dosamController.text = dosam;
          incomecontroller.text = income;
          percontroller.text = per;
          selectedHeight = height;
          heightController.text = height;
          weightController.text = weight;
          physicalstatus.text = physically;

          for (int i = 0; i < weights.length; i++) {
            if (weights[i].displayText == weight) {
              selectedWeight = weights[i];
            }
          }

          for (int i = 0; i < nakshatras.length; i++) {
            if (nakshatras[i].name == star) {
              starController.text = nakshatras[i].value;
              selectedNakshatra = nakshatras[i];
            }
          }

          for (int i = 0; i < moonSigns.length; i++) {
            if (moonSigns[i].name == moonsign) {
              selectedMoonsign = moonSigns[i];
              MoonsignController.text = moonSigns[i].value;
            }

            if (moonSigns[i].name == lagnam) {
              selectedLagnam = moonSigns[i];
              lagnamController.text = moonSigns[i].value;
            }
          }
        }
      });

    } else {
      throw Exception('Failed to load data');
    }
  }



 late  List<JobsModel> jobsList=[];

 Future<void> fetchJobsList() async {
    const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/jobs';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    List<JobsModel>  jobsList1 = (json['msg'] as List<dynamic>).map((country) {
      return JobsModel.fromJson(country);
    }).toList();
   
    setState(() {
      jobsList=jobsList1;
      });

  }



  List<Job> jobList = [];
  
    Future<void> fetchJobs() async {
    final response = await http.get(Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/jobs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['msg'];
      setState(() {
        jobList = jsonResponse.map((job) => Job.fromJson(job)).toList();
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }




 
  @override
  void initState() {
    super.initState();
    fetchthirdregister();
    // getPatham();
    fetchJobsList();
       fetchJobs();

  }


  //   patham   /////////>>>>>>>>>>>>>>>>>>>>>>>>

  List<Patham> patham = [
    Patham(id: '1', patham: '1 ஆம் பாதம்'),
    Patham(id: '2', patham: '2 ஆம் பாதம்'),
    Patham(id: '3', patham: '3 ஆம் பாதம்'),
    Patham(id: '4', patham: '4 ஆம் பாதம்'),
  ];

   Patham? selectedPatham   ;


   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the route observer
    // ModalRoute.of(context)?.observer?.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    // ModalRoute.of(context)?.observer?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Call APIs when returning to this page from another screen
      fetchthirdregister();
      // getPatham();
      fetchJobsList();
    }
  }

  @override
  void didPopNext() {
    // This is called when coming back to this page after popping another page
    fetchthirdregister();
    // getPatham();
    fetchJobsList();
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
                  "Astrological Details",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Place Of Birth *",
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
                controller: _placeofbirthController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Place Of Birth",
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
                "Time Of Birth *",
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
                controller: _timeofbirthController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Time Of Birth",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            //todo: place of district
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Place of District *",
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
                controller: _placeofDistrictController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Place of District ",
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),





            //todo: patham
             const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Patham",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Patham>(
                value: selectedPatham?.patham != null ? selectedPatham : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: patham.map((Patham pathamItem) {
                  return DropdownMenuItem<Patham>(
                    value: pathamItem,
                    child: Text(pathamItem.patham ?? "Unknown"),
                  );
                }).toList(),
                hint: Text("Choose Patham"),
                onChanged: (Patham? newValue) {
                  setState(() {
                    selectedPatham = newValue;
                  });
                },
              ),
            ) ,


            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Star *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                value: selectedNakshatra,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: nakshatras.map((Nakshatra nakshatra) {
                  return DropdownMenuItem<Nakshatra>(
                    value: nakshatra,
                    child: Text(nakshatra.name),
                  );
                }).toList(),
                onChanged: (Nakshatra? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedNakshatra = newValue;
                      starController.text = newValue.value.toString();
                    });
                  }
                  print("Selected nakshatra code: ${newValue?.code}");
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "MoonSign *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                value: selectedMoonsign,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
                      selectedMoonsign = newValue;
                      MoonsignController.text = newValue.value.toString();
                    });
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Lagnam *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                value: selectedLagnam,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
                      lagnamController.text = newValue.value.toString();
                    });
                  }
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Horscope Match *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                value: horscopmatch,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: [
                  DropdownMenuItem(
                    value: "Select a Option",
                    child: Text("Select a Option"),
                  ),
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
                  horscopmatch = value.toString();
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Dosam *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedDosam,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: null,
                    items: dosamOptions
                        .map<DropdownMenuItem<String>>((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDosam = value!;
                        dosamController.text = selectedDosam;

                        // Reset the sub-dosam selection when changing dosam
                        selectedSubDosam = null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Sub Dosam dropdown for "yes" option
                  if (selectedDosam == "Yes")
                    DropdownButtonFormField<String>(
                      value: selectedSubDosam ??
                          subDosamOptions[selectedDosam]!.first,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
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
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    // visible: selectedDosam == "Yes" ? true : false,
                    child: TextFormField(
                      controller: _dosamdetailsController,
                      maxLines: null,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Dosam Details",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  "Education & Occupation Details",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Education Details *",
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
                controller: _educationController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Education Details",
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
                "Employed In *",
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
                value: employed_val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items: jobList.map<DropdownMenuItem<String>>((Job job) {
                  return DropdownMenuItem<String>(
                    value: job.job,
                    child: Text(job.job),
                  );
                }).toList(),
                onChanged: (String? value) {
                  employed_val = value;
                  employedin.text = value.toString();
                  setState(() {
                    
                  });
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Occupation  Details *",
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
                controller: Occupationdetails,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Occupation  Details",
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
                "Income *",
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
                controller: incomecontroller,
                decoration: InputDecoration(
                  hintText: "Income",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Per *",
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
                value: per_val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items: paymentFrequencyOptions.map((String option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? value) {
                  per_val = value;
                  percontroller.text = value.toString();
                  // Handle the selected value
                  print("Selected value: $value");
                },
              ),
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
                  "Physical Attributes",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Height *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Height>(
                value: heights.firstWhere(
                  (height) => height.displayText == selectedHeight,
                  orElse: () => heights[0],
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Weight *",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Weight>(
                value: selectedWeight ?? weights[0],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Body Type *",
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
                value: selectedBodyType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: bodyTypeOptions
                    .map<DropdownMenuItem<String>>((String option) {
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Complexion *",
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
                value: selectedComplexion,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                items: complexionOptions
                    .map<DropdownMenuItem<String>>((String value) {
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Physical Status *",
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
                value: selectedPhysicalStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Physical Challanged Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: selectedPhysicalStatus == "Physically Challenged",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: physicallyChallengedController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            const PersonalDetailRegistration(),
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
                      thirdregistration();
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
      ),
    );
  }
}






// class Patham {
//   String id;
//   String patham;
//
//   Patham({required this.id, required this.patham});
//
//   // factory Patham.fromJson(Map<String, dynamic> json) {
//   //   return Patham(
//   //     id: json['id'] as String,
//   //     patham: json['patham'] as String,
//   //   );
//   // }
//   //
//   // Map<String, dynamic> toJson() {
//   //   return {
//   //     'id': id,
//   //     'patham': patham,
//   //   };
//   // }
//
//
// }

class Patham {
  String id;
  String? patham;

  Patham({required this.id, this.patham});
}

