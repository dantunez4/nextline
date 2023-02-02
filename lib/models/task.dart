// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

class Task {
  Task({
    this.id,
    required this.title,
    required this.isCompleted,
    this.dueDate,
    this.comments,
    this.description,
    this.tags,
  });

  int? id;
  String title;
  int isCompleted;
  String? dueDate;
  String? comments;
  String? description;
  String? tags;

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        isCompleted: json["is_completed"],
        dueDate: json["due_date"],
        comments: json["comments"],
        description: json["description"],
        tags: json["tags"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "is_completed": isCompleted,
        "due_date": dueDate,
        "comments": comments,
        "description": description,
        "tags": tags,
      };

  Task copy() => Task(
        id: id,
        title: title,
        isCompleted: isCompleted,
        dueDate: dueDate,
        comments: comments,
        description: description,
        tags: tags,
      );
}
