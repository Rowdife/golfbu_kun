import 'package:flutter/material.dart';

class CalendarEventModel {
  final String title;
  final String uploaderName;
  final String uploaderId;
  final int createdAt;
  final String? description;
  final String date;
  final String time;
  final Color eventColor;

  CalendarEventModel({
    required this.title,
    required this.uploaderName,
    required this.uploaderId,
    required this.createdAt,
    this.description,
    required this.date,
    required this.time,
    required this.eventColor,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      title: json['title'],
      uploaderName: json['uploaderName'],
      uploaderId: json['uploaderId'],
      createdAt: json['createdAt'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
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
      'date': date,
      'time': time,
      'eventColor': eventColor.value,
    };
  }
}
