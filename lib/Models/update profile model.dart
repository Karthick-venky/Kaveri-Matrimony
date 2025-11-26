class UpdateProfileModel {
  String id;
  String name;
  String gender;
  String fatherName;
  String motherName;
  String profileFor;
  String gotra;
  String kula;
  String countryOfLiving;
  String dob;
  String maritalStatus;

  UpdateProfileModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.fatherName,
    required this.motherName,
    required this.profileFor,
    required this.gotra,
    required this.kula,
    required this.countryOfLiving,
    required this.dob,
    required this.maritalStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'father_name': fatherName,
      'mother_name': motherName,
      'profile_for': profileFor,
      'gotra': gotra,
      'kula': kula,
      'country_of_living': countryOfLiving,
      'dob': dob,
      'marital_status': maritalStatus,
    };
  }
}






// class UpdateProfileModel {
//
//   String employedIn;
//   String educationDetails;
//   String income;
//   String per;
//   String occupationDetails;
//
//   UpdateProfileModel({
//
//     required this.employedIn,
//     required this.educationDetails,
//     required this.income,
//     required this.per,
//     required this.occupationDetails,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//
//       'employedin': employedIn,
//       'education_details': educationDetails,
//       'income': income,
//       'per': per,
//       'occupation_details': occupationDetails,
//     };
//   }
// }

