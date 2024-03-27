import 'package:flutter/material.dart';

class CalendarEventModel {
  final String title;
  final String uploaderName;
  final String uploaderId;
  final int createdAt;
  final String? description;
  final String scheduleStartDate;
  final String scheduleStartTime;
  final String scheduleEndDate;
  final String scheduleEndTime;

  final Color eventColor;

  CalendarEventModel({
    required this.title,
    required this.uploaderName,
    required this.uploaderId,
    required this.createdAt,
    this.description,
    required this.scheduleStartDate,
    required this.scheduleStartTime,
    required this.scheduleEndDate,
    required this.scheduleEndTime,
    required this.eventColor,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      title: json['title'],
      uploaderName: json['uploaderName'],
      uploaderId: json['uploaderId'],
      createdAt: json['createdAt'],
      description: json['description'],
      scheduleStartDate: json['scheduleStartDate'],
      scheduleStartTime: json['scheduleStartTime'],
      scheduleEndDate: json['scheduleEndDate'],
      scheduleEndTime: json['scheduleEndTime'],
      eventColor: Color(json['eventColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'uploaderName': uploaderName,
      'uploaderId': uploaderId,
      'createdAt': createdAt,
      'description': description,
      "scheduleStartDate": scheduleStartDate,
      "scheduleStartTime": scheduleStartTime,
      "scheduleEndDate": scheduleEndDate,
      "scheduleEndTime": scheduleEndTime,
      'eventColor': eventColor.value,
    };
  }
}
