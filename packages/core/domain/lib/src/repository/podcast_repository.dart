import 'package:core_domain/domain.dart';

abstract interface class PodcastRepository {
  Future<Result<List<Episode>>> fetchEpisodes({
    required int page,
    required int limit,
  });
  Future<Result<Episode>> fetchEpisode(String id);
  Future<Result<Episode>> createEpisode(Episode episode);
  Future<Result<Episode>> updateEpisode(Episode episode);
  Future<Result<bool>> deleteEpisode(String id);
}
