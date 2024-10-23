class QuestionModel {
  final int? id;
  final String? questionText;
  // final String? optionA;
  // final String? optionB;
  // final String? optionC;
  final List<String>? options;
  final String? correctOption;

  QuestionModel({
    this.id,
    this.questionText,
    // this.optionA,
    // this.optionB,
    // this.optionC,
    this.options,
    this.correctOption,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'],
        questionText: json['question_text'],
        // optionA: json['option_a'],
        // optionB: json['option_b'],
        // optionC: json['option_c'],
        options: [
          json['option_a'],
          json['option_b'],
          json['option_c'],
          json['option_d'],
          json['option_e'],
        ],
        correctOption: json['correct_option'],
      );
}
