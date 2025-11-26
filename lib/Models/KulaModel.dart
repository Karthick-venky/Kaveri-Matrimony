// kula_model.dart

class KulaModel {
  final String englishName;
  final String tamilName;
   final String id;

  KulaModel({required this.englishName, required this.tamilName, required this.id});

  factory KulaModel.fromJson(Map<String, dynamic> json) {
    return KulaModel(
        englishName: json['english_name'], tamilName: json['tamil_name'],id: json['id']);
  }
}
