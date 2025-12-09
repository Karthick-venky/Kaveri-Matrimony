import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'global.dart';
import 'loading.dart';

class ProfileService {
  static Future<Map<String, dynamic>> hideProfile({required String loginMemberId, required String profileId,}) async {
    final url = Uri.parse('${GlobalVariables.baseUrl}appadmin/api/profilehide');

    log("🌐 [POST] URL: $url");
    log("🌐 [POST] Login Member ID: $loginMemberId");
    log("🌐 [POST] Profile ID: $profileId");

    final response = await http.post(url, body: {"member_id": loginMemberId, "profile_id": profileId,},);

    // Print raw response
    log("📩 [RESPONSE STATUS]: ${response.statusCode}");
    log("📩 [RAW RESPONSE BODY]: ${response.body}");
    MyCustomLoading.stop();

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      log("📦 [DECODED RESPONSE]: $decoded");
      return decoded;
    } else {
      log("❌ [ERROR STATUS]: ${response.statusCode}");
      return {
        "status": false,
        "msg": "Something went wrong",
      };
    }
  }
}
