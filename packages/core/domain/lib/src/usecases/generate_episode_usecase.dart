import 'package:core_domain/domain.dart';

class GenerateEpisodeUseCase {
  final LlmGenerateRepository _repository;

  const GenerateEpisodeUseCase(this._repository);

  Future<Result<String>> call(String prompt) async {
    return await _repository.generateText(prompt);
  }
}
