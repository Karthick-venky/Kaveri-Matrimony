
class SearchProfileModel {
  final String id;
  final String name;
  final String member_id;
  final String last_id;
  final String email;
  final String pwd;
  final String cpwd;
  final String mobile;
  final String alter_mobile;
  final String gender;
  final String landline_no;
  final String father_name;
  final String father_native;
  final String mother_name;
  final String mother_native;
  final String profile_for;
  final String gotra;
  final String kula;
  final String country_of_living;
  final String dob;
  final String age;
  final String marital_status;
  final String children;
  final String livingstatus;
  final String fathereducation;
  final String foccupation;
  final String meducation;
  final String moccupation;
  final String mothergotra;
  final String motherkula;
  final String bro;
  final String sis;
  final String citizenship;
  final String residentstatus;
  final String state;
  final String city;
  final String lifepartner;
  final String raddress;
  final String pdesc;
  final String birth;
  final String timefor;
  final String star;
  final String moonsign;
  final String lagnam;
  final String horoscope;
  final String dosam;
  final String dosamdetails;
  final String ddosam;
  final String educationcategory;
  final String employedin;
  final String occupation;
  final String education_details;
  final String income;
  final String per;
  final String eaddress;
  final String height;
  final String weight;
  final String bodytype;
  final String bloodgroup;
  final String complexion;
  final String physically;
  final String phy_details;
  final String occupation_details;
  final String food;
  final String drinking;
  final String smoking;
  final String familystatus;
  final String familyvalue;
  final String familytype;
  final String profile_image;
  final String horoscope_image;
  final String aadhar_image;
  final String last_login;
  final String wishlist;
  final String interested_profile;
  final String is_status;
  final String is_deleted;
  final String created_by;
  final String updated_by;
  final String created_at;
  final String updated_at;
  final String approved_status;
  final String approved_date;
  final String pending_reason;
  final String countryofliving;
  final String tamil_name;
  final String english_name;

  SearchProfileModel({
    required this.id,
    required this.name,
    required this.member_id,
    required this.last_id,
    required this.email,
    required this.pwd,
    required this.cpwd,
    required this.mobile,
    required this.alter_mobile,
    required this.gender,
    required this.landline_no,
    required this.father_name,
    required this.father_native,
    required this.mother_name,
    required this.mother_native,
    required this.profile_for,
    required this.gotra,
    required this.kula,
    required this.country_of_living,
    required this.dob,
    required this.age,
    required this.marital_status,
    required this.children,
    required this.livingstatus,
    required this.fathereducation,
    required this.foccupation,
    required this.meducation,
    required this.moccupation,
    required this.mothergotra,
    required this.motherkula,
    required this.bro,
    required this.sis,
    required this.citizenship,
    required this.residentstatus,
    required this.state,
    required this.city,
    required this.lifepartner,
    required this.raddress,
    required this.pdesc,
    required this.birth,
    required this.timefor,
    required this.star,
    required this.moonsign,
    required this.lagnam,
    required this.horoscope,
    required this.dosam,
    required this.dosamdetails,
    required this.ddosam,
    required this.educationcategory,
    required this.employedin,
    required this.occupation,
    required this.education_details,
    required this.income,
    required this.per,
    required this.eaddress,
    required this.height,
    required this.weight,
    required this.bodytype,
    required this.bloodgroup,
    required this.complexion,
    required this.physically,
    required this.phy_details,
    required this.occupation_details,
    required this.food,
    required this.drinking,
    required this.smoking,
    required this.familystatus,
    required this.familyvalue,
    required this.familytype,
    required this.profile_image,
    required this.horoscope_image,
    required this.aadhar_image,
    required this.last_login,
    required this.wishlist,
    required this.interested_profile,
    required this.is_status,
    required this.is_deleted,
    required this.created_by,
    required this.updated_by,
    required this.created_at,
    required this.updated_at,
    required this.approved_status,
    required this.approved_date,
    required this.pending_reason,
    required this.countryofliving,
    required this.tamil_name,
    required this.english_name,
  });

