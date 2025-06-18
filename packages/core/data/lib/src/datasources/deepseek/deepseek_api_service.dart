import 'package:core_data/src/models/deepseek/deepseek_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'deepseek_api_service.g.dart';

@RestApi(baseUrl: 'https://api.deepseek.com/v1')
abstract class DeepSeekApiService {
  factory DeepSeekApiService(Dio dio, {String baseUrl}) = _DeepSeekApiService;

  @POST("/chat/completions")
  Future<DeepSeekResponse> generateText({
    @Header('Authorization') required String apiKey,
    @Body() required Map<String, dynamic> body,
  });
}
