import 'package:core_data/data.dart';
import 'package:core_domain/domain.dart';
import 'package:logger/logger.dart';

class HuggingFaceGenerateRepositoryImpl implements LlmGenerateRepository {
  final ApiService<HuggingFaceResponse> service;
  final String apiKey;
  final Logger _logger = Logger();

  HuggingFaceGenerateRepositoryImpl({
    required this.service,
    required this.apiKey,
  });

  @override
  Future<Result<String>> generateText(String prompt) async {
    try {
      final data = await service.generateText(
        apiKey: "Bearer $apiKey",
        provider: "nebius",
        version: "v1",
        body: {
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt},
          ],
          "model": "google/gemma-2-2b-it",
          "stream": false,
        },
      );
      final generatedText = data.choices.first.message.content;
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
