import 'package:json_annotation/json_annotation.dart';

part 'episode_dto.g.dart';

@JsonSerializable()
class EpisodeDto {
  final String? id;
  final String title;
  final String description;
  final String host;
  final int? createdAt; // unix timestamp

  const EpisodeDto({
    this.id,
    required this.title,
    required this.description,
    required this.host,
    this.createdAt,
  });

  factory EpisodeDto.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDtoFromJson(json);
      
  Map<String, dynamic> toJson() => _$EpisodeDtoToJson(this);
}
