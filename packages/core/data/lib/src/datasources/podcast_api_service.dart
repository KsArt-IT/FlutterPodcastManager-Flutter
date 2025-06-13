import 'package:core_data/src/models/episode_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'podcast_api_service.g.dart';

@RestApi(baseUrl: "https://684806bfec44b9f3493f5752.mockapi.io/api/v1")
abstract class PodcastApiService {
  factory PodcastApiService(Dio dio, {String baseUrl}) = _PodcastApiService;

  @GET('/episodes')
  Future<List<EpisodeDto>> fetchEpisodes();

  @GET('/episodes/{id}')
  Future<EpisodeDto> fetchEpisode(
    @Path('id') String id,
  );

  @POST('/episodes')
  Future<EpisodeDto> createEpisode(@Body() EpisodeDto episode);

  @PUT('/episodes/{id}')
  Future<EpisodeDto> updateEpisode(
    @Path('id') String id,
    @Body() EpisodeDto episode,
  );
}
