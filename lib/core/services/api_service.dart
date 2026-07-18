
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://croprecommendationapi.runasp.net/api';
  static String? _authToken;
  static String? currentUserName;
  static String? currentUserId;

  // Getter for auth token
  static String? get authToken => _authToken;

  // Set auth token
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // Set current user ID
  static void setUserId(String userId) {
    currentUserId = userId;
  }

  // Clear auth token
  static void clearAuthToken() {
    _authToken = null;
    currentUserId = null;
    currentUserName = null;
  }

  // Helper method to build headers
  static Map<String, String> _buildHeaders({bool requiresAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (requiresAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // Register endpoint
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/register'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'email': email,
          'passwordHash': password,
          'fullName': fullName,
        }),
      );

      print("REGISTER STATUS = ${response.statusCode}");
      print("REGISTER RESPONSE = '${response.body}'");

      if (response.statusCode == 200 || response.statusCode == 201) {
       print("REGISTER STATUS = ${response.statusCode}");
        print("REGISTER BODY = ${response.body}");

if (response.body.trim().isEmpty) {
  return {
    'success': true,
    'message': 'Registration successful',
  };
}

final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Registration successful',
        };
      } else {
        String errorMessage;

try {
  final errorData = jsonDecode(response.body);

  if (errorData is Map) {
    errorMessage = errorData['message'] ?? 'Registration failed';
  } else {
    errorMessage = errorData.toString();
  }
} catch (_) {
  errorMessage = response.body;
}

// إزالة علامات التنصيص لو موجودة
errorMessage = errorMessage.replaceAll('"', '');

return {
  'success': false,
  'message': errorMessage,
  'statusCode': response.statusCode,
};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }


  // Login endpoint
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // بناء جسم الطلب بناءً على Swagger
      final requestBody = {
        'email': email,
        'password': password,
        'rememberMe': true,
      };

      print("LOGIN URL = ${Uri.parse('$baseUrl/Auth/login')}");
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: _buildHeaders(),
        body: jsonEncode(requestBody),
      );

      print("LOGIN STATUS = ${response.statusCode}");
      print("LOGIN RESPONSE = ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return {
            'success': false,
            'message': 'Server returned empty response',
          };
        }

        final data = jsonDecode(response.body);
        print(data);
        print(data['user']);
        print(data['user']?['id']);
        print(data['user']?['userId']);
        
        // استخراج البيانات بشكل آمن
        final userData = data['user'];
        if (userData != null) {
          ApiService.setUserId(userData['id'].toString());
          currentUserName = userData['fullName'] ?? userData['userName'] ?? email;
        } else {
          ApiService.setUserId(
            (data['id'] ?? data['userId']).toString(),
          );
          currentUserName = data['fullName'] ?? data['userName'] ?? email;
        }

        if (data['token'] != null) {
          setAuthToken(data['token']);
        }

        print("LOGIN USER ID = ${ApiService.currentUserId}");

        return {
          'success': true,
          'data': data,
          'message': 'Login successful',
        };
      } else {
        String errorMessage = 'Login failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorData['title'] ?? 'Unauthorized';
        } catch (_) {}
        
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
  //change password endpoint

