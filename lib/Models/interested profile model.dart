// models/user.dart
class User {
  final String id;
  final String member_id;
  final String name;
  final String moonsign;
  final String education;
  final String occupation;
  final String kula;
  final String gotra;
  final String age;
  final String lagnam;
  final String state;
  final String city;
  final String height;
  final String profileImageUrl; // URL for profile image
  final String horoscopeImageUrl; // URL for horoscope image

  User({
    required this.id,
    required this.member_id,
    required this.name,
    required this.moonsign,
    required this.education,
    required this.occupation,
    required this.kula,
    required this.gotra,
    required this.age,
    required this.lagnam,
    required this.state,
    required this.city,
    required this.height,
    required this.profileImageUrl,
    required this.horoscopeImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      moonsign: json['moonsign'],
      education: json['education_details'],
      occupation: json['occupation_details'],
      kula: json['kula'],
      gotra: json['gotra'],
      age: json['age'],
      lagnam: json['lagnam'],
      state: json['state'],
      city: json['city'],
      height: json['height'],
      profileImageUrl: json['profile_image'],
      horoscopeImageUrl: json['horoscope_image'], member_id: json['member_id'],
    );
  }
}
