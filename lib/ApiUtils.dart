// api_utils.dart
import 'dart:convert';

import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




import 'Models/CountryModel.dart';
import 'Models/GotraModel.dart';
import 'Models/KulaModel.dart';
import 'Models/citizen model.dart';
import 'Models/interested profile model.dart';
import 'Models/my profile model.dart';
import 'Models/usermodel.dart';
import 'Models/view profile model.dart';
import 'Models/wishlist item models.dart';

class ApiUtils {
  static Future<List<CitizenModel>> fetchCitizenshipList() async {
    const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/citizenship';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    final citizeenList = (json['Citizen'] as List<dynamic>).map((citizenship) {
      return CitizenModel.fromJson(citizenship);
    }).toList();

    return citizeenList;
  }

  static Future<List<CountryModel>> fetchCountryList() async {
    const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/country_of_living';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    final countryList = (json['country'] as List<dynamic>).map((country) {
      return CountryModel.fromJson(country);
    }).toList();

    return countryList;
  }
  static Future<List<StateModel>> fetchStateList() async {
    const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/state';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    final stateList = (json['msg'] as List<dynamic>).map((country) {
      return StateModel.fromJson(country);
    }).toList();

    return stateList;
  }

  static Future<List<DistrictModel>> fetchDistrictList() async {
    try {
      const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/district?state_id=23';
    final uri = Uri.parse(url);
    final response = await http.post(uri);
    final body = response.body;
    final json = jsonDecode(body);
    log("json : ${json['district']}");

    final stateList = (json['district'] as List<dynamic>).map((country) {
      return DistrictModel.fromJson(country);
    }
    ).toList();
    return stateList;
    } catch (e) {
      log("error : $e");
      return [];
    }
  }

  static Future<List<GotraModel>> fetchGotraList() async {
    const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/gotra';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    List<dynamic> golist = json['msg'];
    List<GotraModel> gotraList = [];
    
    gotraList.add(GotraModel(englishName: '--select an option--', tamilName: '', id: '0'));

     for(int i=0;i<golist.length;i++)
       {
         gotraList.add(GotraModel(englishName: golist[i]['english_name'], tamilName: golist[i]['tamil_name'], id: golist[i]['id']));
       }

    return gotraList;
  }

  static Future<List<KulaModel>> fetchKulaList() async {
    const url =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/kula';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    log('kula : ${response.body}');

    List<dynamic> kllist = json['msg'];
    List<KulaModel> kulaList = [];

    kulaList.add(KulaModel(englishName: '--select an option--', tamilName: '', id: '0'));

    for(int i=0;i<kllist.length;i++)
    {
      kulaList.add(KulaModel(englishName: kllist[i]['english_name'], tamilName: kllist[i]['tamil_name'], id: kllist[i]['id']));
    }

    // final kulaList = (json['msg'] as List<dynamic>).map((kula) {
    //   return KulaModel.fromJson(kula);
    // }).toList();

    return kulaList;
  }


}

class ApiService {

  Future<List<Map<String, dynamic>>> getMatchedProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gender = prefs.getString("gender")!;
    final url = Uri.parse(
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/matched_profile?gender=$gender');
    final response = await http.get(url);
    log('data : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['emp'];
      return data.cast<Map<String, dynamic>>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
class UserService {
  Future<List<User>> fetchUserList(String memberId) async {
    final String apiUrl =
        'http://kaverykannadadevangakulamatrimony.com/appadmin/api/interest_request?member_id=$memberId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['Result'];
        List<User> userList = data.map((userData) {
          return User.fromJson(userData);
        }).toList();
        return userList;
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }
}


class ProfileApiService {
  static const String apiUrl =
      'http://kaverykannadadevangakulamatrimony.com/appadmin/api/myprofile';

  Future<Profile> fetchProfileData(String memberId) async {
    final url = Uri.parse('$apiUrl?member_id=$memberId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> profileData = jsonResponse['member_details'];

        if (profileData.isNotEmpty) {
          return Profile.fromJson(profileData[0]);
        } else {
          throw Exception('No profile data available for the provided member ID');
        }
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }
}
class Apiservice {
  final String baseUrl;

  Apiservice(this.baseUrl);

  Future<bool> updateProfile(UserModel user) async {
    const String apiUrl = 'http://kaverykannadadevangakulamatrimony.com/appadmin/api/profile_update';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(user.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Profile updated successfully
        return true;
      } else {
        // Handle error
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle exception
      print('Error updating profile: $e');
      return false;
    }
  }
}

class WishlistApiService {
  final String baseUrl;

  WishlistApiService({required this.baseUrl});

  Future<List<WishlistItem>> getWishlistItems(String memberId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/wishlist?member_id=$memberId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['emp'];
      return data.map((json) => WishlistItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load wishlist items');
    }
  }
}



class ViewProfileApiService {
  final String baseUrl;

  ViewProfileApiService({required this.baseUrl});

  Future<List<ViewProfile>> getViewProfile(String memberId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/view_profile?member_id=$memberId'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data != null && data is Map<String, dynamic> && data.containsKey('emp')) {
          final dynamic empData = data['emp'];

          if (empData != null && empData is List<dynamic>) {
            return empData.map((item) => ViewProfile.fromJson(item)).toList();
          } else {
            throw Exception('Invalid format for emp data in the response');
          }
        } else {
          throw Exception('Invalid format for the entire response');
        }
      } else {
        throw Exception('Failed to load view profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}







