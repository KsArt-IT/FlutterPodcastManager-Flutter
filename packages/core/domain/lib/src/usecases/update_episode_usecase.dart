import 'package:core_domain/domain.dart';

class UpdateEpisodeUseCase {
  final PodcastRepository _repository;

  const UpdateEpisodeUseCase(this._repository);

  Future<Result<Episode>> call(Episode episode) async {
    return await _repository.updateEpisode(episode);
  }
}
