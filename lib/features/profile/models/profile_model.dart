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
