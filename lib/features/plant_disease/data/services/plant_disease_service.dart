import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantDiseaseService {
  static const String baseUrl = 'http://croprecommendationapi.runasp.net/api';

  /// Predict plant disease from an image file
  static Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/PlantDisease/predict'),
      );
      final prefs = await SharedPreferences.getInstance();

      print("API USER ID = ${ApiService.currentUserId}");
      print("PREF USER ID = ${prefs.getString('user_id')}");


      // Add headers
      final headers = <String, String>{
        'Accept': 'application/json',
      };

      final token = ApiService.authToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      request.headers.addAll(headers);

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'File',
          imagePath,
        ),
      );


     final userId = ApiService.currentUserId ?? prefs.getString('user_id');

    if (userId == null) {
      return {
        'success': false,
        'message': 'User ID not found',
      };
    }

    ApiService.setUserId(userId);
    request.fields['UserId'] = userId;

    request.fields['UserId'] = userId;

// اختياري لكنه أفضل: حدث ApiService حتى يبقى متاح لباقي الكود
ApiService.setUserId(userId);


      print("DISEASE USER ID = ${request.fields['UserId']}");
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );

      var response = await http.Response.fromStream(streamedResponse);

      print('PlantDisease Response Status: ${response.statusCode}');
      print('PlantDisease Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Disease prediction successful',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to predict disease: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('PlantDisease Error: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
