import 'package:core_data/data.dart';
import 'package:retrofit/retrofit.dart';

part 'deepseek_api_service.g.dart';

@RestApi(baseUrl: 'https://api.deepseek.com/v1')
abstract class DeepSeekApiService implements ApiService<DeepSeekResponse> {
  factory DeepSeekApiService(Dio dio, {String baseUrl}) = _DeepSeekApiService;

  @override
  @POST("/chat/completions")
  Future<DeepSeekResponse> generateText({
    @Header("Authorization") required String apiKey,
    @Path("provider") required String provider,
    @Path("version") required String version,
    @Body() required Map<String, dynamic> body,
  });
}
