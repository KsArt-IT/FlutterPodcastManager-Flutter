import 'package:core_data/src/models/huggingface/chat_choice_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hugging_face_response.g.dart';

@JsonSerializable()
class HuggingFaceResponse {
  final List<ChatChoiceDto> choices;

  HuggingFaceResponse({required this.choices});

  factory HuggingFaceResponse.fromJson(Map<String, dynamic> json) =>
      _$HuggingFaceResponseFromJson(json);
}
