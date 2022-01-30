class MemoryCardState {
  MemoryCardState({
    this.timeLeft,
    this.user1Score,
    this.user2Score,
    this.user1Turn,
    this.visibleCards,
    this.hiddenCards,
    this.endGame,
  });

  MemoryCardState.fromJson(dynamic json) {
    timeLeft = json['time_left'];
    user1Score = json['user1_score'];
    user2Score = json['user2_score'];
    user1Turn = json['user1_turn'];
    visibleCards = json['visible_cards'] != null ? json['visible_cards'].cast<int>() : [];
    hiddenCards = json['hidden_cards'] != null ? json['hidden_cards'].cast<int>() : [];
    endGame = json['end_game'];
  }

  int? timeLeft;
  int? user1Score;
  int? user2Score;
  bool? user1Turn;
  List<int>? visibleCards;
  List<int>? hiddenCards;
  bool? endGame;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time_left'] = timeLeft;
    map['user1_score'] = user1Score;
    map['user2_score'] = user2Score;
    map['user1_turn'] = user1Turn;
    map['visible_cards'] = visibleCards;
    map['hidden_cards'] = hiddenCards;
    map['end_game'] = endGame;
    return map;
  }
}
