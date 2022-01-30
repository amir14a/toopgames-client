class TypingTestState {
  int? timeLeft;
  int? user1Score;
  int? user2Score;
  int? user1Index;
  int? user2Index;
  List<int>? user1CorrectWords;
  List<int>? user2CorrectWords;
  List<int>? user1WrongWords;
  List<int>? user2WrongWords;
  bool? endGame;

  TypingTestState({
    this.timeLeft,
    this.user1Score,
    this.user2Score,
    this.user1Index,
    this.user2Index,
    this.user1CorrectWords,
    this.user2CorrectWords,
    this.user1WrongWords,
    this.user2WrongWords,
    this.endGame,
  });

  TypingTestState.fromJson(dynamic json) {
    timeLeft = json['time_left'];
    user1Score = json['user1_score'];
    user2Score = json['user2_score'];
    user1Index = json['user1_index'];
    user2Index = json['user2_index'];
    user1CorrectWords = json['user1_correct_words'] != null ? json['user1_correct_words'].cast<int>() : [];
    user2CorrectWords = json['user2_correct_words'] != null ? json['user2_correct_words'].cast<int>() : [];
    user1WrongWords = json['user1_wrong_words'] != null ? json['user1_wrong_words'].cast<int>() : [];
    user2WrongWords = json['user2_wrong_words'] != null ? json['user2_wrong_words'].cast<int>() : [];
    endGame = json['end_game'];
  }
}
