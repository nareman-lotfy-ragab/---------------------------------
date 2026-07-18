import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/services/api_service.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'report_details_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isLoading = true;
  List<dynamic> _reports = [];
  List<dynamic> _filteredReports = [];
  String? _error;
  String _searchQuery = '';
  String? _selectedCrop;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = ApiService.currentUserId ?? '0';
      final result = await ApiService.getRecommendationHistory(userId);
      
      if (!mounted) return;
      if (result['success']) {
        setState(() {
          var data = result['data'];
          if (data is List) {
            _reports = data;
          } else if (data is Map &&
              data.containsKey('reports') &&
              data['reports'] is List) {
            _reports = data['reports'];
          } else {
            _reports = [];
          }
          _filterReports();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterReports() {
    setState(() {
      _filteredReports = _reports.where((report) {
        final cropName = (report['crop'] ?? '').toString().toLowerCase();
        final matchesSearch = cropName.contains(_searchQuery.toLowerCase());
        final matchesCrop = _selectedCrop == null || report['crop'] == _selectedCrop;
        return matchesSearch && matchesCrop;
      }).toList();
    });
  }

  void _updateSearch(String query) {
    _searchQuery = query;
    _filterReports();
  }

  void _updateCropFilter(String? crop) {
    _selectedCrop = crop;
    _filterReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Smart Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchReports,
        color: AppColors.primaryGreen,
        child: _buildBody(),
      ),
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
              onPressed: _fetchReports,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final List<String> crops = _reports.map((e) => e['crop'].toString()).toSet().toList();

    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: _updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search crops...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedCrop,
                hint: const Text('All Crops'),
                items: [
                  const DropdownMenuItem<String>(value: null, child: Text('All')),
                  ...crops.map((crop) => DropdownMenuItem<String>(value: crop, child: Text(crop))),
                ],
                onChanged: _updateCropFilter,
              ),
            ],
          ),
        ),
        // Reports List
        Expanded(
          child: _filteredReports.isEmpty
              ? Center(
                  child: Text(
                    _reports.isEmpty ? 'No reports found.' : 'No reports match your search.',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = _filteredReports[index];
                    final dateStr = report['date'] ?? '';
                    String formattedDate = 'Unknown Date';
                    if (dateStr.isNotEmpty) {
                      try {
                        final date = DateTime.parse(dateStr);
                        formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);
                      } catch (_) {}
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetailsPage(recommendationId: report['id']),
                            ),
                          );
                        },
                        child: CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          report['crop'] ?? 'Unknown Crop',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Text(
          formattedDate,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ),

    IconButton(
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Report"),
            content: const Text(
              "Are you sure you want to delete this report?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await _deleteReport(report['id']);
        }
      },
    ),
  ],
),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMetric('N', report['n']?.toString() ?? '0'),
                                _buildMetric('P', report['p']?.toString() ?? '0'),
                                _buildMetric('K', report['k']?.toString() ?? '0'),
                                _buildMetric('pH', report['ph']?.toString() ?? '0'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _deleteReport(int recommendationId) async {
  final result = await ApiService.deleteRecommendationReport(
    recommendationId,
  );

  if (!mounted) return;

  if (result['success']) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Report deleted successfully"),
        backgroundColor: Colors.green,
      ),
    );

    _fetchReports();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}
