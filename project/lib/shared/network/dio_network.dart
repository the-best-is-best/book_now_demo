import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static late Dio sendMessage;

  DioHelper() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.4/book_now/',
      receiveDataWhenStatusError: false,
    ));

// http://michelleaccademy.epizy.com/two_square_game/
/*
    dio = Dio(BaseOptions(
      baseUrl: 'http://michelleacademy.getenjoyment.net/two_square_game/',
      receiveDataWhenStatusError: true,
    ));
*/
    sendMessage = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/send',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true),
    );
  }

  static Future<Response> postData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio.post(
      url,
      data: query,
      options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true),
    );
  }

  static Future<Response> putData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio.put(
      url,
      data: query,
      options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true),
    );
  }

  static Future<Response> postNotification({required Map data}) async {
    Map<String, dynamic> query = {
      "to": "/topics/all_users",
      "data": {"listen": data}
    };
    return await sendMessage.post(
      "",
      data: query,
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAReLpKTc:APA91bE4F3WBimsoNscUf2ggidogrjPJIt0in5T8ZF-EYh6mt2bgJXg0PEuj9DolSCPV6CT8R6BUS2GydivhX8opY6td_yLCg340ciFWPU327woij32-MBYYnAtA_91q4yKnkYC5GDcM"
      }, validateStatus: (_) => true),
    );
  }
}
