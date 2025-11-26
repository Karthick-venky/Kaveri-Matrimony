class CountryModel {
  final String countryName;
  final String id;

  CountryModel({required this.countryName,required this.id});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      countryName: json['countryofliving'],
        id : json['id']
    );
  }
}
class StateModel {
  final String stateName;
  final String id;

  StateModel({required this.stateName,required this.id});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      stateName: json['state'],
        id : json['id']
    );
  }
}
class JobsModel {
  final String job;
  final String id;

  JobsModel({required this.job,required this.id});

  factory JobsModel.fromJson(Map<String, dynamic> json) {
    return JobsModel(
      job: json['job'],
        id : json['id']
    );
  }
}
class DistrictModel {
  final String districtName;
  final String id;

  DistrictModel({required this.districtName,required this.id});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      districtName: json['district'],
        id : json['id']
    );
  }
}