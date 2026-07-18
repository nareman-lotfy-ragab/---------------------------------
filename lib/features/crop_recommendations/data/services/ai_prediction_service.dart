import '../../../../core/services/api_service.dart';

class AIPredictionService {
  /// Predict crop recommendation based on soil and environmental data
  static Future<Map<String, dynamic>> predictCrop({
    int? fieldId,
    required double n,
    required double p,
    required double k,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    final userId = int.tryParse(ApiService.currentUserId ?? '0') ?? 0;
    
    final cropRequest = {
      'fieldId': fieldId,
      'userId': userId,
      'n': n,
      'p': p,
      'k': k,
      'temperature': temperature,
      'humidity': humidity,
      'ph': ph,
      'rainfall': rainfall,
    };

    return await ApiService.predictCrop(cropRequest);
  }
}
