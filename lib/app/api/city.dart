// lấy dữ liệu các thành phố từ API


//  CityApi
//  @param results danh sách các thành phố.
//  @param admin1 tên Quận
//  @param name tên thành phố
//  @param latitude vĩ độ
//  @param longitude kinh độ
class CityApi {
  CityApi({
    required this.results,
  });

  List<Result> results;

  factory CityApi.fromJson(Map<String, dynamic> json) => CityApi(
        results: json['results'] == null
            ? List<Result>.empty()
            : List<Result>.from(json['results'].map((x) => Result.fromJson(x))),
      );
}

// Result
// @param admin1 tên Quận
// @param name tên thành phố
// @param latitude vĩ độ
// @param longitude kinh độ
class Result {
  Result({
    required this.admin1,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  String admin1;
  String name;
  double latitude;
  double longitude;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        admin1: json['admin1'] ?? '',
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
