import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../crop_recommendations/data/services/ai_prediction_service.dart';
import '../../../crop_recommendations/presentation/pages/crop_recommendations_page.dart';
import '../bloc/weather_bloc.dart';

class SoilDataFormPage extends StatefulWidget {
  final int? fieldId;
  const SoilDataFormPage({super.key, this.fieldId});

  @override
  State<SoilDataFormPage> createState() => _SoilDataFormPageState();
}

class _SoilDataFormPageState extends State<SoilDataFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _location = 'Detecting location...';
  bool _isLoading = false;

  // Soil Parameters
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _phController = TextEditingController();

  // Environmental Conditions
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detectLocation();
    _loadWeatherData();
    // Default values if empty
    _nitrogenController.text = '45';
    _phosphorusController.text = '38';
    _potassiumController.text = '42';
    _phController.text = '6.8';
    _rainfallController.text = '12';
  }

  Future<void> _detectLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _location = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _location = 'Location not available';
      });
    }
  }

  Future<void> _loadWeatherData() async {
    try {
      final weatherState = context.read<WeatherBloc>().state;
      if (weatherState is WeatherLoaded) {
        if (!mounted) return;
        setState(() {
          _temperatureController.text = weatherState.weather.temperature.toStringAsFixed(1);
          _humidityController.text = weatherState.weather.humidity.toString();
        });
      }
    } catch (e) {
      if (!mounted) return;
      _temperatureController.text = '25.0';
      _humidityController.text = '60';
    }
  }

  @override
  void dispose() {
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _phController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _rainfallController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await AIPredictionService.predictCrop(
          fieldId: widget.fieldId,
          n: double.parse(_nitrogenController.text),
          p: double.parse(_phosphorusController.text),
          k: double.parse(_potassiumController.text),
          temperature: double.parse(_temperatureController.text),
          humidity: double.parse(_humidityController.text),
          ph: double.parse(_phController.text),
          rainfall: double.parse(_rainfallController.text),
        );

        if (!mounted) return;

        if (result['success']) {
          // Navigate to Recommendation page which will lead to Report
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropRecommendationsPage(
                predictionData: result['data'],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to get crop recommendation'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Soil Data Input', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationCard(),
                const SizedBox(height: 24),
                const Text('Soil Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInput('Nitrogen (N)', _nitrogenController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInput('Phosphorus (P)', _phosphorusController)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInput('Potassium (K)', _potassiumController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInput('pH Level', _phController)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Environmental Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildInput('Temp (°C)', _temperatureController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInput('Humidity (%)', _humidityController)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInput('Rainfall (mm)', _rainfallController),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: 'Get Recommendation', onPressed: _submitForm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Field Location', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text(_location, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }
}