  factory SearchProfileModel.fromJson(Map<String, dynamic> json) {
    return SearchProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      member_id: json['member_id'] ?? '',
      last_id: json['last_id'] ?? '',
      email: json['email'] ?? '',
      pwd: json['pwd'] ?? '',
      cpwd: json['cpwd'] ?? '',
      mobile: json['mobile'] ?? '',
      alter_mobile: json['alter_mobile'] ?? '',
      gender: json['gender'] ?? '',
      landline_no: json['landline_no'] ?? '',
      father_name: json['father_name'] ?? '',
      father_native: json['father_native'] ?? '',
      mother_name: json['mother_name'] ?? '',
      mother_native: json['mother_native'] ?? '',
      profile_for: json['profile_for'] ?? '',
      gotra: json['gotra'] ?? '',
      kula: json['kula'] ?? '',
      country_of_living: json['country_of_living'] ?? '',
      dob: json['dob'] ?? '',
      age: json['age'] ?? '',
      marital_status: json['marital_status'] ?? '',
      children: json['children'] ?? '',
      livingstatus: json['livingstatus'] ?? '',
      fathereducation: json['fathereducation'] ?? '',
      foccupation: json['foccupation'] ?? '',
      meducation: json['meducation'] ?? '',
      moccupation: json['moccupation'] ?? '',
      mothergotra: json['mothergotra'] ?? '',
      motherkula: json['motherkula'] ?? '',
      bro: json['bro'] ?? '',
      sis: json['sis'] ?? '',
      citizenship: json['citizenship'] ?? '',
      residentstatus: json['residentstatus'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      lifepartner: json['lifepartner'] ?? '',
      raddress: json['raddress'] ?? '',
      pdesc: json['pdesc'] ?? '',
      birth: json['birth'] ?? '',
      timefor: json['timefor'] ?? '',
      star: json['star'] ?? '',
      moonsign: json['moonsign'] ?? '',
      lagnam: json['lagnam'] ?? '',
      horoscope: json['horoscope'] ?? '',
      dosam: json['dosam'] ?? '',
      dosamdetails: json['dosamdetails'] ?? '',
      ddosam: json['ddosam'] ?? '',
      educationcategory: json['educationcategory'] ?? '',
      employedin: json['employedin'] ?? '',
      occupation: json['occupation'] ?? '',
      education_details: json['education_details'] ?? '',
      income: json['income'] ?? '',
      per: json['per'] ?? '',
      eaddress: json['eaddress'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      bodytype: json['bodytype'] ?? '',
      bloodgroup: json['bloodgroup'] ?? '',
      complexion: json['complexion'] ?? '',
      physically: json['physically'] ?? '',
      phy_details: json['phy_details'] ?? '',
      occupation_details: json['occupation_details'] ?? '',
      food: json['food'] ?? '',
      drinking: json['drinking'] ?? '',
      smoking: json['smoking'] ?? '',
      familystatus: json['familystatus'] ?? '',
      familyvalue: json['familyvalue'] ?? '',
      familytype: json['familytype'] ?? '',
      profile_image: json['profile_image'] ?? '',
      horoscope_image: json['horoscope_image'] ?? '',
      aadhar_image: json['aadhar_image'] ?? '',
      last_login: json['last_login'] ?? '',
      wishlist: json['wishlist'] ?? '',
      interested_profile: json['interested_profile'] ?? '',
      is_status: json['is_status'] ?? '',
      is_deleted: json['is_deleted'] ?? '',
      created_by: json['created_by'] ?? '',
      updated_by: json['updated_by'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      approved_status: json['approved_status'] ?? '',
      approved_date: json['approved_date'] ?? '',
      pending_reason: json['pending_reason'] ?? '',
      countryofliving: json['countryofliving'] ?? '',
      tamil_name: json['tamil_name'] ?? '',
      english_name: json['english_name'] ?? '',
    );
  }
}
