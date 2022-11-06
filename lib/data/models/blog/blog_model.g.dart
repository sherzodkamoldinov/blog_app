// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => BlogModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      userId: json['user_id'] as int? ?? 0,
    );

Map<String, dynamic> _$BlogModelToJson(BlogModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'subtitle': instance.subtitle,
      'image': instance.imageUrl,
      'created_at': instance.createdAt,
      'user_id': instance.userId,
    };
