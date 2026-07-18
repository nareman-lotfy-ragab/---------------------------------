import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/presentation/pages/reports_page.dart';

class CropRecommendationsPage extends StatelessWidget {
  final Map<String, dynamic>? predictionData;

  const CropRecommendationsPage({
    super.key,
    this.predictionData,
  });

  String _getCropName() {
    if (predictionData == null) return 'Unknown Crop';
    if (predictionData!.containsKey('prediction')) return predictionData!['prediction'] ?? 'Unknown Crop';
    if (predictionData!.containsKey('crop')) return predictionData!['crop'] ?? 'Unknown Crop';
    if (predictionData!.containsKey('recommendedCrop')) return predictionData!['recommendedCrop'] ?? 'Unknown Crop';
    return 'Unknown Crop';
  }

  String _getConfidence() {
    if (predictionData == null) return '85%';
    if (predictionData!.containsKey('confidence')) {
      final confidence = predictionData!['confidence'];
      if (confidence is int) return '$confidence%';
      if (confidence is double) return '${confidence.toStringAsFixed(0)}%';
      return confidence.toString();
    }
    return '85%';
  }

  @override
  Widget build(BuildContext context) {
    final cropName = _getCropName();
    final confidence = _getConfidence();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: const Text('Crop Recommendation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report download started...'), backgroundColor: Colors.green),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _buildRecommendationCard(cropName, confidence),
                  const SizedBox(height: 32),
                  const Text('Input Soil Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  CustomCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildDataRow('Nitrogen (N)', predictionData?['n']?.toString() ?? 'N/A'),
                        _buildDataRow('Phosphorus (P)', predictionData?['p']?.toString() ?? 'N/A'),
                        _buildDataRow('Potassium (K)', predictionData?['k']?.toString() ?? 'N/A'),
                        _buildDataRow('pH Level', predictionData?['ph']?.toString() ?? 'N/A'),
                        _buildDataRow('Temperature', '${predictionData?['temperature']?.toString() ?? 'N/A'}°C'),
                        _buildDataRow('Humidity', '${predictionData?['humidity']?.toString() ?? 'N/A'}%'),
                        _buildDataRow('Rainfall', '${predictionData?['rainfall']?.toString() ?? 'N/A'}mm'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CustomButton(
                    text: 'View Full History',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsPage())),
                  ),
                  const SizedBox(height: 16),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(String cropName, String confidence) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended Crop', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.agriculture, color: AppColors.primaryGreen, size: 40),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cropName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                    Text('Confidence: $confidence', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        ],
      ),
    );
  }
}
