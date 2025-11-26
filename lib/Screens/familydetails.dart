// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_if_null_operators, prefer_is_empty, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../Screens/welcomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'astrodetails.dart';

class FamilyDetails extends StatefulWidget {

  const FamilyDetails({super.key});

  @override
  State<FamilyDetails> createState() => _FamilyDetailsState();
}

class _FamilyDetailsState extends State<FamilyDetails> {

  TextEditingController familydetails =TextEditingController();
  TextEditingController familyvalue =TextEditingController();
  TextEditingController familytype =TextEditingController();
  TextEditingController food=TextEditingController();
  String? selectedFamilyDetails;
  String? selectedFamilyValue;
  String? selectedFamilyType;
  String? selectedFood;

  String name = "",mobile_val = "",gender="",email="",father_name ="",mother_name="",kula="",gotra="",profile_for="",dob="",country_of_living="",marital_status="",children="",livingstatus="";
  String fathereducation ="",foccupation="",meducation="",moccupation="",father_native="",mother_native="",mothergotra="",motherkula="",bro="",sis="",citizenship="";
  String residentstatus="",state="",city="",lifepartner="",raddress="",pdesc="";
  String birth ="",timefor="",star="",moonsign="",lagnam="",horoscope="",dosam="",ddosam="",employedin="",education_details="";
  String income="",per="",height="",weight="",bodytype="",complexion="",physically="",phy_details="",dosamdetailsval="";
  String alter_mobile = "",landline="";

  List<String> socioEconomicStatusOptions = [
    "MiddleClass",
    "UpperMiddleClass",
    "Rich",
    "Affluent",
  ];

  List<String> familyValuesOptions = [
    "Orthodox",
    "Traditional",
    "Moderate",
    "Liberal",
  ];