static Future<Map<String, dynamic>> changePassword({
  required int userId,
  required String oldPassword,
  required String newPassword,
}) async {
  try {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/Profile/change-password?userId=$userId&oldPassword=$oldPassword&newPassword=$newPassword',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    print(response.statusCode);
    print(response.body);

    return {
      'success': response.statusCode == 200,
      'message': response.body,
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}

  // Forgot password endpoint
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/forgot-password'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Password reset email sent',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to send reset email',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  // Reset password endpoint
 static Future<Map<String, dynamic>> resetPassword({
  required String token,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/reset-password'),
      headers: _buildHeaders(),
      body: jsonEncode({
        'resetToken': token,
        'newPassword': newPassword,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'success': false,
        'message': response.body,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}

  // Get all crops
  static Future<Map<String, dynamic>> getCrops() async {
    print("resetPassword called");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Crops'),
        headers: _buildHeaders(requiresAuth: true),
      );
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load crops'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get community posts
  // Get community posts with detailed comments
  static Future<Map<String, dynamic>> getCommunityPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Community'),
        headers: _buildHeaders(requiresAuth: true),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> postsData = jsonDecode(response.body);
        
        // يمكننا هنا عمل طلب إضافي لكل منشور لجلب تعليقاته إذا كان السيرفر لا يرجعها في الطلب الرئيسي
        // ولكن حسب الـ Swagger، التعليقات يجب أن تكون جزءاً من الـ Post object
        
        return {'success': true, 'data': postsData};
      } else {
        return {'success': false, 'message': 'Failed to load posts'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create community post
  
  static Future<Map<String, dynamic>> createPost(String content) async {
  try {
    print("Current User Name = $currentUserName");

final request = {
  'id': 0,
  'userName': currentUserName ?? 'User',
  'content': content,
  'imageUrl': '',
  'createdAt': DateTime.now().toIso8601String(),
};

print("REQUEST = ${jsonEncode(request)}");
    final response = await http.post(
      Uri.parse('$baseUrl/Community'),
      headers: _buildHeaders(requiresAuth: true),
      body: jsonEncode({
        'id': 0,
       'userName': currentUserName ?? 'User',
        'content': content,
        'imageUrl': '',
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      return {
        'success': true,
        'data': jsonDecode(response.body),
      };

    } else {

      return {
        'success': false,
        'message': response.body,
      };
    }

  } catch (e) {

    return {
      'success': false,
      'message': e.toString(),
    };
  }
}


  // Like a post and ensure it's registered
  static Future<bool> likePost(int postId) async {
    try {
      // السيرفر يتوقع اسم المستخدم في الـ body حسب الـ Swagger
      final response = await http.post(
        Uri.parse('$baseUrl/Community/$postId/like'),
        headers: _buildHeaders(requiresAuth: true),
        body: jsonEncode(currentUserName ?? 'User'),
      );

      return response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
// Add comment to a post
static Future<bool> addComment({
  required int postId,
  required String comment,
}) async {

  try {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/Community/$postId/comment',
      ),

      headers: _buildHeaders(
        requiresAuth: true,
      ),

      body: jsonEncode({
        'content': comment,
        'userName':
            currentUserName ?? 'User',
      }),
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode == 200 ||
           response.statusCode == 201;

  } catch (e) {

    print(e);

    return false;
  }
}

  // Get profile by ID
  static Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Profile/$userId'),
        headers: _buildHeaders(requiresAuth: true),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load profile'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get recommendation history by user ID
  static Future<Map<String, dynamic>> getRecommendationHistory(
  String userId,
) async {
  try {
    final response = await http.get(
     Uri.parse('$baseUrl/RecommendationHistory/$userId'),
      headers: _buildHeaders(requiresAuth: true),
    );

    print("HISTORY USER ID = $userId");
    print("HISTORY STATUS = ${response.statusCode}");
    print("HISTORY BODY = ${response.body}");

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }

    return {
      'success': false,
      'message': 'Failed to load recommendation history',
      'statusCode': response.statusCode,
    };
  } catch (e) {
    print("HISTORY ERROR = $e");

    return {
      'success': false,
      'message': e.toString(),
    };
  }
}
// //exportRecommendationHistory
// static Future<http.Response> exportRecommendationHistory(
//   String userId,
// ) async {
//   return await http.get(
//     Uri.parse(
//       '$baseUrl/RecommendationHistory/export/$userId',
//     ),
//     headers: _buildHeaders(
//       requiresAuth: true,
//     ),
//   );
// }

  // New method: Get recommendation report by ID
  static Future<Map<String, dynamic>> getRecommendationReport(int recommendationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/RecommendationHistory/report/$recommendationId'),
        headers: _buildHeaders(requiresAuth: true),
      );
      print("REPORT STATUS = ${response.statusCode}");
      print("REPORT BODY = ${response.body}");


      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Failed to load recommendation report: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching recommendation report: ${e.toString()}',
      };
    }
  }

  // Export recommendation report as PDF
static Future<http.Response> exportRecommendationReport(
    int recommendationId) async {
  return await http.get(
    Uri.parse(
      '$baseUrl/RecommendationHistory/export/$recommendationId',
    ),
    headers: _buildHeaders(requiresAuth: true),
  );
}

//getDiseaseHistory
static Future<Map<String, dynamic>> getDiseaseHistory(
  String userId,
) async {
  try {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/PlantDisease/history/$userId',
      ),
      headers: _buildHeaders(
        requiresAuth: true,
      ),
    );

    print("DISEASE STATUS = ${response.statusCode}");
    print("DISEASE BODY = ${response.body}");

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    }

    return {
      'success': false,
      'message': response.body,
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}


static Future<Map<String, dynamic>> deleteRecommendationReport(
    int recommendationId) async {
  try {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/RecommendationHistory/$recommendationId',
      ),
      headers: _buildHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      return {
        'success': true,
      };
    }

    return {
      'success': false,
      'message': response.body,
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}

  // Update profile
  static Future<Map<String, dynamic>> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Profile/$userId'),
        headers: _buildHeaders(requiresAuth: true),
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'Failed to update profile'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Upload profile image
  static Future<Map<String, dynamic>> uploadProfileImage(
  String userId,
  String filePath,
) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/ProfileImage/upload'),
    );

    request.headers.addAll(
      _buildHeaders(requiresAuth: true),
    );

    request.fields['UserId'] = userId;

request.files.add(
  await http.MultipartFile.fromPath(
    'File',
    filePath,
  ),
);
    

    var streamedResponse = await request.send().timeout(
  const Duration(seconds: 30),
);

    var response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': response.body};
    }
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

// delete account endpoint

static Future<Map<String, dynamic>> deleteAccount(int userId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/Profile/$userId'),
      headers: _buildHeaders(requiresAuth: true),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      return {
        'success': true,
      };
    }

    return {
      'success': false,
      'message': response.body,
    };
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}
  // Get notifications
  static Future<Map<String, dynamic>> getNotifications(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Profile/$userId/notifications'),
        headers: _buildHeaders(requiresAuth: true),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load notifications'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }


  

  // Fields Endpoints
  static Future<Map<String, dynamic>> getFields() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final userId =
        ApiService.currentUserId ??
        prefs.getString('user_id');

    if (userId == null) {
      return {
        'success': false,
        'message': 'User not logged in',
      };
    }

    final response = await http.get(
      Uri.parse('$baseUrl/Fields/user/$userId'),
      headers: _buildHeaders(requiresAuth: true),
    );

    print("FIELDS USER ID = $userId");
    print("FIELDS STATUS = ${response.statusCode}");
    print("FIELDS BODY = ${response.body}");

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to load fields',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': e.toString(),
    };
  }
}

  static Future<Map<String, dynamic>> addField(Map<String, dynamic> fieldData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Fields'),
        headers: _buildHeaders(requiresAuth: true),
        body: jsonEncode(fieldData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to add field: ${response.body}'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getFieldDetails(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Fields/$id'),
        headers: _buildHeaders(requiresAuth: true),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load field details'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getFieldLatestAnalysis(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Fields/$id/latest-analysis'),
        headers: _buildHeaders(requiresAuth: true),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load field analysis'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> predictCrop(Map<String, dynamic> cropRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/AI/predict'),
        headers: _buildHeaders(requiresAuth: true),
        body: jsonEncode(cropRequest),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to get prediction: ${response.body}'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}



// chat bot



class RagService {
  static const String baseUrl =
      "https://spinach-slouching-margin.ngrok-free.dev";

  static Future<String> askQuestion({
    required int projectId,
    required String question,
    String? sessionId,
  }) async {
    final response = await http.post(
      Uri.parse(
        "$baseUrl/api/v1/nlp/index/answer/$projectId",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "text": question,
        "limit": 3,
        "current_crop": "wheat",
        "session_id": sessionId,
      }),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["answer"] ?? "No answer found";
    }

    throw Exception("Server Error: ${response.body}");
  }
}

