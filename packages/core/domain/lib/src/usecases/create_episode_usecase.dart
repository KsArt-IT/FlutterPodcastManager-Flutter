import 'package:core_domain/domain.dart';

class CreateEpisodeUseCase {
  final PodcastRepository _repository;

  const CreateEpisodeUseCase(this._repository);

  Future<Result<Episode>> call(Episode episode) async {
    return await _repository.createEpisode(episode);
  }
}
