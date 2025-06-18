import 'package:json_annotation/json_annotation.dart';

part 'deepseek_choice_dto.g.dart';

@JsonSerializable()
class DeepSeekChoiceDto {
  final String text;

  const DeepSeekChoiceDto({required this.text});

  factory DeepSeekChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$DeepSeekChoiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeepSeekChoiceDtoToJson(this);
}
