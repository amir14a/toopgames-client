class BaseResponse<T> {
  bool success;
  String? message;
  T? data;

  BaseResponse({required this.success, this.message, this.data});

  BaseResponse.fromMap(dynamic map, T Function(dynamic) fromJson, {this.success = false}) {
    success = map['success'];
    message = map['message'];
    if (map['data'] != null) {
      data = fromJson(map['data']);
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    return map;
  }
}

class ListedBaseResponse<T> {
  bool success;
  String? message;
  List<T>? data;

  ListedBaseResponse({required this.success, this.message, this.data});

  ListedBaseResponse.fromMap(dynamic map, T Function(dynamic) fromJson, {this.success = false}) {
    success = map['success'];
    message = map['message'];
    if (map['data'] is List && (map['data'] as List).isNotEmpty) {
      data = [];
      map['data'].forEach((v) {
        data?.add(fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    return map;
  }
}
