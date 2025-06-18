import 'package:core_data/data.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'huggingface_api_service.g.dart';

@RestApi(baseUrl: "https://router.huggingface.co")
abstract class HuggingFaceApiService
    implements ApiService<HuggingFaceResponse> {
  factory HuggingFaceApiService(Dio dio, {String baseUrl}) =
      _HuggingFaceApiService;

  @override
  @POST("/{provider}/{version}/chat/completions")
  Future<HuggingFaceResponse> generateText({
    @Header("Authorization") required String apiKey,
    @Path("provider") required String provider,
    @Path("version") required String version,
    @Body() required Map<String, dynamic> body,
  });
}
