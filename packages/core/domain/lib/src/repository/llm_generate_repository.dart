import 'package:core_domain/domain.dart';

abstract interface class LlmGenerateRepository {
  Future<Result<String>> generateText(String prompt);
}
