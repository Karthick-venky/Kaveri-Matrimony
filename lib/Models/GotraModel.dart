// gotra_model.dart

class GotraModel {
  final String englishName;
  final String tamilName;
   final String id;

  GotraModel({required this.englishName, required this.tamilName,required this.id});

  factory GotraModel.fromJson(Map<String, dynamic> json) {
    return GotraModel(
      englishName: json['english_name'],
      tamilName: json['tamil_name'],
      id :json['id']
    );
  }
}
