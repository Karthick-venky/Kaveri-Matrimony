// class Profile {
//   final String id;
//   final String name;
//   final String memberId;
//   final String email;
//   final String pwd;
//   final String cpwd;
//   final String mobile;
//   final String alterMobile;
//   final String gender;
//   final String landlineNo;
//   final String fatherName;
//   final String fatherNative;
//   final String motherName;
//   final String motherNative;
//   final String profileFor;
//   final String gotra;
//   final String kula;
//   final String countryOfLiving;
//   final String dob;
//   final String age;
//   final String maritalStatus;
//   final String children;
//   final String livingStatus;
//   final String fatherEducation;
//   final String fOccupation;
//   final String mEducation;
//   final String mOccupation;
//   // Add other fields based on the response
//
//   Profile({
//     required this.id,
//     required this.name,
//     required this.memberId,
//     required this.email,
//     required this.pwd,
//     required this.cpwd,
//     required this.mobile,
//     required this.alterMobile,
//     required this.gender,
//     required this.landlineNo,
//     required this.fatherName,
//     required this.fatherNative,
//     required this.motherName,
//     required this.motherNative,
//     required this.profileFor,
//     required this.gotra,
//     required this.kula,
//     required this.countryOfLiving,
//     required this.dob,
//     required this.age,
//     required this.maritalStatus,
//     required this.children,
//     required this.livingStatus,
//     required this.fatherEducation,
//     required this.fOccupation,
//     required this.mEducation,
//     required this.mOccupation,
//     // Add other fields here
//   });
//
//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       memberId: json['member_id'] ?? '',
//       email: json['email'] ?? '',
//       pwd: json['pwd'] ?? '',
//       cpwd: json['cpwd'] ?? '',
//       mobile: json['mobile'] ?? '',
//       alterMobile: json['alter_mobile'] ?? '',
//       gender: json['gender'] ?? '',
//       landlineNo: json['landline_no'] ?? '',
//       fatherName: json['father_name'] ?? '',
//       fatherNative: json['father_native'] ?? '',
//       motherName: json['mother_name'] ?? '',
//       motherNative: json['mother_native'] ?? '',
//       profileFor: json['profile_for'] ?? '',
//       gotra: json['gotra'] ?? '',
//       kula: json['kula'] ?? '',
//       countryOfLiving: json['country_of_living'] ?? '',
//       dob: json['dob'] ?? '',
//       age: json['age'] ?? '',
//       maritalStatus: json['marital_status'] ?? '',
//       children: json['children'] ?? '',
//       livingStatus: json['livingstatus'] ?? '',
//       fatherEducation: json['fathereducation'] ?? '',
//       fOccupation: json['foccupation'] ?? '',
//       mEducation: json['meducation'] ?? '',
//       mOccupation: json['moccupation'] ?? '',
//       // Map other fields similarly
//     );
//   }
// }
class Profile {
  final String aadhar_image;

  final String id;
  final String name;
  final String memberId;
  final String email;
  final String pwd;
  final String cpwd;
  final String mobile;
  final String alterMobile;
  final String gender;
  final String landlineNo;
  final String fatherName;
  final String fatherNative;
  final String motherName;
  final String motherNative;
  final String profileFor;
  final String gotra;
  final String kula;
  final String countryOfLiving;
  final String dob;
  final String age;
  final String maritalStatus;
  final String children;
  final String livingStatus;
  final String fatherEducation;
  final String fOccupation;
  final String mEducation;
  final String mOccupation;
  final String motherkula;// Added fields
  final String motherGotra;
  final String phoneNumber;
  final String alternateMobileNo;
  final String brother;
  final String sisters;
  final String citizenship;
  final String mothergotra;
  final String alter_mobile;
  final String landline_no;
  final String bro;
  final String sis;
  final String education_details;
  final String employedin;
  final String income;
  final String per;
  final String phy_details;
  final String occupation_details;
  final String height;
  final String weight;
  final String bodytype;
  final String complexion;
  final String physically;
  final String food;
  final String familystatus;
  final String familyvalue;
  final String familytype;
   final String profile_image;
   final String horoscope_image;
  final String pdesc;
  final String residentstatus;
  final String lifepartner ;
  final String raddress;
  final String state;
  final String city;
  final String  birth;
  final String timefor;

  final String star;

  final String moonsign;

  final String lagnam;

  final String horoscope;
  final String dosam;
  final String ddosam;




  // Add other fields based on the response

