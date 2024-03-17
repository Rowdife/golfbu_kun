class PostVideoModel {
  final String description;
  final String uploaderName;
  final String fileUrl;
  final String uploaderUid;
  final String thumbnailUrl;
  final int comments;
  final int createdAt;

  PostVideoModel({
    required this.description,
    required this.uploaderName,
    required this.fileUrl,
    required this.uploaderUid,
    required this.thumbnailUrl,
    required this.comments,
    required this.createdAt,
  });

  PostVideoModel.fromJson(Map<String, dynamic> json)
      : description = json["description"],
        uploaderName = json["uploaderName"],
        fileUrl = json["fileUrl"],
        uploaderUid = json["uploaderUid"],
        thumbnailUrl = json["thumbnailUrl"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "uploaderName": uploaderName,
      "fileUrl": fileUrl,
      "uploaderUid": uploaderUid,
      "thumbnailUrl": thumbnailUrl,
      "comments": comments,
      "createdAt": createdAt,
    };
  }
}
