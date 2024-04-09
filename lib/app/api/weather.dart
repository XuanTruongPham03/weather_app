// file name: weather.dart
// có tác dụng tạo ra các class immutable từ class WeatherData
// và các class con của nó là Hourly và Daily

import 'package:freezed_annotation/freezed_annotation.dart';

//ignore_for_file: invalid_annotation_target

part 'weather.freezed.dart'; 
part 'weather.g.dart';

// WeatherDataApi class
// Lớp này sẽ chứa dữ liệu thời tiết từ API
// và trả về dữ liệu thời tiết dưới dạng Hourly và Daily
// Nếu có lỗi, nó sẽ in ra lỗi đó
@freezed
class WeatherDataApi with _$WeatherDataApi {
  const factory WeatherDataApi({
    required Hourly hourly,
    required Daily daily,
    required String timezone,
  }) = _WeatherDataApi;

  factory WeatherDataApi.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataApiFromJson(json);
}

// Hourly: lớp này sẽ chứa dữ liệu thời tiết theo giờ
// @param time thời gian
// @param weatherCode mã thời tiết
// @param temperature2M nhiệt độ
// @param apparentTemperature cảm giác như
// @param precipitation lượng mưa
// @param rain mưa
// @param relativeHumidity2M độ ẩm tương đối
// @param surfacePressure áp suất bề mặt
// @param visibility tầm nhìn
// @param evapotranspiration hơi nước
// @param windSpeed10M tốc độ gió
// @param windDirection10M hướng gió
// @param windGusts10M gió giật
// @param cloudCover mây
// @param uvIndex chỉ số UV
// @param dewpoint2M điểm sương
// @param precipitationProbability xác suất mưa
// @param shortwaveRadiation bức xạ ngắn
@freezed
class Hourly with _$Hourly {
  const factory Hourly({
    List<String>? time,
    @JsonKey(name: 'weathercode') List<int>? weatherCode,
    @JsonKey(name: 'temperature_2m') List<double>? temperature2M,
    @JsonKey(name: 'apparent_temperature') List<double?>? apparentTemperature,
    List<double?>? precipitation,
    List<double?>? rain,
    @JsonKey(name: 'relativehumidity_2m') List<int?>? relativeHumidity2M,
    @JsonKey(name: 'surface_pressure') List<double?>? surfacePressure,
    List<double?>? visibility,
    List<double?>? evapotranspiration,
    @JsonKey(name: 'windspeed_10m') List<double?>? windSpeed10M,
    @JsonKey(name: 'winddirection_10m') List<int?>? windDirection10M,
    @JsonKey(name: 'windgusts_10m') List<double?>? windGusts10M,
    @JsonKey(name: 'cloudcover') List<int?>? cloudCover,
    @JsonKey(name: 'uv_index') List<double?>? uvIndex,
    @JsonKey(name: 'dewpoint_2m') List<double?>? dewpoint2M,
    @JsonKey(name: 'precipitation_probability')
    List<int?>? precipitationProbability,
    @JsonKey(name: 'shortwave_radiation') List<double?>? shortwaveRadiation,
  }) = _Hourly;

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);
}

List<DateTime> _dateTimeFromJson(List<dynamic>? json) =>
    json?.map((x) => DateTime.parse(x)).toList() ?? [];

// Daily: lớp này sẽ chứa dữ liệu thời tiết theo ngày
// @param time thời gian
// @param weatherCode mã thời tiết
// @param temperature2MMax nhiệt độ tối đa
// @param temperature2MMin nhiệt độ tối thiểu
// @param apparentTemperatureMax cảm giác như tối đa
// @param apparentTemperatureMin cảm giác như tối thiểu
// @param precipitationSum lượng mưa
// @param sunrise bình minh
// @param sunset hoàng hôn
// @param precipitationProbabilityMax xác suất mưa tối đa
// @param windSpeed10MMax tốc độ gió tối đa
// @param windGusts10MMax gió giật tối đa
// @param uvIndexMax chỉ số UV tối đa
// @param rainSum lượng mưa
// @param windDirection10MDominant hướng gió
@freezed
class Daily with _$Daily {
  const factory Daily({
    @JsonKey(fromJson: _dateTimeFromJson) List<DateTime>? time,
    @JsonKey(name: 'weathercode') List<int?>? weatherCode,
    @JsonKey(name: 'temperature_2m_max') List<double?>? temperature2MMax,
    @JsonKey(name: 'temperature_2m_min') List<double?>? temperature2MMin,
    @JsonKey(name: 'apparent_temperature_max')
    List<double?>? apparentTemperatureMax,
    @JsonKey(name: 'apparent_temperature_min')
    List<double?>? apparentTemperatureMin,
    @JsonKey(name: 'precipitation_sum') List<double?>? precipitationSum,
    List<String>? sunrise,
    List<String>? sunset,
    @JsonKey(name: 'precipitation_probability_max')
    List<int?>? precipitationProbabilityMax,
    @JsonKey(name: 'windspeed_10m_max') List<double?>? windSpeed10MMax,
    @JsonKey(name: 'windgusts_10m_max') List<double?>? windGusts10MMax,
    @JsonKey(name: 'uv_index_max') List<double?>? uvIndexMax,
    @JsonKey(name: 'rain_sum') List<double?>? rainSum,
    @JsonKey(name: 'winddirection_10m_dominant')
    List<int?>? windDirection10MDominant,
  }) = _Daily;

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
}
