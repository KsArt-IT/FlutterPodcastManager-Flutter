// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeDto _$EpisodeDtoFromJson(Map<String, dynamic> json) => EpisodeDto(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  host: json['host'] as String,
  createdAt: (json['createdAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$EpisodeDtoToJson(EpisodeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'host': instance.host,
      'createdAt': instance.createdAt,
    };
