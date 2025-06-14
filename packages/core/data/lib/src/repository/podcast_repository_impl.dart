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
  Future<Result<List<Episode>>> fetchEpisodes() async {
    try {
      final List<EpisodeDto> dtos = await _apiService.fetchEpisodes();
      final List<Episode> episodes = dtos.map((dto) => dto.toDomain()).toList();
      return Result.success(episodes);
    } on DioException catch (e) {
      _logger.e(
        'PodcastRepositoryImpl::fetchEpisodes: Failed to get episodes: $e',
      );
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
      _logger.e(
        'PodcastRepositoryImpl::fetchEpisodes: An unexpected error occurred: $e',
      );
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Episode>> fetchEpisode(String id) async {
    try {
      final EpisodeDto dto = await _apiService.fetchEpisode(id);
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      _logger.e(
        'PodcastRepositoryImpl::fetchEpisodes: Failed to get episodes: $e',
      );
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
      _logger.e(
        'PodcastRepositoryImpl::fetchEpisodes: An unexpected error occurred: $e',
      );
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Episode>> createEpisode(Episode episode) async {
    try {
      final EpisodeDto responseDto = await _apiService.createEpisode(
        episode.toDto(),
      );
      return Result.success(responseDto.toDomain());
    } on DioException catch (e) {
      _logger.e(
        'PodcastRepositoryImpl::createEpisode: Failed to create episode: $e',
      );
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
      _logger.e(
        'PodcastRepositoryImpl::createEpisode: An unexpected error occurred: $e',
      );
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Episode>> updateEpisode(Episode episode) async {
    try {
      if (episode.id.isEmpty) {
        return Result.failure(
          ValidationFailure(message: 'Episode ID cannot be empty for update.'),
        );
      }
      final EpisodeDto responseDto = await _apiService.updateEpisode(
        episode.id,
        episode.toDto(),
      );
      return Result.success(responseDto.toDomain());
    } on DioException catch (e) {
      _logger.e(
        'PodcastRepositoryImpl::updateEpisode: Failed to update episode: $e',
      );
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
      _logger.e(
        'PodcastRepositoryImpl::updateEpisode: An unexpected error occurred: $e',
      );
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteEpisode(String id) async {
    try {
      await _apiService.deleteEpisode(id);
      return Result.success(true);
    } on DioException catch (e) {
      _logger.e(
        'PodcastRepositoryImpl::deleteEpisode: Failed to update episode: $e',
      );
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
      _logger.e(
        'PodcastRepositoryImpl::deleteEpisode: An unexpected error occurred: $e',
      );
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }
}
