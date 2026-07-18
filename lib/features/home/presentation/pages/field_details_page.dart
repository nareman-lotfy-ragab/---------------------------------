import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/services/api_service.dart';
import '../../data/models/field_model.dart';
import 'soil_data_form_page.dart';

class FieldDetailsPage extends StatefulWidget {
  final FieldModel field;
  const FieldDetailsPage({super.key, required this.field});

  @override
  State<FieldDetailsPage> createState() => _FieldDetailsPageState();
}

class _FieldDetailsPageState extends State<FieldDetailsPage> {
  bool _isLoadingAnalysis = false;
  Map<String, dynamic>? _latestAnalysis;

  @override
  void initState() {
    super.initState();
    _fetchLatestAnalysis();
  }

  Future<void> _fetchLatestAnalysis() async {
    setState(() => _isLoadingAnalysis = true);
    try {
      final result = await ApiService.getFieldLatestAnalysis(widget.field.id);
      if (result['success']) {
        setState(() => _latestAnalysis = result['data']);
      }
    } catch (e) {
      print('Error fetching analysis: $e');
    } finally {
      setState(() => _isLoadingAnalysis = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.field.fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 32),
            _buildAnalysisSection(),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Analyze Field (Soil Input)',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SoilDataFormPage(fieldId: widget.field.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(Icons.straighten, 'Area', '${widget.field.acres} Acres'),
          const Divider(),
          _buildInfoRow(Icons.location_city, 'Location', '${widget.field.city}, ${widget.field.government}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (_isLoadingAnalysis)
          const Center(child: CircularProgressIndicator())
        else if (_latestAnalysis == null)
          const CustomCard(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No analysis found for this field.')),
          )
        else
          CustomCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildAnalysisRow('Nitrogen (N)', '${_latestAnalysis!['n']}'),
                _buildAnalysisRow('Phosphorus (P)', '${_latestAnalysis!['p']}'),
                _buildAnalysisRow('Potassium (K)', '${_latestAnalysis!['k']}'),
                _buildAnalysisRow('pH Level', '${_latestAnalysis!['ph']}'),
                _buildAnalysisRow('Temperature', '${_latestAnalysis!['temperature']}°C'),
                _buildAnalysisRow('Humidity', '${_latestAnalysis!['humidity']}%'),
                _buildAnalysisRow('Rainfall', '${_latestAnalysis!['rainfall']}mm'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        ],
      ),
    );
  }
}
