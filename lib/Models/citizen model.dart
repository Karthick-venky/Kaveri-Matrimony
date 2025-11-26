class CitizenModel {
  final String citizenName;
  final String id;

  CitizenModel({required this.citizenName,required this.id});

  factory CitizenModel.fromJson(Map<String, dynamic> json) {
    return CitizenModel(
      citizenName: json['citizenship'],
      id: json['id']
    );
  }
}
