import 'package:core_domain/domain.dart';

class FetchEpisodeUseCase {
  final PodcastRepository _repository;

  const FetchEpisodeUseCase(this._repository);

  Future<Result<Episode>> call(String id) async {
    return await _repository.fetchEpisode(id);
  }
}
