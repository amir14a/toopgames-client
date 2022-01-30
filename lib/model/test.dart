class Test {
  Test({
    this.success,
    this.message,
    this.data,
  });

  Test.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  bool? success;
  dynamic message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.id,
    this.email,
    this.password,
    this.name,
    this.userId,
    this.avatarAddress,
    this.createdOn,
    this.updatedOn,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    userId = json['userId'];
    avatarAddress = json['avatarAddress'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  int? id;
  String? email;
  String? password;
  String? name;
  String? userId;
  String? avatarAddress;
  String? createdOn;
  String? updatedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['password'] = password;
    map['name'] = name;
    map['userId'] = userId;
    map['avatarAddress'] = avatarAddress;
    map['createdOn'] = createdOn;
    map['updatedOn'] = updatedOn;
    return map;
  }
}
