class QuizState {
  int? timeLeft;
  int? user1Score;
  int? user2Score;
  int? index;
  List<int>? user1CorrectQuestions;
  List<int>? user2CorrectQuestions;
  List<int>? user1WrongQuestions;
  List<int>? user2WrongQuestions;
  int? user1Answer;
  int? user2Answer;
  bool? showResult;
  bool? endGame;

  QuizState({
    this.timeLeft,
    this.user1Score,
    this.user2Score,
    this.index,
    this.user1CorrectQuestions,
    this.user2CorrectQuestions,
    this.user1WrongQuestions,
    this.user2WrongQuestions,
    this.user1Answer,
    this.user2Answer,
    this.showResult,
    this.endGame,
  });

  QuizState.fromJson(dynamic json) {
    timeLeft = json['time_left'];
    user1Score = json['user1_score'];
    user2Score = json['user2_score'];
    index = json['index'];
    user1CorrectQuestions =
        json['user1_correct_questions'] != null ? json['user1_correct_questions'].cast<int>() : [];
    user2CorrectQuestions =
        json['user2_correct_questions'] != null ? json['user2_correct_questions'].cast<int>() : [];
    user1WrongQuestions = json['user1_wrong_questions'] != null ? json['user1_wrong_questions'].cast<int>() : [];
    user2WrongQuestions = json['user2_wrong_questions'] != null ? json['user2_wrong_questions'].cast<int>() : [];
    user1Answer = json['user1_answer'];
    user2Answer = json['user2_answer'];
    showResult = json['show_result'];
    endGame = json['end_game'];
  }
}
