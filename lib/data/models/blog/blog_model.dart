import 'package:json_annotation/json_annotation.dart';

part 'blog_model.g.dart';

//   "id": 1,
//   "title": "Asdffdfs",
//   "description":
//       "asdfasdff dddddddddddff ddddddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
//   "view_count": 0,
//   "type": "",
//   "subtitle": "",
//   "image": "",
//   "created_at": "2022-10-08T22:55:34.080288Z",
//   "user_id": 2

@JsonSerializable()
class BlogModel {
  @JsonKey(defaultValue: 0, name: "id")
  int id;

  @JsonKey(defaultValue: "", name: "title")
  String title;

  @JsonKey(defaultValue: "", name: "description")
  String description;

  @JsonKey(defaultValue: "", name: "type")
  String type;

  @JsonKey(defaultValue: "", name: "subtitle")
  String subtitle;

  @JsonKey(defaultValue: "", name: "image")
  String imageUrl;

  @JsonKey(defaultValue: "", name: "created_at")
  String createdAt;

  @JsonKey(defaultValue: 0, name: "user_id")
  int userId;

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.subtitle,
    required this.imageUrl,
    required this.createdAt,
    required this.userId,
  });

  BlogModel copyWith({
    int? id,
    String? title,
    String? description,
    String? type,
    String? subtitle,
    String? imageUrl,
    String? createdAt,
    int? userId,
  }) =>
      BlogModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        subtitle: subtitle ?? this.subtitle,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        userId: userId ?? this.userId,
      );

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogModelToJson(this);
}
