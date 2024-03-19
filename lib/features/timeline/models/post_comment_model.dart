class PostCommentModel {
  final String uploaderName;
  final String uploaderGrade;
  final String text;
  final String createdAt;
  final int createdAtUnix;
  final String? profileImageUrl;

  PostCommentModel({
    required this.uploaderName,
    required this.uploaderGrade,
    required this.text,
    required this.createdAt,
    required this.createdAtUnix,
    this.profileImageUrl,
  });

  PostCommentModel.fromJson({
    required Map<String, dynamic> json,
  })  : uploaderName = json["uploaderName"],
        uploaderGrade = json["uploaderGrade"],
        text = json["text"],
        createdAt = json["createdAt"],
        createdAtUnix = json["createdAtUnix"],
        profileImageUrl = json["profileImageUrl"];

  Map<String, dynamic> toJson() {
    return {
      "uploaderName": uploaderName,
      "uploaderGrade": uploaderGrade,
      "text": text,
      "createdAt": createdAt,
      "createdAtUnix": createdAtUnix,
      "profileImageUrl": profileImageUrl,
    };
  }
}
