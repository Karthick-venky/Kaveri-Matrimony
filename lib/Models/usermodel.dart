class UserModel {
  final String id;
  final String name;
  final String gender;
  final String father_name;
  final String mother_name;
  final String profile_for;
  final String gotra;
  final String kula;
  final String country_of_living;
  final String dob;
  final String marital_status;



  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.marital_status,
    required this.dob,
    required this.father_name,
    required this.mother_name,
    required this.gotra,
    required this.kula,
    required this.country_of_living,
    required this.profile_for,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender':gender,
      'father_name':father_name,
      'mother_name':mother_name,
      'profile_for':profile_for,
      'gotra':gotra,
      'kula':kula,
      'coumtry_of_living':country_of_living,
      'dob':dob,
      'marital_status':marital_status,
    };
  }
}
// class UserModel {
//   final int id;
//   final String name;
//   final String gender;
//   final String father_name;
//   final String motherN;
//   final String profileFor;
//   final String gotra;
//   final String kula;
//   final String countryOfLiving;
//   final String dob;
//   final String maritalStatus;
//
//   UserModel({
//     required this.id,
//     required this.name,
//     required this.gender,
//     required this.fatherName,
//     required this.motherName,
//     required this.profileFor,
//     required this.gotra,
//     required this.kula,
//     required this.countryOfLiving,
//     required this.dob,
//     required this.maritalStatus,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'gender': gender,
//       'father_name': fatherName,
//       'mother_name': motherName,
//       'profile_for': profileFor,
//       'gotra': gotra,
//       'kula': kula,
//       'country_of_living': countryOfLiving,
//       'dob': dob,
//       'marital_status': maritalStatus,
//     };
//   }
// }

