class PostCommentModel {
  final String uploaderName;
  final String uploaderGrade;
  final String uploaderUid;
  final String text;
  final String createdAt;
  final int createdAtUnix;
  final String? profileImageUrl;

  PostCommentModel({
    required this.uploaderName,
    required this.uploaderGrade,
    required this.uploaderUid,
    required this.text,
    required this.createdAt,
    required this.createdAtUnix,
    this.profileImageUrl,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      uploaderName: json["uploaderName"],
      uploaderGrade: json["uploaderGrade"],
      uploaderUid: json["uploaderUid"],
      text: json["text"],
      createdAt: json["createdAt"],
      createdAtUnix: json["createdAtUnix"],
      profileImageUrl: json["profileImageUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uploaderName": uploaderName,
      "uploaderGrade": uploaderGrade,
      "uploaderUid": uploaderUid,
      "text": text,
      "createdAt": createdAt,
      "createdAtUnix": createdAtUnix,
      "profileImageUrl": profileImageUrl,
    };
  }
}
