class ProfileModel {
  final String uid;
  final String university;
  final String universityId;
  final String position;
  final String grade;
  final String sex;
  final String name;
  final String email;

  ProfileModel({
    required this.uid,
    required this.university,
    required this.position,
    required this.grade,
    required this.sex,
    required this.name,
    required this.email,
    required this.universityId,
  });

  ProfileModel.empty()
      : uid = "",
        university = "",
        universityId = "",
        grade = "",
        position = "",
        sex = "",
        name = "",
        email = "";

  ProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        university = json["university"],
        universityId = json["universityId"],
        position = json["position"],
        grade = json["grade"],
        sex = json["sex"],
        email = json["email"],
        name = json["name"];

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
    };
  }
}
