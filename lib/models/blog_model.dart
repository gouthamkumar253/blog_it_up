// To parse this JSON data, do
//
//     final blogPost = blogPostFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  BlogPost({
    this.id,
    this.blogTitle,
    this.blogContent,
    this.likes,
    this.author,
    this.createdAt,
  });

  factory BlogPost.fromRawJson(String str) =>
      BlogPost.fromJson(json.decode(str));

  factory BlogPost.fromJson(Map<String, dynamic> json) => BlogPost(
        id: json['id'] == null ? null : json['id'],
        blogTitle: json['blog_title'] == null ? null : json['blog_title'],
        blogContent: json['blog_content'] == null ? null : json['blog_content'],
        likes: json['likes'] == null ? null : json['likes'],
        author: json['author'] == null ? null : json['author'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse((json['created_at'] as Timestamp).toString()),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id == null ? null : id,
        'blog_title': blogTitle == null ? null : blogTitle,
        'blog_content': blogContent == null ? null : blogContent,
        'likes': likes == null ? null : likes,
        'author': author,
        'created_at': DateTime.now(),
      };

  String toRawJson() => json.encode(toJson());

  int id;
  String blogTitle;
  String blogContent;
  String author;
  int likes;
  DateTime createdAt;
}
