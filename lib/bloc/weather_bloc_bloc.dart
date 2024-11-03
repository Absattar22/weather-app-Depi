import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final WeatherFactory weatherFactory =
      WeatherFactory("89e20d7566ac9e7a4352c461cff5e3a4");

  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        final weather = await weatherFactory.currentWeatherByLocation(
            event.position.latitude, event.position.longitude);
        emit(WeatherBlocSucess(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });

    // Add handling for FetchWeatherByCity event
    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        final weather =
            await weatherFactory.currentWeatherByCityName(event.cityName);
        emit(WeatherBlocSucess(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}
