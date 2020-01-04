// To parse this JSON data, do
//
//     final CommentPost = CommentPostFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentPost {
  CommentPost({
    this.comment,
    this.master,
    this.author,
    this.createdAt,
  });

  factory CommentPost.fromRawJson(String str) =>
      CommentPost.fromJson(json.decode(str));

  factory CommentPost.fromJson(Map<String, dynamic> json) => CommentPost(
        comment: json['comment'] == null ? null : json['comment'],
        master: json['master'] == null ? null : json['master'],
        author: json['author'] == null ? null : json['author'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse((json['created_at'] as Timestamp).toString()),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'comment': comment == null ? null : comment,
        'master': master == null ? null : master,
        'author': author,
        'created_at': DateTime.now(),
      };

  String toRawJson() => json.encode(toJson());

  String comment;
  bool master;
  String author;
  DateTime createdAt;
}
