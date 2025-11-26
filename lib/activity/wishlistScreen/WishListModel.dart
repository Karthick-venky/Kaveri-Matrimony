class WishListModel {
  List<Emp>? emp;
  bool? status;

  WishListModel({this.emp, this.status});

  WishListModel.fromJson(Map<String, dynamic> json) {
    if (json['emp'] != null) {
      emp = <Emp>[];
      json['emp'].forEach((v) {
        emp!.add(Emp.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (emp != null) {
      data['emp'] = emp!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Emp {
  String? id;
  String? name;
  String? age;
  String? maritalStatus;
  String? memberId;
  String? dob;
  String? income;
  String? height;
  String? educationDetails;
  String? city;
  String? district;
  String? moonsign;
  String? state;
  String? star;
  String? lagnam;
  String? occupationDetails;
  String? dosam;
  String? ddosam;
  String? countryofliving;
  String? profileImage;
  String? gotraTname;
  String? gotraEname;
  String? kulaTname;
  String? kulaEname;
  String? motherkulaTname;
  String? motherkulaEname;

  Emp(
      {this.id,
        this.name,
        this.age,
        this.maritalStatus,
        this.memberId,
        this.dob,
        this.income,
        this.height,
        this.educationDetails,
        this.city,
        this.district,
        this.moonsign,
        this.state,
        this.star,
        this.lagnam,
        this.occupationDetails,
        this.dosam,
        this.ddosam,
        this.countryofliving,
        this.profileImage,
        this.gotraTname,
        this.gotraEname,
        this.kulaTname,
        this.kulaEname,
        this.motherkulaTname,
        this.motherkulaEname});

  Emp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    maritalStatus = json['marital_status'];
    memberId = json['member_id'];
    dob = json['dob'];
    income = json['income'];
    height = json['height'];
    educationDetails = json['education_details'];
    city = json['city'];
    district = json['district'];
    moonsign = json['moonsign'];
    state = json['state'];
    star = json['star'];
    lagnam = json['lagnam'];
    occupationDetails = json['occupation_details'];
    dosam = json['dosam'];
    ddosam = json['ddosam'];
    countryofliving = json['countryofliving'];
    profileImage = json['profile_image'];
    gotraTname = json['gotra_tname'];
    gotraEname = json['gotra_ename'];
    kulaTname = json['kula_tname'];
    kulaEname = json['kula_ename'];
    motherkulaTname = json['motherkula_tname'];
    motherkulaEname = json['motherkula_ename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['marital_status'] = maritalStatus;
    data['member_id'] = memberId;
    data['dob'] = dob;
    data['income'] = income;
    data['height'] = height;
    data['education_details'] = educationDetails;
    data['city'] = city;
    data['district'] = district;
    data['moonsign'] = moonsign;
    data['state'] = state;
    data['star'] = star;
    data['lagnam'] = lagnam;
    data['occupation_details'] = occupationDetails;
    data['dosam'] = dosam;
    data['ddosam'] = ddosam;
    data['countryofliving'] = countryofliving;
    data['profile_image'] = profileImage;
    data['gotra_tname'] = gotraTname;
    data['gotra_ename'] = gotraEname;
    data['kula_tname'] = kulaTname;
    data['kula_ename'] = kulaEname;
    data['motherkula_tname'] = motherkulaTname;
    data['motherkula_ename'] = motherkulaEname;
    return data;
  }
}
