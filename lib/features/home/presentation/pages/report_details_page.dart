import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/custom_card.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReportDetailsPage extends StatefulWidget {
  final int recommendationId;

  const ReportDetailsPage({super.key, required this.recommendationId});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _reportData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchReportDetails();
  }

  Future<void> _fetchReportDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getRecommendationReport(widget.recommendationId);
      if (mounted) {
        if (result['success']) {
          setState(() {
            _reportData = result['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = result['message'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Report Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchReportDetails,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_reportData == null) {
      return const Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          _buildFieldInformation(),
          _buildSoilParametersSection(),
          const SizedBox(height: 24),
          _buildEnvironmentalSection(),
          const SizedBox(height: 32),
          _buildRecommendationSummary(),
          const SizedBox(height: 24),
          _buildFertilizerPlan(),
          const SizedBox(height: 24),
          _buildDownloadButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: AppColors.primaryGreen, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _reportData!['crop'] ?? 'Unknown Crop',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                ),
                Text(
                  'Date: ${DateTime.parse(_reportData!['generatedDate']) ?? 'N/A'}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilParametersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Soil Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.0,
          children: [
            _buildParameterTile('Nitrogen (N)', '${_reportData!['n']}', Icons.science),
            _buildParameterTile('Phosphorus (P)', '${_reportData!['p']}', Icons.science_outlined),
            _buildParameterTile('Potassium (K)', '${_reportData!['k']}', Icons.biotech),
            _buildParameterTile('pH Level',
                                (_reportData!['ph'] as num).toStringAsFixed(1),
                                Icons.water_drop,
                              ),
                                
          ],
        ),
      ],
    );
  }

  Widget _buildEnvironmentalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Environmental Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        CustomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildConditionRow(
  'Temperature',
  '${(_reportData!['temperature'] as num).toStringAsFixed(1)} °C',
  Icons.thermostat,
),
              const Divider(),
              _buildConditionRow(
  'Humidity',
  '${(_reportData!['humidity'] as num).toStringAsFixed(1)} %',
  Icons.cloud,
),
              const Divider(),
              _buildConditionRow(
  'Rainfall',
  '${(_reportData!['rainfall'] as num).toStringAsFixed(1)} mm',
  Icons.umbrella,
),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Recommended Crop',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            _reportData!['crop'] ?? 'N/A',
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFieldInformation() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Field Information',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      CustomCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildConditionRow(
              'Field Name',
              _reportData!['fieldName'] ?? '-',
              Icons.agriculture,
            ),
            const Divider(),
            _buildConditionRow(
              'Area',
              "${_reportData!['acres']} Acres",
              Icons.square_foot,
            ),
            const Divider(),
            _buildConditionRow(
              'Government',
              _reportData!['government'] ?? '-',
              Icons.location_city,
            ),
            const Divider(),
            _buildConditionRow(
              'City',
              _reportData!['city'] ?? '-',
              Icons.location_on,
            ),
            const Divider(),
            _buildConditionRow(
              'Status',
              _reportData!['fieldStatus'] ?? '-',
              Icons.check_circle,
            ),
            const Divider(),
            _buildConditionRow(
              'Quality',
              _reportData!['fieldQuality'] ?? '-',
              Icons.star,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildFertilizerPlan() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "Fertilizer Plan",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 12),

      CustomCard(
        padding: const EdgeInsets.all(16),

        child:MarkdownBody(
  selectable: true,
  data: _reportData!['fertilizerPlan'] ?? '',
)
      ),
    ],
  );
}


Widget _buildDownloadButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.download),
      label: const Text("Download Report (PDF)"),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () async {
  final response = await ApiService.exportRecommendationReport(
    widget.recommendationId,
  );

  if (!mounted) return;

  if (response.statusCode == 200) {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      '${dir.path}/Report_${widget.recommendationId}.pdf',
    );

    await file.writeAsBytes(response.bodyBytes);

    print("PDF Saved To: ${file.path}");

    await OpenFilex.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Report downloaded successfully"),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Download failed (${response.statusCode})"),
        backgroundColor: Colors.red,
      ),
    );
  }
})
  );
}
}


