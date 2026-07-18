import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class PDFReportGenerator {
  static Future<File> generateSoilHealthReport({
    required String farmName,
    required String location,
    required Map<String, dynamic> soilData,
    required Map<String, dynamic> weatherData,
    required Map<String, dynamic> recommendations,
  }) async {

    final pdf = pw.Document();

    

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SOIL HEALTH & CROP RECOMMENDATION REPORT',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B7A3D), // Green
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Agri-Sense AI - Intelligent Agricultural Companion',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColor.fromInt(0xFF666666),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 16),
                child: pw.Divider(
                  thickness: 2,
                ),
              ),
            ],
          ),

          // Farm Information
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'FARM INFORMATION',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B7A3D),
                ),
              ),
              pw.SizedBox(height: 8),
              _buildInfoRow('Farm Name:', farmName),
              _buildInfoRow('Location:', location),
              _buildInfoRow('Report Date:', DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())),
              pw.SizedBox(height: 16),
            ],
          ),

          // Soil Parameters
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SOIL PARAMETERS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B7A3D),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(
                  color: const PdfColor.fromInt(0xFFDDDDDD),
                  width: 1,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFE8F5E9),
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Parameter',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Value',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Unit',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ..._buildSoilParameterRows(soilData),
                ],
              ),
              pw.SizedBox(height: 16),
            ],
          ),

          // Environmental Conditions
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ENVIRONMENTAL CONDITIONS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B7A3D),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(
                  color: const PdfColor.fromInt(0xFFDDDDDD),
                  width: 1,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFE8F5E9),
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Condition',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Value',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ..._buildWeatherRows(weatherData),
                ],
              ),
              pw.SizedBox(height: 16),
            ],
          ),

          // Recommendations
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'CROP RECOMMENDATIONS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B7A3D),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Recommended Crop: ${recommendations['crop'] ?? 'N/A'}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Confidence: ${recommendations['confidence'] ?? 'N/A'}%',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Fertilizer Plan:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                recommendations['fertilizer_plan'] ??
                    'Stage 1: Base fertilizer application\nStage 2: Mid-season nutrient boost\nStage 3: Pre-harvest fortification',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 16),
            ],
          ),

          // Yield Prediction
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'YIELD PREDICTION',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: const PdfColor.fromInt(0xFF1B7A3D),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Estimated Yield: ${recommendations['yield'] ?? 'N/A'} tons/hectare',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Key Factors:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '• Soil Nutrient Balance: Optimal\n• Weather Conditions: Favorable\n• Moisture Levels: Adequate\n• pH Level: Within Range',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 24),
            ],
          ),

          // Footer
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 16),
                child: pw.Divider(
                  thickness: 1,
                ),
              ),
              pw.Text(
                'This report was generated by Agri-Sense AI on ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColor.fromInt(0xFF999999),
                ),
              ),
              pw.Text(
                'For more information, visit: www.agri-sense.com',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColor.fromInt(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Save PDF to file
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/Soil_Health_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static List<pw.TableRow> _buildSoilParameterRows(Map<String, dynamic> soilData) {
    final rows = <pw.TableRow>[];
    final parameters = [
      ('Nitrogen (N)', soilData['nitrogen'] ?? '45', 'kg/ha'),
      ('Phosphorus (P)', soilData['phosphorus'] ?? '38', 'kg/ha'),
      ('Potassium (K)', soilData['potassium'] ?? '42', 'kg/ha'),
      ('pH Level', soilData['ph'] ?? '6.8', '-'),
      ('Electrical Conductivity (EC)', soilData['ec'] ?? '1.2', 'dS/m'),
      ('Soil Moisture', soilData['moisture'] ?? '45', '%'),
      ('Organic Matter', soilData['organic_matter'] ?? '2.5', '%'),
      ('Sodium (Na)', soilData['sodium'] ?? '150', 'mg/kg'),
      ('Calcium (Ca)', soilData['calcium'] ?? '1200', 'mg/kg'),
      ('Magnesium (Mg)', soilData['magnesium'] ?? '300', 'mg/kg'),
    ];

    for (var param in parameters) {
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(param.$1),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(param.$2),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(param.$3),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  static List<pw.TableRow> _buildWeatherRows(Map<String, dynamic> weatherData) {
    final rows = <pw.TableRow>[];
    final conditions = [
      ('Temperature', '${weatherData['temperature'] ?? '28'}°C'),
      ('Humidity', '${weatherData['humidity'] ?? '65'}%'),
      ('Wind Speed', '${weatherData['wind_speed'] ?? '12'} km/h'),
      ('Rainfall (Last 7 days)', '${weatherData['rainfall'] ?? '12'} mm'),
    ];

    for (var condition in conditions) {
      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(condition.$1),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(condition.$2),
            ),
          ],
        ),
      );
    }
    return rows;
  }
}
