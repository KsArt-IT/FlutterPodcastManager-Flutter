import 'package:core_data/data.dart';
import 'package:core_domain/domain.dart';
import 'package:logger/logger.dart';

class DeepSeekGenerateRepositoryImpl implements LlmGenerateRepository {
  final ApiService<DeepSeekResponse> service;
  final String apiKey;
  final Logger _logger = Logger();

  DeepSeekGenerateRepositoryImpl({required this.service, required this.apiKey});

  @override
  Future<Result<String>> generateText(String prompt) async {
    try {
      final data = await service.generateText(
        apiKey: "Bearer $apiKey",
        provider: "",
        version: "",
        body: {
          "model": "deepseek-chat",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt},
          ],
          "temperature": 1,
        },
      );
      final generatedText = data.choices.first.text;
      return Result.success(generatedText);
    } on DioException catch (e) {
      _logger.e(
        'LlmGenerateRepositoryImpl::generateAlternative: Dio error: $e',
      );
      if (e.response != null) {
        final String message =
            e.response!.statusMessage ?? e.response!.data.toString();
        return Result.failure(
          ServerFailure(message: message, code: e.response!.statusCode),
        );
      }
      return Result.failure(
        NetworkFailure(message: e.message ?? 'Unknown network error'),
      );
    } catch (e) {
      _logger.e(
        'LlmGenerateRepositoryImpl::generateAlternative: Unexpected error: $e',
      );
      return Result.failure(UnknownFailure(message: e.toString()));
    }
  }
}
