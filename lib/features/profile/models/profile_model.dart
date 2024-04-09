class ProfileModel {
  final String uid;
  final String university;
  final String universityId;
  final String position;
  final String grade;
  final String sex;
  final String name;
  final String email;
  final int? coursePlayedCount;

  ProfileModel({
    required this.uid,
    required this.university,
    required this.position,
    required this.grade,
    required this.sex,
    required this.name,
    required this.email,
    required this.universityId,
    this.coursePlayedCount,
  });

  ProfileModel.empty()
      : uid = "",
        university = "",
        universityId = "",
        grade = "",
        position = "",
        sex = "",
        name = "",
        email = "",
        coursePlayedCount = 0;

  ProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        university = json["university"],
        universityId = json["universityId"],
        position = json["position"],
        grade = json["grade"],
        sex = json["sex"],
        email = json["email"],
        name = json["name"],
        coursePlayedCount = json["coursePlayedCount"] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "university": university,
      "universityId": universityId,
      "position": position,
      "grade": grade,
      "sex": sex,
      "name": name,
      "email": email,
      "coursePlayedCount": coursePlayedCount ?? 0,
    };
  }
}
