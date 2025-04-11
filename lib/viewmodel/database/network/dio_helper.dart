import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'end_points.dart';

class DioHelper {
  static late Dio dio;
  //Here The Initialize of Dio and Start Connect to API Using baseUrl.
  static init() {
    dio = Dio(
      BaseOptions(
        //Here the URL of API.
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        //Here we Put The Headers Needed in The API.
        // headers: {
        //   'Content-Type': 'application/json',
        //   'lang':'en'
        // },
      ),
    );
    dio.interceptors.add(CurlLoggerDioInterceptor(
      printOnSuccess: true,
   ));
  }

  //This Function to call API and get Some Data based on url(End Points) and Headers needed in API to get the Specific Data.
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    String? token,
    String lang='en',
  }) async {
    try {
      print("token $token");

      dio.options.headers = {
        'Content-Type': 'application/json',
       // 'Token': token,
         'Authorization': token??'' ,
        //'device_token': token ?? '',
        'lang':lang,
      };
      final Response response = await dio.get(
        baseUrl+url,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //This Function that's Used To Post Data to API based on URL(End Points) and Headers.
  // login register task
  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    String? token,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String lang='en',
  }) async {
    try {
      print("dio.options $url");

      dio.options.headers = {
        'Content-Type': 'application/json',
        //'device_token': token ?? '',
        'Authorization': token,
        'lang':lang
      };
      final Response response = await dio.post(
        baseUrl+url,
        queryParameters: queryParameters,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      print("response:$response");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //This Function That's Used to Update Some Date based on URL(End Points) and Send what's you need to Update as Map.
  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    required String? token,
     String lang= 'en',
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
        'lang':lang,
      };
      final Response response = await dio.put(
        baseUrl+ url,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //This Function That's Used to Update Some Date based on URL(End Points) and Send what's you need to Update as Map.
  static Future<Response> patchData({
    required String url,
    required Map<String, dynamic> data,
    required String token,
    bool files = false,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
      //'Content-Type': 'application/json',
    };
    return await dio.patch(
      baseUrl+url,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    required String token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    try {
      final Response response = await dio.delete(
        baseUrl+ url,
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

// class WeatherService
// {
//   final Dio dio;
//   final String baseUrl='https://api.weatherapi.com/v1';
//   final String apiKey='7aef34a60fd74df2b6f03435242909';
//   WeatherService(this.dio);
//   Future<WeatherModel> getCurrentWeather({required String cityName})async
//   {
//     try {
//       Response response =await dio.get('$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=1');
//
//       WeatherModel weatherModel = WeatherModel.fromJson(response.data);
//       return weatherModel;
//
//     }on DioException catch (e) {
//       final String errorMessege= e.response?.data["error"]["message"] ??
//           'oops ther is an error';
//       throw Exception(errorMessege);
//     } catch(e){
//       log(e.toString());
//       throw Exception('oops error,try layer');
//     }
//
//   }
// }
//
