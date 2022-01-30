import 'package:toopgames_client/model/user_model.dart';

class StatsModel {
  StatsModel({
    this.id,
    this.games,
    this.wins,
    this.draws,
    this.losses,
    this.winRate,
    this.userId,
    this.user,
    this.rate,
    this.createdOn,
    this.updatedOn,
  });

  StatsModel.fromJson(dynamic json) {
    id = json['id'];
    games = json['games'];
    wins = json['wins'];
    draws = json['draws'];
    losses = json['losses'];
    winRate = json['winRate'].toDouble();
    rate = json['rate'];
    userId = json['userId'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  int? id;
  int? games;
  int? wins;
  int? draws;
  int? losses;
  double? winRate;
  int? userId;
  int? rate;
  UserModel? user;
  String? createdOn;
  String? updatedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['games'] = games;
    map['wins'] = wins;
    map['draws'] = draws;
    map['losses'] = losses;
    map['winRate'] = winRate;
    map['userId'] = userId;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['createdOn'] = createdOn;
    map['updatedOn'] = updatedOn;
    return map;
  }
}
