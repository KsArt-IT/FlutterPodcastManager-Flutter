import 'package:core_data/src/datasources/podcast_api_service.dart';
import 'package:core_data/src/mappers/domain_to_dto.dart';
import 'package:core_data/src/mappers/dto_to_domain.dart';
import 'package:core_data/src/models/episode_dto.dart';
import 'package:core_domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class PodcastRepositoryImpl implements PodcastRepository {
  final PodcastApiService _apiService;
  final Logger _logger = Logger();

  PodcastRepositoryImpl({required PodcastApiService service})
    : _apiService = service;

  @override
  Future<Result<List<Episode>>> fetchEpisodes() {
    return _fetchData<List<EpisodeDto>, List<Episode>>(
      () => _apiService.fetchEpisodes(),
      mapper: (dtos) => dtos.map((e) => e.toDomain()).toList(),
      context: 'PodcastRepositoryImpl::fetchEpisodes',
    );
  }

  @override
  Future<Result<Episode>> fetchEpisode(String id) {
    return _fetchData<EpisodeDto, Episode>(
      () => _apiService.fetchEpisode(id),
      mapper: (dto) => dto.toDomain(),
      context: 'PodcastRepositoryImpl::fetchEpisode',
    );
  }

  @override
  Future<Result<Episode>> createEpisode(Episode episode) {
    return _fetchData<EpisodeDto, Episode>(
      () => _apiService.createEpisode(episode.toDto()),
      mapper: (dto) => dto.toDomain(),
      context: 'PodcastRepositoryImpl::createEpisode',
    );
  }

  @override
  Future<Result<Episode>> updateEpisode(Episode episode) {
    if (episode.id.isEmpty) {
      return Future.value(
        Result.failure(
          ValidationFailure(message: 'Episode ID cannot be empty for update.'),
        ),
      );
    }

    return _fetchData<EpisodeDto, Episode>(
      () => _apiService.updateEpisode(episode.id, episode.toDto()),
      mapper: (dto) => dto.toDomain(),
      context: 'PodcastRepositoryImpl::updateEpisode',
    );
  }

  @override
  Future<Result<bool>> deleteEpisode(String id) {
    return _executeRequest<bool>(() async {
      await _apiService.deleteEpisode(id);
      return true;
    }, context: 'PodcastRepositoryImpl::deleteEpisode');
  }

  Future<Result<R>> _fetchData<T, R>(
    Future<T> Function() call, {
    required R Function(T dto) mapper,
    required String context,
  }) async {
    return _executeRequest<R>(
      () async => mapper(await call()),
      context: context,
    );
  }

  Future<Result<T>> _executeRequest<T>(
    Future<T> Function() call, {
    required String context,
  }) async {
    try {
      final result = await call();
      return Result.success(result);
    } on DioException catch (e) {
      _logger.e('$context: Dio error: $e');
      if (e.response != null) {
        return Result.failure(
          ServerFailure(
            message: e.response!.data.toString(),
            code: e.response!.statusCode,
          ),
        );
      }
      return Result.failure(
        NetworkFailure(message: e.message ?? 'Unknown network error'),
      );
    } catch (e) {
      _logger.e('$context: Unexpected error: $e');
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }
}
