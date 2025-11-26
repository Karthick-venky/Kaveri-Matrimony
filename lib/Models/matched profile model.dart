import 'dart:developer';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String occupation;
  final String educationDetails;
  final String marital_status;
  final String height;
  final String age;
  final String moonsign;
  final String gotra;
  final String kula;
  final String lagnam;
  final String state_name;
  final String district_name;
  final String city;
  final String occupationDetails;
  final String member_id;
  final String per;
  final String star;
  final String patham;
  final String profile_image;
  final String dosam;
  final String ddosam;
  bool _isLiked;
  final String kula_tname;
  final String gotra_ename;
  final String kula_ename;
  final String motherkula_ename;
  final String motherkula_tname;
  final String gotra_tname;
  final String countryofliving;
  final String income;
  final String  birth;
   final String dateofbirth;

  ProfileModel(
      {
        required this.profile_image,
        required this.id,
        required this.name,
        required this.email,
        required this.patham,
        required this.mobile,
        required this.gender,
        required this.occupation,
        required this.educationDetails,
        required this.height,
        required this.age,
        required this.moonsign,
        required this.gotra,
        required this.kula,
        required this.motherkula_ename,
        required this.motherkula_tname,
        required this.lagnam,
        required this.state_name,
        required this.district_name,
        required this.city,
        required this.star,
        required this.occupationDetails,
        required this.member_id,
        required this.per,
        required this.kula_tname,
        required this.gotra_ename,
        required this.kula_ename,
        required this.gotra_tname,
        required this.dosam,
        required this.countryofliving,
        required this.marital_status,
        required this.ddosam,
        required this.income,
        required this.birth,
        required this.dateofbirth,
        bool isLiked = false
      }) : _isLiked = isLiked;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    log('profile : $json');
    return ProfileModel(
      id: json['id'] ?? '',
      patham: json['patham'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      occupation: json['occupation_details'] ?? '',
      educationDetails: json['education_details'] ?? '',
      kula_tname : json['kula_tname'] ?? '' ,
      motherkula_ename : json['motherkula_ename'] ?? '' ,
      motherkula_tname : json['motherkula_tname'] ?? '' ,
      gotra_ename : json['gotra_ename'] ?? '',
      height: json['height'] ?? '',
      age: json['age'] ?? '',
      moonsign: json['moonsign'] ?? '',
      gotra: json['gotra'] ?? '',
      kula: json['kula'] ?? '',
      lagnam: json['lagnam'] ?? '',
      state_name: json['state_name'] ?? '',
      district_name: json['district_name'] ?? '',
      income: json['income'] ?? '',
      city: json['city'] ?? '',
      star: json['star'] ?? '',
      member_id: json['member_id'] ?? '',
      per: json['per'] ?? '',
      kula_ename: json['kula_ename'] ?? '',
      gotra_tname: json['gotra_tname'] ?? '',
      occupationDetails: json['occupation_details'] ?? '',
      profile_image:json['profile_image'] ?? '' ,
        countryofliving : json['countryofliving'] ?? '',
        dosam : json['dosam'] ?? '',
        marital_status : json['marital_status'] ?? '',
        ddosam : json['ddosam'] ?? '',
        birth: json['birth'] ?? '',
        dateofbirth: json['dateofbirth'] ?? '',
    );
  }
  bool get isLiked => _isLiked;

  set isLiked(bool value) {
    _isLiked = value;
  }


}