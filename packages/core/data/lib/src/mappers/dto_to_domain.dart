import 'package:core_data/src/models/episode_dto.dart';
import 'package:core_domain/domain.dart';
import 'package:uuid/uuid.dart';

extension DtoToDomain on EpisodeDto {
  Episode toDomain() => Episode(
    id: id ?? const Uuid().v4(),
    title: title,
    description: description,
    host: host,
    createdAt: createdAt != null
        ? DateTime.fromMillisecondsSinceEpoch(createdAt! * 1000)
        : null,
  );
}
