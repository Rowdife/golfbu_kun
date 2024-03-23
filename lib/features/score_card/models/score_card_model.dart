class ScoreCardModel {
  final Map<String, Map<String, dynamic>> scorecard;

  ScoreCardModel({required this.scorecard});

  factory ScoreCardModel.fromJson(Map<String, dynamic> json) {
    return ScoreCardModel(
      scorecard: json['scorecard'],
    );
  }
}
