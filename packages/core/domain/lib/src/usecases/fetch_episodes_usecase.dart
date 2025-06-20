import 'package:core_domain/domain.dart';

class FetchEpisodesUseCase {
  final PodcastRepository _repository;

  const FetchEpisodesUseCase(this._repository);

  Future<Result<List<Episode>>> call({
    required int page,
    required int limit,
  }) async {
    return await _repository.fetchEpisodes(page: page, limit: limit);
  }
}
