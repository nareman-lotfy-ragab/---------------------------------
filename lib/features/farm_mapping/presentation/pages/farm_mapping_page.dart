
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/services/api_service.dart';
import '../../../home/presentation/bloc/weather_bloc.dart';
import '../../../home/data/datasources/weather_datasource.dart';
import '../../../home/data/models/field_model.dart';
import '../widgets/interactive_map_widget.dart';

class FarmMappingPage extends StatefulWidget {
  const FarmMappingPage({super.key});

  @override
  State<FarmMappingPage> createState() => _FarmMappingPageState();
}

class _FarmMappingPageState extends State<FarmMappingPage> {
  late WeatherBloc _weatherBloc;
  String _locationName = 'Fetching location...';
  double _currentLatitude = 30.0444;
  double _currentLongitude = 31.2357;
  bool _isLoadingLocation = true;
  bool _isLoadingFields = true;
  String _locationError = '';
  List<FieldModel> _fields = [];
  FieldModel? _selectedField;

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(weatherDatasource: WeatherDatasource());
    _initializeLiveLocation();
    _fetchFields();
  }

  Future<void> _fetchFields() async {
    setState(() => _isLoadingFields = true);
    try {
      final result = await ApiService.getFields();
      if (result['success']) {
        final List<dynamic> data = result['data'];
        
        // جلب معرف المستخدم الحالي من الـ ApiService
        final String? currentUserIdStr = ApiService.currentUserId;
        final int? currentUserId = currentUserIdStr != null ? int.tryParse(currentUserIdStr) : null;

        setState(() {
          // تحويل البيانات وتصفيتها بحيث تظهر حقول المستخدم الحالي فقط
          _fields = data
              .map((json) => FieldModel.fromJson(json))
              .where((field) {
                // إذا كان لدينا userId للمستخدم الحالي، نقوم بالتصفية بناءً عليه
                if (currentUserId != null) {
                  return field.userId == currentUserId;
                }
                // إذا لم نجد userId (حالة غير متوقعة)، نعرض كل شيء مؤقتاً أو لا شيء حسب الرغبة
                return true; 
              })
              .toList();
          _isLoadingFields = false;
        });
      }
    } catch (e) {
      print('Error fetching fields: $e');
      setState(() => _isLoadingFields = false);
    }
  }

  Future<void> _initializeLiveLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled.';
          _isLoadingLocation = false;
        });
        _fetchWeatherForLocation(_currentLatitude, _currentLongitude);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permission denied.';
            _isLoadingLocation = false;
          });
          _fetchWeatherForLocation(_currentLatitude, _currentLongitude);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _locationName = 'Current Location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
        _isLoadingLocation = false;
      });

      _fetchWeatherForLocation(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _locationError = 'Error getting location: ${e.toString()}';
        _isLoadingLocation = false;
      });
      _fetchWeatherForLocation(_currentLatitude, _currentLongitude);
    }
  }

  Future<void> _fetchWeatherForLocation(double lat, double lon) async {
    _weatherBloc.add(FetchWeatherEvent(latitude: lat, longitude: lon));
  }

  void _onFieldSelected(FieldModel? field) {
    setState(() {
      _selectedField = field;
      if (field != null) {
        _locationName = '${field.fieldName} (${field.city})';
      } else {
        _initializeLiveLocation();
      }
    });
  }

  @override
  void dispose() {
    _weatherBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherBloc>.value(
      value: _weatherBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Farm Mapping', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              onPressed: () {
                _initializeLiveLocation();
                _fetchFields();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildMapHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInteractiveMap(),
                      const SizedBox(height: 32),
                      if (_locationError.isNotEmpty) _buildLocationError(),
                      _buildWeatherCard(),
                      const SizedBox(height: 32),
                      _buildFieldSelector(),
                      const SizedBox(height: 24),
                      _buildFieldList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Active Location', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                if (_isLoadingLocation)
                  const SizedBox(height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Text(_locationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationError() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(_locationError, style: const TextStyle(color: Colors.orange, fontSize: 12)),
    );
  }

  Widget _buildInteractiveMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: InteractiveMapWidget(
          latitude: _currentLatitude,
          longitude: _currentLongitude,
          fieldName: _selectedField?.fieldName ?? 'Current Location',
          onLocationSelected: (point) {
            setState(() {
              _currentLatitude = point.latitude;
              _currentLongitude = point.longitude;
              _locationName = 'Selected: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
            });
            _fetchWeatherForLocation(point.latitude, point.longitude);
          },
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoaded) {
          final weather = state.weather;
          return CustomCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Local Weather', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${weather.temperature.round()}°C', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Humidity: ${weather.humidity}%'),
                        Text('Wind: ${weather.windSpeed} km/h'),
                      ],
                    ),
                  ],
                ),
                Text(weather.description, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildFieldSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Field', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_isLoadingFields)
          const LinearProgressIndicator()
        else
          DropdownButtonFormField<FieldModel>(
            initialValue: _selectedField,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            hint: const Text('Choose a field'),
            items: [
              const DropdownMenuItem<FieldModel>(value: null, child: Text('Current GPS Location')),
              ..._fields.map((f) => DropdownMenuItem(value: f, child: Text(f.fieldName))),
            ],
            onChanged: _onFieldSelected,
          ),
      ],
    );
  }

  Widget _buildFieldList() {
    if (_fields.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No fields found for your account.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text('Your Fields', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._fields.map((field) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.landscape, color: AppColors.primaryGreen),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(field.fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${field.acres} Acres • ${field.city}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
