class QuestionModel {
  QuestionModel({
    this.id,
    this.question,
    this.answer1,
    this.answer2,
    this.answer3,
    this.answer4,
    this.correctAnswer,
    this.createdOn,
    this.updatedOn,
  });

  QuestionModel.fromJson(dynamic json) {
    id = json['id'];
    question = json['question'];
    answer1 = json['answer1'];
    answer2 = json['answer2'];
    answer3 = json['answer3'];
    answer4 = json['answer4'];
    correctAnswer = json['correctAnswer'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  static List<QuestionModel> fromList(dynamic map) {
    List<QuestionModel> list = [];
    if (map is List && map.isNotEmpty) {
      list = [];
      for (var v in map) {
        list.add(QuestionModel.fromJson(v));
      }
    }
    return list;
  }

  int? id;
  String? question;
  String? answer1;
  String? answer2;
  String? answer3;
  String? answer4;
  int? correctAnswer;
  String? createdOn;
  String? updatedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question'] = question;
    map['answer1'] = answer1;
    map['answer2'] = answer2;
    map['answer3'] = answer3;
    map['answer4'] = answer4;
    map['correctAnswer'] = correctAnswer;
    map['createdOn'] = createdOn;
    map['updatedOn'] = updatedOn;
    return map;
  }
}
