import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toopgames_client/model/match_model.dart';
import 'package:toopgames_client/model/stats_model.dart';
import 'package:toopgames_client/util/consts.dart';

import 'model/base_response.dart';
import 'model/user_model.dart';

class ApiRequests {
  static var dio = Dio();
  static const baseUrl = Consts.httpUrl;

  /*
   * Start user apis
   */
  static Future<ListedBaseResponse<UserModel>> getUsers() async {
    var response = await dio.get("$baseUrl/User/GetUsers");
    return ListedBaseResponse.fromMap(response.data, UserModel.fromJson);
  }

  static Future<BaseResponse<UserModel>> login(String emailOrId, String pass) async {
    var response = await dio.post("$baseUrl/User/LoginUser",
        data: {'emailOrId': emailOrId, 'pass': pass},
        options: Options(contentType: Headers.formUrlEncodedContentType));
    return BaseResponse.fromMap(response.data, UserModel.fromJson);
  }

  static Future<ListedBaseResponse<MatchModel?>> getUserMatches(int userId, {int count = 20}) async {
    var response =
        await dio.get("$baseUrl/Match/GetLastUserMatches", queryParameters: {"userId": userId, "count": count});
    return ListedBaseResponse.fromMap(response.data, MatchModel.fromJson);
  }

  static Future<BaseResponse<StatsModel>?> getUserStats(int userId) async {
    var response = await dio.get("$baseUrl/Stats/GetUserStats", queryParameters: {"userId": userId});
    return BaseResponse.fromMap(response.data, StatsModel.fromJson);
  }

  static Future<ListedBaseResponse<StatsModel?>> getTopStats({int count = 30}) async {
    var response = await dio.get("$baseUrl/Stats/GetTopStats", queryParameters: {"count": count});
    return ListedBaseResponse.fromMap(response.data, StatsModel.fromJson);
  }

  static Future<BaseResponse<UserModel>> signUp(
    String email,
    String pass,
    String? name,
    String userId,
    XFile? image,
  ) async {
    Map<String, dynamic> form = {"Email": email, "Password": pass, "Name": name, "UserId": userId};
    if (image != null) {
      form.addAll({"imageFile": MultipartFile.fromBytes(await image.readAsBytes(), filename: image.name)});
    }
    var response = await dio.post("$baseUrl/User/CreateUser",
        data: FormData.fromMap(form), options: Options(contentType: Headers.formUrlEncodedContentType));
    return BaseResponse.fromMap(response.data, UserModel.fromJson);
  }

/*
   * Start Actions apis
   */
}
