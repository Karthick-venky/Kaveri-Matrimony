class WishlistItem {
  final String member_id;
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String occupation;
  final String educationDetails;
  final String profile_image;
  final String height;
  final String age;

  final String moonsign;
  final String gotra;
  final String kula;
  final String lagnam;
  final String state;
  final String city;
  final String occupationDetails;

  WishlistItem({
    required this.id,
    required this.member_id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.occupation,
    required this.educationDetails,
    required this.profile_image,
    required this.height,
    required this.age,
    required this.moonsign,
    required this.gotra,
    required this.kula,
    required this.lagnam,
    required this.state,
    required this.city,
    required this.occupationDetails,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      occupation: json['occupation'] ?? 'Not Available',
      educationDetails: json['education_details'] ?? 'Not Available',
      profile_image: json['profile_image'] ?? '',
      height: json['height'] ?? '',
      age: json['age'] ?? '',
      moonsign: json['moonsign'] ?? '',
      gotra: json['gotra'] ?? '',
      kula: json['kula'] ?? '',
      lagnam: json['lagnam'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      occupationDetails: json['occupation_details'] ?? 'Not Available',
      member_id: json['member_id'] ?? '',
    );
  }
}
// class WishlistItem {
//   final String id;
//   final String name;
//   final String member_id;
//   // Add other properties from your API response
//
//   WishlistItem({
//     required this.id,
//     required this.name,
//     required this.member_id,
//     // Add other properties from your API response
//   });
//
//   factory WishlistItem.fromJson(Map<String, dynamic> json) {
//     return WishlistItem(
//       id: json['id'],
//       name: json['name'],
//       member_id: json['member_id'],
//       // Map other properties from your API response
//     );
//   }
// }

