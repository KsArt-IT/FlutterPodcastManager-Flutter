import 'package:core_data/src/models/deepseek/deepseek_choice_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deepseek_response.g.dart';

@JsonSerializable()
class DeepSeekResponse {
  final List<DeepSeekChoiceDto> choices;

  const DeepSeekResponse({required this.choices});

  factory DeepSeekResponse.fromJson(Map<String, dynamic> json) =>
      _$DeepSeekResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeepSeekResponseToJson(this);
}
