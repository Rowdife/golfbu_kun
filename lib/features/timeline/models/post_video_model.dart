class PostVideoModel {
  final String description;
  final String uploaderName;
  final String fileUrl;
  final String uploaderUid;
  final String uploaderGrade;
  final String position;
  final String university;
  final int comments;
  final int createdAt;

  PostVideoModel({
    required this.description,
    required this.uploaderName,
    required this.fileUrl,
    required this.uploaderUid,
    required this.uploaderGrade,
    required this.position,
    required this.university,
    required this.comments,
    required this.createdAt,
  });

  PostVideoModel.fromJson({
    required Map<String, dynamic> json,
  })  : description = json["description"],
        uploaderName = json["uploaderName"],
        fileUrl = json["fileUrl"],
        uploaderUid = json["uploaderUid"],
        uploaderGrade = json["uploaderGrade"],
        position = json["position"],
        university = json["university"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "uploaderName": uploaderName,
      "fileUrl": fileUrl,
      "uploaderUid": uploaderUid,
      "uploaderGrade": uploaderGrade,
      "position": position,
      "university": university,
      "comments": comments,
      "createdAt": createdAt,
    };
  }
}
