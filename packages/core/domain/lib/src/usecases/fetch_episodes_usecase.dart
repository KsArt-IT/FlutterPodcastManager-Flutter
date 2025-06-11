import 'package:core_domain/domain.dart';

class FetchEpisodesUseCase {
  final PodcastRepository _repository;

  FetchEpisodesUseCase(this._repository);

  Future<Result<List<Episode>>> call() async {
    return await _repository.fetchEpisodes();
  }
}
