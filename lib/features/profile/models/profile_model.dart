class ProfileModel {
  final String uid;
  final String university;
  final String position;
  final String sex;
  final String name;
  final String email;

  ProfileModel({
    required this.uid,
    required this.university,
    required this.position,
    required this.sex,
    required this.name,
    required this.email,
  });

  ProfileModel.empty()
      : uid = "",
        university = "",
        position = "",
        sex = "",
        name = "",
        email = "";

  ProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        university = json["university"],
        position = json["position"],
        sex = json["sex"],
        email = json["email"],
        name = json["name"];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "university": university,
      "position": position,
      "sex": sex,
      "name": name,
      "email": email,
    };
  }
}