  Profile(  {
    required this.aadhar_image,
    required this.phy_details,
    required this.height,
    required this.age,
    required this.moonsign,
    required this.ddosam,
    required this.dosam,
    required this.horoscope,
    required this.lagnam,
    required this.birth,
    required this.timefor,
    required this.star,
    required this.lifepartner,
    required this.pdesc,
    required this.raddress,
    required this.residentstatus,
    required this.state,
    required this.city,
    required this.profile_image,
    required this.horoscope_image,
    required this.familystatus,
    required this.familyvalue,
    required this.familytype,
    required this.weight,
    required this.bodytype,
    required this.complexion,
    required this.physically,
    required this.food,
   required this.education_details,
    required this.motherkula,
    required this.employedin,
    required this.income,
    required this.per, required this.occupation_details,
    required this.mothergotra,
    required this.landline_no,
    required this.bro,
    required this.sis,
    required this.alter_mobile,
    required this.id,
    required this.name,
    required this.memberId,
    required this.email,
    required this.pwd,
    required this.cpwd,
    required this.mobile,
    required this.alterMobile,
    required this.gender,
    required this.landlineNo,
    required this.fatherName,
    required this.fatherNative,
    required this.motherName,
    required this.motherNative,
    required this.profileFor,
    required this.gotra,
    required this.kula,
    required this.countryOfLiving,
    required this.dob,
    required this.maritalStatus,
    required this.children,
    required this.livingStatus,
    required this.fatherEducation,
    required this.fOccupation,
    required this.mEducation,
    required this.mOccupation,
     // Updated constructor
    required this.motherGotra,
    required this.phoneNumber,
    required this.alternateMobileNo,
    required this.brother,
    required this.sisters,
    required this.citizenship,
    // Add other fields here
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      aadhar_image: json['aadhar_image']??'',
      profile_image:json['profile_image']??'',
      pdesc:json['pdesc']??'',
      residentstatus:json['residentstatus']??'',
      raddress:json['raddress']??'',
      state:json['state']??'',
      city:json['city']??'',
      lifepartner:json['lifepartner']??'',
      horoscope_image:json['horoscope_image']??'',
      height:json['height']??'',
      weight:json['weight']??'',
      food:json['food']??'',
      complexion:json['complexion']??'',
      physically:json['physically']??'',
      bodytype:json['bodytype']??'',
      motherkula: json['motherkula']??'',
      mothergotra: json['mothergotra']??'',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      memberId: json['member_id'] ?? '',
      email: json['email'] ?? '',
      pwd: json['pwd'] ?? '',
      cpwd: json['cpwd'] ?? '',
      mobile: json['mobile'] ?? '',
      alterMobile: json['alter_mobile'] ?? '',
      gender: json['gender'] ?? '',
      landlineNo: json['landline_no'] ?? '',
      fatherName: json['father_name'] ?? '',
      fatherNative: json['father_native'] ?? '',
      motherName: json['mother_name'] ?? '',
      motherNative: json['mother_native'] ?? '',
      profileFor: json['profile_for'] ?? '',
      gotra: json['gotra'] ?? '',
      kula: json['kula'] ?? '',
      countryOfLiving: json['country_of_living'] ?? '',
      dob: json['dateofbirth'] ?? '',
      age: json['age'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      children: json['children'] ?? '',
      livingStatus: json['livingstatus'] ?? '',
      fatherEducation: json['fathereducation'] ?? '',
      fOccupation: json['foccupation'] ?? '',
      mEducation: json['meducation'] ?? '',
      mOccupation: json['moccupation'] ?? '',
       // Updated fromJson
      motherGotra: json['mothergotra'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      alternateMobileNo: json['alternate_mobile_no'] ?? '',
      brother: json['bro'] ?? '',
      sisters: json['sis'] ?? '',
      citizenship: json['citizenship'] ?? '', landline_no: json['landline_no'] ?? '', bro: json['bro'] ?? '', sis: json['sis'] ?? '', alter_mobile: json['alter_mobile'] ?? '', employedin:  json['employedin'] ?? '',
      income: json['income'] ?? '', per:json['per'] ?? '',
      occupation_details:json['occupation_details'] ?? '',
      education_details: json['education_details'] ?? '',
      familystatus: json['familystatus'] ?? '', familyvalue: json['familyvalue'] ?? '', familytype: json['familytype'] ?? '', phy_details: json['phy_details'] ??'',
      moonsign:  json['moonsign'] ?? '',
      ddosam:  json['ddosam'] ?? '',
      dosam:  json['dosam'] ?? '',
      horoscope: json['horoscope'] ?? '',
      lagnam: json['lagnam'] ?? '',
      birth: json['birth'] ?? '',
      timefor: json['timefor'] ?? '',
      star: json['star'] ?? '',
      // Map other fields similarly
    );
  }
}
