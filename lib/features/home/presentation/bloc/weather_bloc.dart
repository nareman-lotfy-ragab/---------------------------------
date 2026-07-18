import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/weather_model.dart';
import '../../data/datasources/weather_datasource.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherDatasource weatherDatasource;

  WeatherBloc({required this.weatherDatasource}) : super(const WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    try {
      final weather = await weatherDatasource.getWeatherByCoordinates(
        latitude: event.latitude,
        longitude: event.longitude,
      );
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      print('Weather Bloc Error: $e');
      emit(const WeatherError(message: 'Failed to fetch weather data. Please check your internet connection.'));
    }
  }
}
