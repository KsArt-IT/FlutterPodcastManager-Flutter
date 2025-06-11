import 'package:core_data/src/models/episode_dto.dart';
import 'package:core_domain/domain.dart';

extension DomainToDto on Episode {
  EpisodeDto toDto() => EpisodeDto(
    id: id,
    title: title,
    description: description,
    host: host,
    createdAt: createdAt != null 
        ? createdAt!.millisecondsSinceEpoch ~/ 1000 
        : null,
  );
}