  Future<void> finalregistration() async {

    if(imageFileList!.length==0)
    {
      showCustomBar("Please Select Profile Image", Colors.red);
      return;
    }
    if(image=="")
    {
      showCustomBar("Please Select Id Proof", Colors.red);
      return;
    }
    if(image1=="")
    {
      showCustomBar("Please Select Horoscope Image", Colors.red);
      return;
    }


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Occupationdetails = prefs.getString("Occupationdetails");
    String? horoscopeVal = prefs.getString("horoscope");
    String? starVal = prefs.getString("star");
    String? moonsignVal = prefs.getString("moonsign");
    String? lagnamVal = prefs.getString("lagnam");

    await prefs.setBool('registerworking',false);


    // var request = http.MultipartRequest('POST', Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/member_signup'));
    var request = http.MultipartRequest('POST', Uri.parse('http://kaverykannadadevangakulamatrimony.com/appadmin/api/member_temp_register4'));
    request.fields.addAll({
      'name': name,
      'mobile': mobile_val,
      'email': email,
      'gender': gender,
      'father_name': father_name,
      'mother_name': mother_name,
      'profile_for': profile_for,
      'gotra': gotra,
      'kula': kula,
      'country_of_living': country_of_living,
      'dob': dob,
      'marital_status': marital_status,
      'mothergotra': mothergotra,
      'motherkula': motherkula,
      'citizenship': citizenship,
      'residentstatus': residentstatus,
      'state': state,
      'city': city,
      'raddress': raddress,
      'pdesc': pdesc,
      'birth': birth,
      'timefor': timefor,
      'star': starVal.toString(),
      'moonsign': moonsignVal.toString(),
      'lagnam': lagnamVal.toString(),
      'horoscope': horoscopeVal.toString(),
      'dosam': dosam,
      'physically': physically,
      'lifepartner': lifepartner,
      'employedin': employedin,
      'education_details': education_details,
      'income': income,
      'per': per,
      'height': height,
      'weight': weight,
      'bodytype': bodytype,
      'complexion': complexion,
      'father_native': father_native,
      'mother_native': mother_native,
      'bro': bro,
      'sis': sis,
      'meducation': meducation,
      'moccupation': moccupation,
      'foccupation': foccupation,
      'children': children,
      'livingstatus': livingstatus,
      'phy_details': phy_details,
      'occupation_details': Occupationdetails.toString(),
      'food': food.text.toString(),
      'familystatus': familydetails.text.toString(),
      'familyvalue': familyvalue.text.toString(),
      'familytype': familytype.text.toString(),
      'alter_mobile': alter_mobile,
      'landline_no': landline,
      'ddosam': ddosam,
      'fathereducation': fathereducation,
      // 'children':children,
      // 'livingstatus':livingstatus,
      'dosamdetails':dosamdetailsval
    });


    if(imageFileList!.length==1)
    {
      request.files.add(await http.MultipartFile.fromPath('profile_image[]',imageFileList![0].path.toString()));
    }
    if(imageFileList!.length==2)
    {
      request.files.add(await http.MultipartFile.fromPath('profile_image[]',imageFileList![0].path.toString()));
      request.files.add(await http.MultipartFile.fromPath('profile_image[]',imageFileList![1].path.toString()));

    }

    if(image!="")
    {
      request.files.add(await http.MultipartFile.fromPath('aadhar_image',image));
    }
    if(image1!="")
    {
      request.files.add(await http.MultipartFile.fromPath('horoscope_image', image1));
    }

    http.StreamedResponse response = await request.send();
    // ✅ PRINT the request URL and JSON structure before sending
    print('📡 API URL: ${request.url}');
    print('🧾 JSON Payload: ${request.fields}');


    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      showCustomBar("Successfully Registered! Admin Will Contact You Soon! Thank You!..", Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>  WelcomeScreen(),
      ));
    } else {
      print(response.reasonPhrase);
    }

  }

  @override
  void initState() {
    super.initState();
    fetchfirstregister();
    fetchsecondregister();
    fetchthirdregister();
  }

  Future<void> fetchfirstregister() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");
    print(mobile);

    final url = Uri.parse(
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/get_register?mobile='+mobile!);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['member_details'];
      print("first_register"+data.toString());
      name = data[0]['name'];
      mobile_val = data[0]['mobile'];
      gender = data[0]['gender'];
      email = data[0]['email'];
      father_name = data[0]['father_name'];
      mother_name = data[0]['mother_name'];
      kula = data[0]['kula'];
      gotra = data[0]['gotra'];
      profile_for = data[0]['profile_for'];
      dob = data[0]['dob'];
      country_of_living = data[0]['country_of_living'];
      marital_status = data[0]['marital_status'];
      children = data[0]['children']==null?"":data[0]['children'];
      livingstatus = data[0]['livingstatus']==null?"":data[0]['livingstatus'];
      alter_mobile = data[0]['alter_mobile']==null?"":data[0]['alter_mobile'];
      landline = data[0]['landline_no']==null?"":data[0]['landline_no'];
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future<void> fetchsecondregister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");

    if (mobile == null || mobile.isEmpty) {
      // Handle the case where the mobile number is null or empty
      print('Mobile number is not available in SharedPreferences');
      return;
    }

    final url = Uri.parse(
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/get_register2?mobile=$mobile');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['member_details'];
        print("second_register: $data");
        if (data.isNotEmpty) {
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
          citizenship = data[0]['citizenship'];
          residentstatus = data[0]['residentstatus'];
          state = data[0]['state'];
          city = data[0]['city'];
          lifepartner = data[0]['lifepartner'];
          raddress = data[0]['raddress'];
          pdesc = data[0]['pdesc'];
        } else {
          print('No member details found.');
        }
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching second register: $e');
    }
  }

  Future<void> fetchthirdregister() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");

    final url = Uri.parse(
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/get_register3?mobile='+mobile!);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['member_details'];
      birth = data[0]['birth'];
      timefor = data[0]['timefor'];
      star = data[0]['star'];
      moonsign = data[0]['moonsign'];
      lagnam = data[0]['lagnam'];
      horoscope = data[0]['horoscope'];
      dosam = data[0]['dosam'];
      ddosam = data[0]['ddosam'];
      dosamdetailsval = data[0]['dosamdetails']==null?"":data[0]['dosamdetails'];
      employedin = data[0]['employedin'];
      education_details = data[0]['education_details'];
      income = data[0]['income'];
      per = data[0]['per'];
      height = data[0]['height'];
      weight = data[0]['weight'];
      bodytype = data[0]['bodytype'];
      complexion = data[0]['complexion'];
      physically = data[0]['physically'];
      phy_details = data[0]['phy_details'];
    } else {
      throw Exception('Failed to load data');
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

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    imageFileList!.clear();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      if(selectedImages.length>2)
      {
        showCustomBar("You can select only 2 images", Colors.red);
      }
      else
      {
        setState(() {
          imageFileList!.addAll(selectedImages);

        });
      }
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState((){});
  }

  File? _image,_image1,_image2;
  String image = "",image1="",image2="";


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
      image = pickedFile!.path.toString();
    });
  }

  Future<void> _pickImage1(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image1 = pickedFile != null ? File(pickedFile.path) : null;
      image1 = pickedFile!.path.toString();
    });
  }

  Future<void> _pickImage2(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image2 = pickedFile != null ? File(pickedFile.path) : null;
      image2 = pickedFile!.path.toString();
    });
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
                  "Habits",
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
                "Food ",
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
                value: selectedFood,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
                  "Family Profiles",
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
                "Family Status ",
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
                value: selectedFamilyDetails,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items: socioEconomicStatusOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFamilyDetails = value.toString();
                    familydetails.text = selectedFamilyDetails!;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Family Value ",
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
                value: selectedFamilyValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items: familyValuesOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFamilyValue = value.toString();
                    familyvalue.text =selectedFamilyValue! ;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Family Type ",
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
                value: selectedFamilyType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon: null,
                // This will remove the dropdown icon
                items:   const [
                  DropdownMenuItem(
                    value: "Joint",
                    child: Text("Joint"),
                  ),
                  DropdownMenuItem(
                    value: "Nuclear",
                    child: Text("Nuclear"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedFamilyType = value.toString();
                    familytype.text = selectedFamilyType!;
                  });
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
                  "Document",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height:43 ,
                child: ElevatedButton(onPressed: (){
                  //_pickImage2(ImageSource.gallery);
                  selectImages();
                }, style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Color(0xffE03E43)    )), child: Text("Photo*",style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),),
                ),
              ),
            ),
            SizedBox(
              height: imageFileList!.length>0?100:0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageFileList!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                          onTap:(){

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16,top: 10),
                            child: Image.file(File(imageFileList![index].path), fit: BoxFit.cover,width: 70,height: 70,),
                          )
                      ),
                    ],
                  );
                },
              ),
            ),
            // Center(
            //   child: _image2 == null
            //       ? Text('No image selected.')
            //       : Image.file(_image2!,height: 100,),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height:43 ,
                child: ElevatedButton(onPressed: (){
                  _pickImage1(ImageSource.gallery);
                }, style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Color(0xffE03E43)    )), child: Text("Horoscope*",style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),),
                ),
              ),
            ),
            Center(
              child: _image1 == null
                  ? Text('No image selected.')
                  : Image.file(_image1!,height: 100,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height:43 ,
                child: ElevatedButton(onPressed: (){
                  _pickImage(ImageSource.gallery);
                }, style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Color(0xffE03E43)    )), child: Text("Id Proof*",style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),),
                ),
              ),
            ),
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!,height: 100,),
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
                        builder: (context) => const AstroDetails(),
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
                      finalregistration();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf9fd00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: const Size(100, 50),
                    ),
                    child: const Text(
                      "Submit",
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
