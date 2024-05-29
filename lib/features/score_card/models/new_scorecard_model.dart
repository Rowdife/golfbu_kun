class NewScoreCardModel {
  final Map<String, Map<String, dynamic>> scorecard;

  NewScoreCardModel({required this.scorecard});

  factory NewScoreCardModel.fromJson(Map<String, dynamic> json) {
    return NewScoreCardModel(
      scorecard: json['scorecard'],
    );
  }
}
