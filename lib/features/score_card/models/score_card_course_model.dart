class ScoreCardCourseModel {
  String courseName;
  String courseNameByHiragana;
  String prefecture; // changed variable name from location to prefecture
  String uploaderName;
  String uploaderUniversity;
  String uploaderUid;
  String? description;
  int createdAt;
  List<int> parValues;

  ScoreCardCourseModel({
    required this.courseName,
    required this.courseNameByHiragana,
    required this.prefecture, // changed variable name from location to prefecture
    required this.uploaderName,
    required this.uploaderUniversity,
    required this.uploaderUid,
    this.description,
    required this.createdAt,
    required this.parValues,
  });

  factory ScoreCardCourseModel.fromJson(Map<String, dynamic> json) {
    return ScoreCardCourseModel(
      courseName: json['courseName'],
      courseNameByHiragana: json['courseNameByHiragana'],
      prefecture: json[
          'prefecture'], // changed variable name from location to prefecture
      uploaderName: json['uploaderName'],
      uploaderUniversity: json['uploaderUniversity'],
      uploaderUid: json['uploaderUid'],
      description: json['description'],
      createdAt: json['createdAt'],
      parValues: List<int>.from(json['parValues']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseName': courseName,
      'courseNameByHiragana': courseNameByHiragana,
      'prefecture':
          prefecture, // changed variable name from location to prefecture
      'uploaderName': uploaderName,
      'uploaderUniversity': uploaderUniversity,
      'uploaderUid': uploaderUid,
      'description': description,
      'createdAt': createdAt,
      'parValues': parValues,
    };
  }
}
