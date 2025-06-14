import 'package:core_domain/domain.dart';

class DeleteEpisodeUseCase {
  final PodcastRepository _repository;

  const DeleteEpisodeUseCase(this._repository);

  Future<Result<bool>> call(String id) async {
    return await _repository.deleteEpisode(id);
  }
}
