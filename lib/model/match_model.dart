import 'package:toopgames_client/model/user_model.dart';

class MatchModel {
  MatchModel({
    this.id,
    this.firstUserId,
    this.firstUser,
    this.secondUserId,
    this.secondUser,
    this.firstUserScore,
    this.secondUserScore,
    this.gameName,
    this.createdOn,
  });

  MatchModel.fromJson(dynamic json) {
    id = json['id'];
    firstUserId = json['firstUserId'];
    firstUser = json['firstUser'] != null ? UserModel.fromJson(json['firstUser']) : null;
    secondUserId = json['secondUserId'];
    secondUser = json['secondUser'] != null ? UserModel.fromJson(json['secondUser']) : null;
    firstUserScore = json['firstUserScore'];
    secondUserScore = json['secondUserScore'];
    gameName = json['gameName'];
    createdOn = json['createdOn'];
  }

  int? id;
  int? firstUserId;
  UserModel? firstUser;
  int? secondUserId;
  UserModel? secondUser;
  int? firstUserScore;
  int? secondUserScore;
  String? gameName;
  String? createdOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstUserId'] = firstUserId;
    if (firstUser != null) {
      map['firstUser'] = firstUser?.toJson();
    }
    map['secondUserId'] = secondUserId;
    if (secondUser != null) {
      map['secondUser'] = secondUser?.toJson();
    }
    map['firstUserScore'] = firstUserScore;
    map['secondUserScore'] = secondUserScore;
    map['gameName'] = gameName;
    map['createdOn'] = createdOn;
    return map;
  }
}
