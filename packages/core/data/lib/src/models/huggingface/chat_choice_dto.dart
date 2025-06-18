import 'package:core_data/src/models/huggingface/chat_completion_message_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_choice_dto.g.dart';

@JsonSerializable()
class ChatChoiceDto {
  final ChatCompletionMessageDto message;

  ChatChoiceDto({required this.message});

  factory ChatChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$ChatChoiceDtoFromJson(json);
}
