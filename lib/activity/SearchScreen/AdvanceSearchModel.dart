class AdvanceSearchModel {
  List<MemberDetails>? memberDetails;
  bool? status;

  AdvanceSearchModel({this.memberDetails, this.status});

  AdvanceSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['member_details'] != null) {
      memberDetails = <MemberDetails>[];
      json['member_details'].forEach((v) {
        memberDetails!.add(MemberDetails.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (memberDetails != null) {
      data['member_details'] =
          memberDetails!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class MemberDetails {
  String? id;
  String? name;
  String? memberId;
  String? lastId;
  String? email;
  String? pwd;
  String? cpwd;
  String? mobile;
  String? alterMobile;
  String? gender;
  String? landlineNo;
  String? fatherName;
  String? fatherNative;
  String? motherName;
  String? motherNative;
  String? profileFor;
  String? gotra;
  String? kula;
  String? countryOfLiving;
  String? dob;
  String? age;
  String? maritalStatus;
  String? children;
  String? livingstatus;
  String? fathereducation;
  String? foccupation;
  String? meducation;
  String? moccupation;
  String? mothergotra;
  String? motherkula;
  String? bro;
  String? sis;
  String? citizenship;
  String? residentstatus;
  String? state;
  String? district;
  String? city;
  String? lifepartner;
  String? raddress;
  String? pdesc;
  String? prefferedKulla;
  String? birth;
  String? timefor;
  String? placeofDistrict;
  String? star;
  String? patham;
  String? moonsign;
  String? lagnam;
  String? horoscope;
  String? dosam;
  String? dosamdetails;
  String? ddosam;
  String? educationcategory;
  String? employedin;
  Null occupation;
  String? educationDetails;
  String? income;
  String? per;
  String? eaddress;
  String? height;
  String? weight;
  String? bodytype;
  String? bloodgroup;
  String? complexion;
  String? physically;
  String? phyDetails;
  String? occupationDetails;
  String? food;
  String? drinking;
  String? smoking;
  String? familystatus;
  String? familyvalue;
  String? familytype;
  String? profileImage;
  String? horoscopeImage;
  String? aadharImage;
  String? lastLogin;
  String? wishlist;
  String? interestedProfile;
  String? isStatus;
  String? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? approvedStatus;
  String? approvedDate;
  String? pendingReason;
  String? uploadBy;
  String? countryofliving;
  String? gotraTname;
  String? gotraEname;
  String? fatherkulaTname;
  String? fatherkulaEname;
  String? motherkulaTname;
  String? motherkulaEname;
  String? dateofbirth;

  MemberDetails(
      {this.id,
        this.name,
        this.memberId,
        this.lastId,
        this.email,
        this.pwd,
        this.cpwd,
        this.mobile,
        this.alterMobile,
        this.gender,
        this.landlineNo,
        this.fatherName,
        this.fatherNative,
        this.motherName,
        this.motherNative,
        this.profileFor,
        this.gotra,
        this.kula,
        this.countryOfLiving,
        this.dob,
        this.age,
        this.maritalStatus,
        this.children,
        this.livingstatus,
        this.fathereducation,
        this.foccupation,
        this.meducation,
        this.moccupation,
        this.mothergotra,
        this.motherkula,
        this.bro,
        this.sis,
        this.citizenship,
        this.residentstatus,
        this.state,
        this.district,
        this.city,
        this.lifepartner,
        this.raddress,
        this.pdesc,
        this.prefferedKulla,
        this.birth,
        this.timefor,
        this.placeofDistrict,
        this.star,
        this.patham,
        this.moonsign,
        this.lagnam,
        this.horoscope,
        this.dosam,
        this.dosamdetails,
        this.ddosam,
        this.educationcategory,
        this.employedin,
        this.occupation,
        this.educationDetails,
        this.income,
        this.per,
        this.eaddress,
        this.height,
        this.weight,
        this.bodytype,
        this.bloodgroup,
        this.complexion,
        this.physically,
        this.phyDetails,
        this.occupationDetails,
        this.food,
        this.drinking,
        this.smoking,
        this.familystatus,
        this.familyvalue,
        this.familytype,
        this.profileImage,
        this.horoscopeImage,
        this.aadharImage,
        this.lastLogin,
        this.wishlist,
        this.interestedProfile,
        this.isStatus,
        this.isDeleted,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.approvedStatus,
        this.approvedDate,
        this.pendingReason,
        this.uploadBy,
        this.countryofliving,
        this.gotraTname,
        this.gotraEname,
        this.fatherkulaTname,
        this.fatherkulaEname,
        this.motherkulaTname,
        this.motherkulaEname,
        this.dateofbirth});

  MemberDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    memberId = json['member_id'];
    lastId = json['last_id'];
    email = json['email'];
    pwd = json['pwd'];
    cpwd = json['cpwd'];
    mobile = json['mobile'];
    alterMobile = json['alter_mobile'];
    gender = json['gender'];
    landlineNo = json['landline_no'];
    fatherName = json['father_name'];
    fatherNative = json['father_native'];
    motherName = json['mother_name'];
    motherNative = json['mother_native'];
    profileFor = json['profile_for'];
    gotra = json['gotra'];
    kula = json['kula'];
    countryOfLiving = json['country_of_living'];
    dob = json['dob'];
    age = json['age'];
    maritalStatus = json['marital_status'];
    children = json['children'];
    livingstatus = json['livingstatus'];
    fathereducation = json['fathereducation'];
    foccupation = json['foccupation'];
    meducation = json['meducation'];
    moccupation = json['moccupation'];
    mothergotra = json['mothergotra'];
    motherkula = json['motherkula'];
    bro = json['bro'];
    sis = json['sis'];
    citizenship = json['citizenship'];
    residentstatus = json['residentstatus'];
    state = json['state'];
    district = json['district'];
    city = json['city'];
    lifepartner = json['lifepartner'];
    raddress = json['raddress'];
    pdesc = json['pdesc'];
    prefferedKulla = json['preffered_kulla'];
    birth = json['birth'];
    timefor = json['timefor'];
    placeofDistrict = json['placeof_district'];
    star = json['star'];
    patham = json['patham'];
    moonsign = json['moonsign'];
    lagnam = json['lagnam'];
    horoscope = json['horoscope'];
    dosam = json['dosam'];
    dosamdetails = json['dosamdetails'];
    ddosam = json['ddosam'];
    educationcategory = json['educationcategory'];
    employedin = json['employedin'];
    occupation = json['occupation'];
    educationDetails = json['education_details'];
    income = json['income'];
    per = json['per'];
    eaddress = json['eaddress'];
    height = json['height'];
    weight = json['weight'];
    bodytype = json['bodytype'];
    bloodgroup = json['bloodgroup'];
    complexion = json['complexion'];
    physically = json['physically'];
    phyDetails = json['phy_details'];
    occupationDetails = json['occupation_details'];
    food = json['food'];
    drinking = json['drinking'];
    smoking = json['smoking'];
    familystatus = json['familystatus'];
    familyvalue = json['familyvalue'];
    familytype = json['familytype'];
    profileImage = json['profile_image'];
    horoscopeImage = json['horoscope_image'];
    aadharImage = json['aadhar_image'];
    lastLogin = json['last_login'];
    wishlist = json['wishlist'];
    interestedProfile = json['interested_profile'];
    isStatus = json['is_status'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    approvedStatus = json['approved_status'];
    approvedDate = json['approved_date'];
    pendingReason = json['pending_reason'];
    uploadBy = json['upload_by'];
    countryofliving = json['countryofliving'];
    gotraTname = json['gotra_tname'];
    gotraEname = json['gotra_ename'];
    fatherkulaTname = json['fatherkula_tname'];
    fatherkulaEname = json['fatherkula_ename'];
    motherkulaTname = json['motherkula_tname'];
    motherkulaEname = json['motherkula_ename'];
    dateofbirth = json['dateofbirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['member_id'] = memberId;
    data['last_id'] = lastId;
    data['email'] = email;
    data['pwd'] = pwd;
    data['cpwd'] = cpwd;
    data['mobile'] = mobile;
    data['alter_mobile'] = alterMobile;
    data['gender'] = gender;
    data['landline_no'] = landlineNo;
    data['father_name'] = fatherName;
    data['father_native'] = fatherNative;
    data['mother_name'] = motherName;
    data['mother_native'] = motherNative;
    data['profile_for'] = profileFor;
    data['gotra'] = gotra;
    data['kula'] = kula;
    data['country_of_living'] = countryOfLiving;
    data['dob'] = dob;
    data['age'] = age;
    data['marital_status'] = maritalStatus;
    data['children'] = children;
    data['livingstatus'] = livingstatus;
    data['fathereducation'] = fathereducation;
    data['foccupation'] = foccupation;
    data['meducation'] = meducation;
    data['moccupation'] = moccupation;
    data['mothergotra'] = mothergotra;
    data['motherkula'] = motherkula;
    data['bro'] = bro;
    data['sis'] = sis;
    data['citizenship'] = citizenship;
    data['residentstatus'] = residentstatus;
    data['state'] = state;
    data['district'] = district;
    data['city'] = city;
    data['lifepartner'] = lifepartner;
    data['raddress'] = raddress;
    data['pdesc'] = pdesc;
    data['preffered_kulla'] = prefferedKulla;
    data['birth'] = birth;
    data['timefor'] = timefor;
    data['placeof_district'] = placeofDistrict;
    data['star'] = star;
    data['patham'] = patham;
    data['moonsign'] = moonsign;
    data['lagnam'] = lagnam;
    data['horoscope'] = horoscope;
    data['dosam'] = dosam;
    data['dosamdetails'] = dosamdetails;
    data['ddosam'] = ddosam;
    data['educationcategory'] = educationcategory;
    data['employedin'] = employedin;
    data['occupation'] = occupation;
    data['education_details'] = educationDetails;
    data['income'] = income;
    data['per'] = per;
    data['eaddress'] = eaddress;
    data['height'] = height;
    data['weight'] = weight;
    data['bodytype'] = bodytype;
    data['bloodgroup'] = bloodgroup;
    data['complexion'] = complexion;
    data['physically'] = physically;
    data['phy_details'] = phyDetails;
    data['occupation_details'] = occupationDetails;
    data['food'] = food;
    data['drinking'] = drinking;
    data['smoking'] = smoking;
    data['familystatus'] = familystatus;
    data['familyvalue'] = familyvalue;
    data['familytype'] = familytype;
    data['profile_image'] = profileImage;
    data['horoscope_image'] = horoscopeImage;
    data['aadhar_image'] = aadharImage;
    data['last_login'] = lastLogin;
    data['wishlist'] = wishlist;
    data['interested_profile'] = interestedProfile;
    data['is_status'] = isStatus;
    data['is_deleted'] = isDeleted;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['approved_status'] = approvedStatus;
    data['approved_date'] = approvedDate;
    data['pending_reason'] = pendingReason;
    data['upload_by'] = uploadBy;
    data['countryofliving'] = countryofliving;
    data['gotra_tname'] = gotraTname;
    data['gotra_ename'] = gotraEname;
    data['fatherkula_tname'] = fatherkulaTname;
    data['fatherkula_ename'] = fatherkulaEname;
    data['motherkula_tname'] = motherkulaTname;
    data['motherkula_ename'] = motherkulaEname;
    data['dateofbirth'] = dateofbirth;
    return data;
  }
}
